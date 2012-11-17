
Name "pc_name"
OutFile "pc_name.exe"
ShowInstDetails show
!include "WordFunc.nsh"


Section  "changePcName"


;先取得计算机名字
;HKEY_LOCAL_MACHINE\System\CurrenControlSet\Control\ComputerName\ComputerName

ReadRegDWORD $0 HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName"

;提示一下；程序检测到您的计算机名含有小写字母，是否允许程序修改成大写，并且重启计算机？



DetailPrint "更改前计算机的名字:$0"

;StrCpy  $0  "zhu-pc"

	${StrFilter} $0 "+" "" "" $R0
	;ABC
	StrCmpS  $0 $R0  same  diff
	same:
	DetailPrint  "不用重启"
	Goto over
	diff:
	
	DetailPrint  "计算机名含有小写字母,需要更改为大写"
	
	
	
System::Call `User32::CharUpper(t "$0" r0)`

;MessageBox MB_ICONINFORMATION|MB_OK "$0"

;设置计算机的名字为大写
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

DetailPrint "更改后计算机的名字:$0"

;系统需要重启

MessageBox MB_YESNO|MB_ICONQUESTION "需要重启系统，请重启后重新安装本程序。" IDNO +2
  Reboot
Goto over
over:

SectionEnd






