
Name "pc_name"
OutFile "pc_name.exe"
ShowInstDetails show
!include "WordFunc.nsh"


Section  "changePcName"


;��ȡ�ü��������
;HKEY_LOCAL_MACHINE\System\CurrenControlSet\Control\ComputerName\ComputerName

ReadRegDWORD $0 HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName"

;��ʾһ�£������⵽���ļ����������Сд��ĸ���Ƿ���������޸ĳɴ�д�����������������



DetailPrint "����ǰ�����������:$0"

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

;ϵͳ��Ҫ����

MessageBox MB_YESNO|MB_ICONQUESTION "��Ҫ����ϵͳ�������������°�װ������" IDNO +2
  Reboot
Goto over
over:

SectionEnd






