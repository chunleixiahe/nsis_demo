unit Unit_ProcTools;

interface

uses
  Windows,
  PSAPI,
  TlHelp32,
  SysUtils;

type
  TPIDList = array of DWORD;

type
  TTIDList = array of DWORD;

function GetProcessList(var ProcessList: TPIDList): DWORD;
function GetProcessName(PID: DWORD; var ProcessName: string): DWORD;
function GetProcessThreadList(PID: DWORD; var TList: TTIDList):DWORD;
procedure SuspendProcess(PID: DWORD; Resume: Boolean);
function KillProcess(PID: DWORD):Boolean;

const
  THREAD_SUSPEND_RESUME: DWORD = $0002;

function OpenThread(Access: DWORD; InheritHandle: Boolean; TID:DWORD): THandle; stdcall; external 'kernel32.dll' name 'OpenThread';

implementation

function GetProcessName(PID: DWORD; var ProcessName: string): DWORD;
var
  dwReturn     : DWORD;
  hProc        : Cardinal;
  buffer       : array[0..MAX_PATH - 1] of Char;
begin
  dwReturn := 0;
  Zeromemory(@buffer, sizeof(buffer));
  hProc := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, PID);
  if hProc <> 0 then
  begin
    GetModulebaseName(hProc, 0, buffer, sizeof(buffer));
    ProcessName := (string(buffer));
    CloseHandle(hProc);
  end
  else
    dwReturn := GetLastError;
  result := dwReturn;
end;

function GetProcessList(var ProcessList: TPIDList): DWORD;

  function GetOSVersionInfo(var Info: TOSVersionInfo): Boolean;
  begin
    FillChar(Info, SizeOf(TOSVersionInfo), 0);
    Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
    if (not Result) then
    begin
      FillChar(Info, SizeOf(TOSVersionInfo), 0);
      Info.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
      Result := GetVersionEx(TOSVersionInfo(Addr(Info)^));
      if (not Result) then
        Info.dwOSVersionInfoSize := 0;
    end;
  end;

var
  dwReturn     : DWORD;
  OS           : TOSVersionInfo;
  // EnumProcesses
  PidProcesses : PDWORD;
  PidWork      : PDWORD;
  BufferSize   : Cardinal;
  Needed       : DWORD;
  cntProcesses : Cardinal;
  i            : Cardinal;
  // CreateToolhelp32Snapshot
  hProcSnapShot: THandle;
  pe32         : TProcessEntry32;
  j            : Cardinal;

begin
  dwReturn := 0;
  // What OS are we running on?
  if GetOSVersionInfo(OS) then
  begin
    if (OS.dwPlatformId = VER_PLATFORM_WIN32_NT) and (OS.dwMajorVersion = 4) then
    // WinNT and higher
    begin
      Needed := 0;
      BufferSize := 1024;
      GetMem(PidProcesses, BufferSize);
      // make sure memory is allocated
      if Assigned(PidProcesses) then
      begin
        try
          // enumerate the processes
          if EnumProcesses(PidProcesses, BufferSize, Needed) then
          begin
            dwReturn := 0;
            cntProcesses := Needed div sizeof(DWORD) - 1;
            PidWork := PidProcesses;
            setlength(ProcessList, cntProcesses);
            // walk the processes
            for i := 0 to cntProcesses - 1 do
            begin
              ProcessList[i] := PidWork^;
              Inc(PidWork);
            end;
          end
          else // EnumProcesses = False
            dwReturn := GetLastError;
        finally
          // clean up no matter what happend
          FreeMem(PidProcesses, BufferSize);
        end;
      end
      else // GetMem = nil
        dwReturn := GetLastError;
    end
    // Win 9x and higher except WinNT
    else
    begin
      // make the snapshot
      hProcSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      if hProcSnapShot <> INVALID_HANDLE_VALUE then
      begin
        pe32.dwSize := sizeof(TProcessEntry32);
        j := 0;
        setlength(ProcessList, j + 1);
        if Process32First(hProcSnapShot, pe32) then
        begin
          // first process
          ProcessList[j] := pe32.th32ProcessID;
          // walk the processes
          while Process32Next(hProcSnapShot, pe32) do
          begin
            Inc(j);
            setlength(ProcessList, j + 1);
            ProcessList[j] := pe32.th32ProcessID;
          end;
        end
        else // Process32First = False
          dwReturn := GetLastError;
        CloseHandle(hProcSnapShot);
      end
      else // hSnapShot = INVALID_HANDLE_VALUE
        dwReturn := GetLastError;
    end;
  end;
  result := dwReturn;
end;

function GetProcessThreadList(PID: DWORD; var TList: TTIDList):DWORD;
var
  Snap: THandle;
  Info: tagTHREADENTRY32;
begin
  Result := 0;
  SetLength(TList, 0);

  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  if Snap = INVALID_HANDLE_VALUE then Exit;

  ZeroMemory(@Info, sizeOf(tagTHREADENTRY32));
  Info.dwSize := sizeOf(tagTHREADENTRY32);

  if not Thread32First(Snap, Info) then begin
    CloseHandle(Snap);
    Exit;
  end;

  if Info.th32OwnerProcessID = PID then begin
    SetLength(TList, 1);
    TList[0] := Info.th32ThreadID;
    Result := 1;
  end;

  while Thread32Next(Snap, Info) do begin
    if Info.th32OwnerProcessID = PID then begin
      SetLength(TList, Length(TList) + 1);
      TList[Length(TList)-1] := Info.th32ThreadID;
      Result := Result + 1;
    end;
  end;

  CloseHandle(Snap);
end;

procedure SuspendProcess(PID: DWORD; Resume: Boolean);
var
  TList: TTIDList;
  i,x:Integer;
  TID: DWORD;
  h: THandle;
begin
  x := GetProcessThreadList(PID, TList);
  if x < 1 then Exit;

  for i := 1 to x do begin
    TID := TList[i-1];
    h := OpenThread(THREAD_SUSPEND_RESUME, True, TID);
    if h <> INVALID_HANDLE_VALUE then begin
      if Resume
        then ResumeThread(h)
        else SuspendThread(h);
      CloseHandle(h);
    end;
  end;
end;

function KillProcess(PID: DWORD):Boolean;
var
  PHandle: DWORD;
begin
  PHandle := OpenProcess(PROCESS_TERMINATE,false,PID);

  if PHandle = 0 then begin
    Result := False;
    Exit;
  end;

  Result := TerminateProcess(PHandle,0);
end;

end.
