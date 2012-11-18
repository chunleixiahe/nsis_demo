

;SQL Server 2000的一键安装，检查之前是否已经安装了sql2000
;如果已经安装了，其版本号是多少，如果没有打补丁，那么就仅仅打补丁，如果大了补丁，仅检查服务是否正常。把没有启动的启动就好了。
;如果没有安装，那么先清理可能存在的垃圾。包括验证计算机名字中是否含有小写字母。
;安装的时候弹出框指定sa的密码，取到sa密码更新sql的两个配置文件，执行静默安装。

Name "安装SQL Server 2000"
OutFile "安装SQL Server 2000.exe"
ShowInstDetails show

!include "FileFunc.nsh"
!include "WordFunc.nsh"


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
  
	;检查是否安装了SQL Server

	StrCmp $has "true" is0 other0
	is0:
	  DetailPrint "已经安装了SQL Server"
	  Abort "程序退出"
  Goto checkend
  other0:
    DetailPrint "还没有安装SQL Server"
  Goto checkend
	checkend:
	;检查是否安装了SQL Server end
	

	StrCmp $R0  10  hasExist  noExist
	hasExist:
	SimpleSC::GetServiceStatus "$serviceName"
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
		isRuning:
    DetailPrint "$serviceName服务正在运行"
    Goto checkend0
    noRuning:
    
    DetailPrint "$serviceName服务没有正在运行"
    SimpleSC::StartService "$serviceName" "" 30
    Pop $0
    IntCmp $1 0 runover0  otherRunover
    runover0:
    DetailPrint "$serviceName服务启动成功"
    Goto checkend0
    otherRunover:
    DetailPrint "$serviceName服务启动失败"
    Goto checkend0

	Goto checkend0

	noExist:

	;进入下面的Section执行安装
	Goto checkend0
	checkend0:
	
SectionEnd

;上面主要做了，有服务的情况下启动服务
Section  "install_sql"

		StrCmp $has "true" is0 other0
		is0:
		  DetailPrint "已经安装了SQL Server"
		  Abort "程序退出"
	  Goto checkend
	  other0:
	    ;DetailPrint "还没有安装SQL Server"
	  Goto checkend
		checkend:
		;释放 已经打了包的文件


	
SectionEnd



















