;SQL Server 2000��һ����װ�����֮ǰ�Ƿ��Ѿ���װ��sql2000
;����Ѿ���װ�ˣ���汾���Ƕ��٣����û�д򲹶�����ô�ͽ����򲹶���������˲��������������Ƿ���������û�������������ͺ��ˡ�
;���û�а�װ����ô��������ܴ��ڵ�������������֤������������Ƿ���Сд��ĸ��
;��װ��ʱ�򵯳���ָ��sa�����룬ȡ��sa�������sql�����������ļ���ִ�о�Ĭ��װ��

Name "��װSQL Server 2000"
OutFile "��װSQL Server 2000.exe"
ShowInstDetails show

!include "FileFunc.nsh"
!include "WordFunc.nsh"
!include "TextFunc.nsh"

Var  has
Section "readReg"

	 	ReadRegDWORD $0 HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000" InstallLocation
		StrLen $1 $0
		IntCmp  $1 0  not has
    has:
		StrCpy $has "true"
 		Return
		not:
    ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000" InstallLocation
		StrLen $1 $0
		IntCmp  $1 0 not0 has0
		has0:
		StrCpy $has "true"
		Goto end0
		not0:
		StrCpy $has "false"
		Goto end0
		end0:
SectionEnd




Var serviceName
Section "checksql_Status"
  
	;����Ƿ�װ��SQL Server

	StrCmp $has "true" is0 other0
	is0:
	  DetailPrint "�Ѿ���װ��SQL Server"
	  Abort "�����˳�"
  Goto checkend
  other0:
    DetailPrint "��û�а�װSQL Server"
  Goto checkend
	checkend:
	;����Ƿ�װ��SQL Server end
	

	StrCmp $R0  10  hasExist  noExist
	hasExist:
	SimpleSC::GetServiceStatus "$serviceName"
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
		isRuning:
    DetailPrint "$serviceName������������"
    Goto checkend0
    noRuning:
    
    DetailPrint "$serviceName����û����������"
    SimpleSC::StartService "$serviceName" "" 30
    Pop $0
    IntCmp $1 0 runover0  otherRunover
    runover0:
    DetailPrint "$serviceName���������ɹ�"
    Goto checkend0
    otherRunover:
    DetailPrint "$serviceName��������ʧ��"
    Goto checkend0

	Goto checkend0

	noExist:

	;���������Sectionִ�а�װ
	Goto checkend0
	checkend0:
	
SectionEnd


;�����������к���Сд��ĸ��ȫ���ĳɴ�д��Ȼ�����������������
Section  "changePcName"

;��ȡ�ü��������
;HKEY_LOCAL_MACHINE\System\CurrenControlSet\Control\ComputerName\ComputerName

ReadRegDWORD $0 HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName"

;��ʾһ�£������⵽���ļ����������Сд��ĸ���Ƿ���������޸ĳɴ�д�����������������



DetailPrint "��ǰ�����������:$0"

;StrCpy  $0  "zhu-pc"

	${StrFilter} $0 "+" "" "" $R0
	;ABC
	StrCmpS  $0 $R0  same  diff
	same:
	DetailPrint  "��������"
	Goto over
	diff:

	DetailPrint  "�����������Сд��ĸ,��Ҫ����Ϊ��д"



System::Call `User32::CharUpper(t "$0" r0)`

;MessageBox MB_ICONINFORMATION|MB_OK "$0"

;���ü����������Ϊ��д
;HKLM "SYSTEM\ControlSet001\Control\ComputerName\ActiveComputerName"
;HKLM "SYSTEM\ControlSet001\Control\ComputerName\ComputerName"

;HKLM "SYSTEM\ControlSet002\Control\ComputerName\ComputerName"

;HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName"
;HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName"

	WriteRegStr HKLM "SYSTEM\ControlSet001\Control\ComputerName\ActiveComputerName" "ComputerName" "$0"
	WriteRegStr HKLM "SYSTEM\ControlSet001\Control\ComputerName\ComputerName" "ComputerName" "$0"
	WriteRegStr HKLM "SYSTEM\ControlSet002\Control\ComputerName\ComputerName" "ComputerName" "$0"
	WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName" "$0"
	WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" "ComputerName" "$0"


