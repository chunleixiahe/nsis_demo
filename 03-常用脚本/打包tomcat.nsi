
;不仅仅是打包tomcat，还有jdk，还有javarebel

Name "打包tomcat"
OutFile "打包tomcat.exe"
ShowInstDetails show

!include "FileFunc.nsh"

Var installroot
Var hasD
;有d盘就设置在d盘，没有d盘就设置在系统所在盘符
Section  "设置tomcat的安装目录"

	StrCpy $hasD "false"
	
  DetailPrint "开始安装tomcat"

  StrCpy $installroot $WINDIR 3  ;截取左侧的三个字符  c:\ ;;;;
	DetailPrint "系统所在盘符 $installroot"  ;获取系统盘符 c:\  ;;;;

	;查找有没有D盘，如果有D盘，就使用D盘，否则使用系统所在的根目录。比如c:\meilian\;
	
  StrCmp hasD "false"  has no
  has:
  StrCpy $installroot "D:\meilian\"
	Return
	no:
	StrCpy $installroot "$installroot\meilian\"
	Return
SectionEnd

Section "释放tomcat文件夹"

  ;准备文件
	SetOutPath "$installroot\tomcat\"   ;释放到哪里去

	File /r "C:\appdisk\tomcat\*"   ;从哪里搜集
	DetailPrint "tomcat安装完毕"
	
SectionEnd

Section "释放数据库文件夹"
  ;准备文件
	SetOutPath "$installroot\db\"   ;释放到哪里去
	File /r "C:\appdisk\db\*"   ;从哪里搜集
	DetailPrint "db文件夹释放完毕"
SectionEnd

Var  has
;设置变量has，表明是否已经安装了SQL Server
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
Section "检查sqlserver是否安装"
	;检查是否安装了SQL Server
	StrCpy $serviceName "MSSQLSERVER"
	StrCmp $has "true" is0 other0
	is0:
	  DetailPrint "已经安装了SQL Server"
  Goto checkend
  other0:
    DetailPrint "还没有安装SQL Server"
    MessageBox MB_OK  "tomcat安装完毕，但是还没有安装SQL Server$\n请安装SQL Server后手动附加数据库"
    Abort "程序退出"
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


;附加数据库的时候如果数据库已经存在了，先分离再附加.(每次打包的时候要求数据库文件名一样bea和pri)
Section "附加数据库"

SectionEnd






;验证是否有D盘,将结果设置在全局变量中 $hasD
Function  "hasD"
	StrCpy $R0 "D:\"      ;Drive letter
		StrCpy $R1 "invalid"

		${GetDrives} "ALL" "getD"
		;MessageBox MB_OK "Type of drive $R0 is $R1"
		StrCmp $R1 "HDD" isHDD  noHDD
		isHDD:
		DetailPrint "有D盘"
		StrCpy $hasD "true"
	  Return
	  noHDD:
	  DetailPrint "没有D盘"
	  StrCpy $hasD "false"
	  Return
	  
FunctionEnd


; 内部被调用的方法，无需关心
Function getD
	StrCmp $9 $R0 0 +3
	StrCpy $R1 $8
	StrCpy $0 StopGetDrives
	Push $0
FunctionEnd

