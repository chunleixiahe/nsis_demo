
;读取服务是否存在来判断是否安装了SQLServer不太好用，有时候明明卸载了，还提示已经安装
;更改为用读取注册表中的关于SQLServer在"添加删除程序"中的键是否存在


;64位 SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000
;32位 SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000

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
		DetailPrint "是否已经安装了MSSQL:$has"
SectionEnd