ReadRegDWORD $0 HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName"

DetailPrint "���ĺ�����������:$0"

;ϵͳ��Ҫ���������ѡ����false��������������Ҳ������������һ��������û����֤�Ƿ�������������ע������漰����Сд��������ĳɴ�д��
;�Ƿ�Ӱ��sql2000�İ�װ


MessageBox MB_YESNO|MB_ICONQUESTION "��Ҫ����ϵͳ�������������°�װ������" IDNO +2
  Reboot
Goto over
over:

SectionEnd




Var sysroot

;������Ҫ���ˣ��з����������������� ;��sqlserver�İ�װ�ļ���ѹ������
Section  "release_files"

		StrCmp $has "true" is0 other0
		is0:
		  DetailPrint "�Ѿ���װ��SQL Server"
		  Abort "�����˳�"
	  Goto checkend
	  other0:
	    ;DetailPrint "��û�а�װSQL Server"
	  Goto checkend
		checkend:
		;�ͷ� �Ѿ����˰����ļ�

		DetailPrint "�����Ѽ��ļ�[C:\appdisk\sqlserver\personal\*]"

    StrCpy $sysroot $WINDIR 3  ;��ȡ���������ַ�  c:\ ;;;;
    
		DetailPrint "ϵͳ�����̷� $sysroot"  ;��ȡϵͳ�̷� c:\  ;;;;
		
		SetOverwrite on

		SetOutPath "$sysroot\sqlserver\personal\" ;��ʱ�Ľ�ѹĿ¼���Ժ��ѹ�����������
		File /r "C:\appdisk\sqlserver\personal\*"  ;�������ռ���װ�ļ������������

    SetOutPath "$sysroot\sqlserver\sp4\" ;��ʱ�Ľ�ѹĿ¼���Ժ��ѹ�����������
		File /r "C:\appdisk\sqlserver\sp4\*"  ;�������ռ���װ�ļ������������
SectionEnd


;����ܹ��ߵ�����˵��û�а�װsqlserver�����ǰ�װǰ��Ҫ����һ�¿��ܴ��ڵ�����

;ɱ����������ʹ�õĲ�ѯ����������ҵ������ KillProc���ܹر�64λ��Ӧ�ó���!
Section "clear_kill_ps"

  KillProcDLL::KillProc "isqlw.exe"
	DetailPrint "�رղ�ѯ������$R0"
	KillProcDLL::KillProc "mmc.exe"
	DetailPrint "�ر���ҵ������$R0"

SectionEnd

Section  "clear_remove_mssql_service"

 	StrCpy $serviceName "MSSQLSERVER"
  Call clear_findService_stop_remove

  StrCpy $serviceName "MSSQLServerADHelper"
  Call clear_findService_stop_remove

  StrCpy $serviceName "SQLSERVERAGENT"
  Call clear_findService_stop_remove
SectionEnd


