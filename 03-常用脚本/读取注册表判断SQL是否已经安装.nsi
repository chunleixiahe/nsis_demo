
;��ȡ�����Ƿ�������ж��Ƿ�װ��SQLServer��̫���ã���ʱ������ж���ˣ�����ʾ�Ѿ���װ
;����Ϊ�ö�ȡע����еĹ���SQLServer��"���ɾ������"�еļ��Ƿ����


;64λ SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000
;32λ SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000

Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

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

Section "getresult"
		DetailPrint "�Ƿ��Ѿ���װ��MSSQL:$has"
SectionEnd





