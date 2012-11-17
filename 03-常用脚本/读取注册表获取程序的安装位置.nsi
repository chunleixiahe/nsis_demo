
Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

;删除mssql的安装文件夹
Section "remove_mssql_folder"

	ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\MSSQLServer\Setup" SQLPath
  DetailPrint "SQL安装位置: $0"


	;获取系统盘符
  DetailPrint "系统目录: $WINDIR"
  StrCpy $0 $WINDIR 3  ;截取左侧的三个字符
	DetailPrint "系统所在盘符 $0"  ;获取系统盘符


	;下面的用法不是很明白 HKLM Software\NSIS 根本不存在
	ReadRegStr $0 HKLM Software\NSIS ""
	DetailPrint "NSIS is installed at: $0"
	

SectionEnd