;ɾ��mssql�İ�װ�ļ���
Section "clear_remove_mssql_folder"

  ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\MSSQLServer\Setup" SQLPath
  DetailPrint "SQL��װλ��: $0" ;C:\Program Files (x86)\Microsoft SQL Server\MSSQL
	StrCpy $9 $0 -5
	DetailPrint "$9"


  StrCpy $1 "$0\Data"

	;��ȡϵͳ�̷�
  DetailPrint "ϵͳĿ¼: $WINDIR"
  StrCpy $0 $WINDIR 3  ;��ȡ���������ַ�
	DetailPrint "ϵͳ�����̷� $0"  ;��ȡϵͳ�̷�


	;���������ļ�
	StrCpy $7 $1
	StrCpy $8 $0
	${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6  ;������ʱ����
	CopyFiles /SILENT  "$7" "$8\sqldata_bak_$2_$1_$0_$4_$5_$6"

	IfErrors err noerr
  err:
  DetailPrint "�����ļ�ʱ�������󣺿���ԭ�ļ�������"
	Goto over
	noerr:
	DetailPrint "û�з�������"
	MessageBox MB_OK "�ļ����Ѿ�ɾ������\n���ݿ��ļ��Ѿ����ݵ�$8\sqldata_bak_$2_$1_$0_$4_$5_$6"
	Goto over
	over:

	;ɾ���ļ��� $9 "C:\Program Files (x86)\Microsoft SQL Server\"
 	RMDir /r /REBOOTOK $9

 	Delete $WINDIR\sqlstp.log
  Delete $WINDIR\sqlsp.log

SectionEnd

;ɾ��mssql��ص�ע�����Ϣ
Section  "clear_remove_mssql_regedit"

  ;�������
	DeleteRegValue HKLM  "SYSTEM\CurrentControlSet\Control\Session Manager" "PendingFileRenameOperations"
	DetailPrint  "delע���:SYSTEM\CurrentControlSet\Control\Session Manager->PendingFileRenameOperations"


  DeleteRegKey HKLM  "SOFTWARE\Microsoft\MSSQLServer"
  DetailPrint  "delע���:SOFTWARE\Microsoft\MSSQLServer"

  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Microsoft SQL Server"
  DetailPrint  "delע���:SOFTWARE\Microsoft\Microsoft SQL Server"

  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServer"  ;��ʵ�����Ѿ�ɾ����[������Ȼ������������ֹͣ����]
  DetailPrint "delע���:SYSTEM\CurrentControlSet\Services\MSSQLServer"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT" ;��ʵ�����Ѿ�ɾ����
  DetailPrint   "delע���:SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper" ;��ʵ����ɾ����
  DetailPrint  "delע���:SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper"

	;ɾ�������ط�
	DeleteRegKey HKCU  "Software\Microsoft\Microsoft SQL Server"
	DetailPrint  "delע���:Software\Microsoft\Microsoft SQL Server"

	;Wow6432Node��64λϵͳ�ϵ�λ��
  DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

	;������32λϵͳ�ϵ�λ��
  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

 	DetailPrint  "ɾ��ע���over"

SectionEnd




;���sql��صķ����Ƿ���ڣ�������ھ�ֹͣ����Ȼ��ɾ��
;windows����Ĳ��:SimpleSC
Function  clear_findService_stop_remove

	SimpleSC::ExistsService $serviceName
  Pop $0

	IntCmp $0 0 is0 lessthan0 morethan0
	is0:
	  DetailPrint "$serviceName�������"

		;��鵱ǰ�ķ����״̬
		SimpleSC::GetServiceStatus "$serviceName"
	  Pop $0
	  IntCmp $0 0 is000 lessthan000 morethan000
    is000:
		;DetailPrint "$serviceName��ѯ����״̬:�ɹ�"
		Goto getStatus
 		lessthan000:
		;DetailPrint "$serviceName��ѯ����״̬:ʧ��"
		Goto done
		morethan000:
		;DetailPrint "$serviceName��ѯ����״̬:ʧ��"
    Goto done
		getStatus:
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
    isRuning:
    DetailPrint "$serviceName������������"
		Goto stop
    noRuning:
    DetailPrint "$serviceName����û����������"
  	Goto rmservice

		stop:
	  SimpleSC::StopService "$serviceName" 1 30
	  Pop $0
	  IntCmp $0 0 is00 lessthan00 morethan00
    is00:
    DetailPrint "$serviceNameֹͣ�ɹ�"
    Goto rmservice

    rmservice:
    SimpleSC::RemoveService "$serviceName"
    Pop $0
	  IntCmp $0 0 is0000 other
	  is0000:
	  DetailPrint "$serviceNameɾ���ɹ�"
		Goto done
    other:
    DetailPrint "$serviceNameɾ��ʧ��"

		Goto done
    lessthan00:
    DetailPrint "$serviceNameֹͣʧ��"
    Goto done
    morethan00:
    DetailPrint "$serviceNameֹͣʧ��"
	  Goto done
	lessthan0:
	  DetailPrint "$serviceName���񲻴���"
	  Goto done
	morethan0:
	  DetailPrint "$serviceName���񲻴���"
	  Goto done
	done:

FunctionEnd





Var lastLineContent
Var log_name
Var log_result

;ִ������ս�ѹ��ϵ�sql��װ����
Section  "install"
  SetOutPath "$sysroot\sqlserver\personal\"
  DetailPrint "��ʼ��װSQL Server"
  nsExec::ExecToLog   "mySetup.bat" ;��װsql��������
  DetailPrint "SQL Server��װ���"
  ;����Ƿ�װ�ɹ�
  StrCpy $log_result "fail"

	StrCpy $log_name "sqlstp"
	Call "readlog"
	StrCmp $log_result "success" next fail

  fail:

	MessageBox MB_OK "SQLServerʧ��"
  ExecShell "open" "$WINDIR\sqlstp.log"
	Abort "SQLServer ��װʧ��"
	
  next:
  MessageBox MB_OK "SQLServer ��װ�ɹ�"
  
  SetOutPath "$sysroot\sqlserver\sp4\"
  DetailPrint "��ʼ��װSQL Server SP4"
  nsExec::ExecToLog   "mySetup.bat" ;��װsql sp4��������
  DetailPrint "SQL Server SP4��װ���"
	StrCpy $log_name "sqlsp"
	Call "readlog"

  StrCmp $log_result "success" next2 fail2
  fail2:
	MessageBox MB_OK "SQLServer SP4 ��װʧ��"
  DetailPrint "�򿪴�����־"
  ExecShell "open" "$WINDIR\sqlstp.log"
	Abort "SQLServer SP4 ��װʧ��"
	
	next2:
	MessageBox MB_OK "SQLServer SP4 ��װ�ɹ�"

SectionEnd

;��������
Section "start_service"
	StrCpy $serviceName "MSSQLSERVER"
	Call start_service
	
	StrCpy $serviceName "SQLSERVERAGENT"
	Call start_service
	
SectionEnd

Function  start_service

	  ;DetailPrint "$serviceName�������"

		;��鵱ǰ�ķ����״̬
		SimpleSC::GetServiceStatus "$serviceName"
	  Pop $0
	  IntCmp $0 0 is000 lessthan000 morethan000
    is000:
		;DetailPrint "$serviceName��ѯ����״̬:�ɹ�"
		Goto getStatus
  	lessthan000:
    Return
		morethan000:
		Return
		getStatus:
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
    isRuning:
    DetailPrint "$serviceName������������"
		Return
    noRuning:
    DetailPrint "$serviceName����û����������"
  	Goto start

		start:
		SimpleSC::StartService "$serviceName" "" 30
	  Pop $0
	  IntCmp $0 0 is00 other00
    is00:
    DetailPrint "$serviceName�����ɹ�"
    Return
    other00:
    DetailPrint "$serviceName����ʧ��"
    Return

FunctionEnd




Function  readlog

		StrCpy  $0 "$WINDIR\$log_name.log"

		;DetailPrint $0

    ;IfFileExists $0 0 +2
    ;DetailPrint "$0�ļ�����"
    IfFileExists $0 exist noexist
    exist:
		;DetailPrint "$log_name.log��װ��־����"

		${LineFind} "$0" "" -1 "readlastline"

		StrCpy $lastLineContent $lastLineContent 24 -24

		${WordFind} "$lastLineContent" "Installation Succeeded" "+1{" $R0

		StrCmp $R0 "$lastLineContent" notfound found        ; error?
		found:
    DetailPrint "$log_name��װ�ɹ�"
  	StrCpy $log_result "success"
		Return
		notfound:
		DetailPrint "$log_name��װʧ��"
		StrCpy $log_result "fail"
		Return

		noexist:
		DetailPrint "$log_name.log��־�����ڲ���ȷ���Ƿ�װ�ɹ�"
		StrCpy $log_result "fail"
		Abort "ִ�����"
 		Return
FunctionEnd


Function "readlastline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...

	;��ǰ������
	;DetailPrint $9
	StrCpy $lastLineContent $R9
	;��ǰ����
	;DetailPrint $R8

	Push $var ; If $var="StopFileReadFromEnd"  Then exit from function

FunctionEnd
























