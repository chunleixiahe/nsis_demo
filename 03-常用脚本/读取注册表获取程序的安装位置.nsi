
Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

;ɾ��mssql�İ�װ�ļ���
Section "remove_mssql_folder"

	ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\MSSQLServer\Setup" SQLPath
  DetailPrint "SQL��װλ��: $0"


	;��ȡϵͳ�̷�
  DetailPrint "ϵͳĿ¼: $WINDIR"
  StrCpy $0 $WINDIR 3  ;��ȡ���������ַ�
	DetailPrint "ϵͳ�����̷� $0"  ;��ȡϵͳ�̷�


	;������÷����Ǻ����� HKLM Software\NSIS ����������
	ReadRegStr $0 HKLM Software\NSIS ""
	DetailPrint "NSIS is installed at: $0"
	

SectionEnd
