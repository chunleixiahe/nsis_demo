;SQL Server 2000的一键安装，检查之前是否已经安装了sql2000
;如果已经安装了，其版本号是多少，如果没有打补丁，那么就仅仅打补丁，如果大了补丁，仅检查服务是否正常。把没有启动的启动就好了。
;如果没有安装，那么先清理可能存在的垃圾。包括验证计算机名字中是否含有小写字母。
;安装的时候弹出框指定sa的密码，取到sa密码更新sql的两个配置文件，执行静默安装。

Name "安装SQL Server 2000"
OutFile "安装SQL Server 2000.exe"
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


;如果计算机名中含有小写字母，全部改成大写，然后重新启动计算机。
Section  "changePcName"

;先取得计算机名字
;HKEY_LOCAL_MACHINE\System\CurrenControlSet\Control\ComputerName\ComputerName

ReadRegDWORD $0 HKLM "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" "ComputerName"

;提示一下；程序检测到您的计算机名含有小写字母，是否允许程序修改成大写，并且重启计算机？



DetailPrint "当前计算机的名字:$0"

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

;系统需要重启；如果选择了false，不进行重启，也会正常进入下一步。但是没有验证是否不重启，仅仅把注册表中涉及到的小写计算机名改成大写后，
;是否不影响sql2000的安装


MessageBox MB_YESNO|MB_ICONQUESTION "需要重启系统，请重启后重新安装本程序。" IDNO +2
  Reboot
Goto over
over:

SectionEnd




Var sysroot

;上面主要做了，有服务的情况下启动服务 ;把sqlserver的安装文件解压出来。
Section  "release_files"

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

		DetailPrint "正在搜集文件[C:\appdisk\sqlserver\personal\*]"

    StrCpy $sysroot $WINDIR 3  ;截取左侧的三个字符  c:\ ;;;;
    
		DetailPrint "系统所在盘符 $sysroot"  ;获取系统盘符 c:\  ;;;;
		
		SetOverwrite on

		SetOutPath "$sysroot\sqlserver\personal\" ;临时的解压目录，以后解压后放置在这里
		File /r "C:\appdisk\sqlserver\personal\*"  ;从哪里收集安装文件到打包程序中

    SetOutPath "$sysroot\sqlserver\sp4\" ;临时的解压目录，以后解压后放置在这里
		File /r "C:\appdisk\sqlserver\sp4\*"  ;从哪里收集安装文件到打包程序中
SectionEnd


;如果能够走到这里说明没有安装sqlserver，但是安装前还要清理一下可能存在的垃圾

;杀掉可能正在使用的查询分析器和企业管理器 KillProc不能关闭64位的应用程序!
Section "clear_kill_ps"

  KillProcDLL::KillProc "isqlw.exe"
	DetailPrint "关闭查询分析器$R0"
	KillProcDLL::KillProc "mmc.exe"
	DetailPrint "关闭企业管理器$R0"

SectionEnd

Section  "clear_remove_mssql_service"

 	StrCpy $serviceName "MSSQLSERVER"
  Call clear_findService_stop_remove

  StrCpy $serviceName "MSSQLServerADHelper"
  Call clear_findService_stop_remove

  StrCpy $serviceName "SQLSERVERAGENT"
  Call clear_findService_stop_remove
SectionEnd


;删除mssql的安装文件夹
Section "clear_remove_mssql_folder"

  ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\MSSQLServer\Setup" SQLPath
  DetailPrint "SQL安装位置: $0" ;C:\Program Files (x86)\Microsoft SQL Server\MSSQL
	StrCpy $9 $0 -5
	DetailPrint "$9"


  StrCpy $1 "$0\Data"

	;获取系统盘符
  DetailPrint "系统目录: $WINDIR"
  StrCpy $0 $WINDIR 3  ;截取左侧的三个字符
	DetailPrint "系统所在盘符 $0"  ;获取系统盘符


	;备份数据文件
	StrCpy $7 $1
	StrCpy $8 $0
	${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6  ;年月日时分秒
	CopyFiles /SILENT  "$7" "$8\sqldata_bak_$2_$1_$0_$4_$5_$6"

	IfErrors err noerr
  err:
  DetailPrint "拷贝文件时发生错误：可能原文件不存在"
	Goto over
	noerr:
	DetailPrint "没有发生错误"
	MessageBox MB_OK "文件夹已经删除完整\n数据库文件已经备份到$8\sqldata_bak_$2_$1_$0_$4_$5_$6"
	Goto over
	over:

	;删除文件夹 $9 "C:\Program Files (x86)\Microsoft SQL Server\"
 	RMDir /r /REBOOTOK $9

 	Delete $WINDIR\sqlstp.log
  Delete $WINDIR\sqlsp.log

SectionEnd

;删除mssql相关的注册表信息
Section  "clear_remove_mssql_regedit"

  ;程序挂起
	DeleteRegValue HKLM  "SYSTEM\CurrentControlSet\Control\Session Manager" "PendingFileRenameOperations"
	DetailPrint  "del注册表:SYSTEM\CurrentControlSet\Control\Session Manager->PendingFileRenameOperations"


  DeleteRegKey HKLM  "SOFTWARE\Microsoft\MSSQLServer"
  DetailPrint  "del注册表:SOFTWARE\Microsoft\MSSQLServer"

  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Microsoft SQL Server"
  DetailPrint  "del注册表:SOFTWARE\Microsoft\Microsoft SQL Server"

  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServer"  ;其实上面已经删除了[上面依然保留的作用是停止服务]
  DetailPrint "del注册表:SYSTEM\CurrentControlSet\Services\MSSQLServer"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT" ;其实上面已经删除了
  DetailPrint   "del注册表:SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper" ;其实上面删除了
  DetailPrint  "del注册表:SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper"

	;删除其他地方
	DeleteRegKey HKCU  "Software\Microsoft\Microsoft SQL Server"
	DetailPrint  "del注册表:Software\Microsoft\Microsoft SQL Server"

	;Wow6432Node是64位系统上的位置
  DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "del注册表:SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "del注册表:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

	;下面是32位系统上的位置
  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "del注册表:SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "del注册表:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

 	DetailPrint  "删除注册表over"

SectionEnd




;检测sql相关的服务是否存在，如果存在就停止掉，然后删除
;windows服务的插件:SimpleSC
Function  clear_findService_stop_remove

	SimpleSC::ExistsService $serviceName
  Pop $0

	IntCmp $0 0 is0 lessthan0 morethan0
	is0:
	  DetailPrint "$serviceName服务存在"

		;检查当前的服务的状态
		SimpleSC::GetServiceStatus "$serviceName"
	  Pop $0
	  IntCmp $0 0 is000 lessthan000 morethan000
    is000:
		;DetailPrint "$serviceName查询服务状态:成功"
		Goto getStatus
 		lessthan000:
		;DetailPrint "$serviceName查询服务状态:失败"
		Goto done
		morethan000:
		;DetailPrint "$serviceName查询服务状态:失败"
    Goto done
		getStatus:
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
    isRuning:
    DetailPrint "$serviceName服务正在运行"
		Goto stop
    noRuning:
    DetailPrint "$serviceName服务没有正在运行"
  	Goto rmservice

		stop:
	  SimpleSC::StopService "$serviceName" 1 30
	  Pop $0
	  IntCmp $0 0 is00 lessthan00 morethan00
    is00:
    DetailPrint "$serviceName停止成功"
    Goto rmservice

    rmservice:
    SimpleSC::RemoveService "$serviceName"
    Pop $0
	  IntCmp $0 0 is0000 other
	  is0000:
	  DetailPrint "$serviceName删除成功"
		Goto done
    other:
    DetailPrint "$serviceName删除失败"

		Goto done
    lessthan00:
    DetailPrint "$serviceName停止失败"
    Goto done
    morethan00:
    DetailPrint "$serviceName停止失败"
	  Goto done
	lessthan0:
	  DetailPrint "$serviceName服务不存在"
	  Goto done
	morethan0:
	  DetailPrint "$serviceName服务不存在"
	  Goto done
	done:

FunctionEnd





Var lastLineContent
Var log_name
Var log_result

;执行上面刚解压完毕的sql安装程序
Section  "install"
  SetOutPath "$sysroot\sqlserver\personal\"
  DetailPrint "开始安装SQL Server"
  nsExec::ExecToLog   "mySetup.bat" ;安装sql的批处理
  DetailPrint "SQL Server安装完毕"
  ;检查是否安装成功
  StrCpy $log_result "fail"

	StrCpy $log_name "sqlstp"
	Call "readlog"
	StrCmp $log_result "success" next fail

  fail:

	MessageBox MB_OK "SQLServer失败"
  ExecShell "open" "$WINDIR\sqlstp.log"
	Abort "SQLServer 安装失败"
	
  next:
  MessageBox MB_OK "SQLServer 安装成功"
  
  SetOutPath "$sysroot\sqlserver\sp4\"
  DetailPrint "开始安装SQL Server SP4"
  nsExec::ExecToLog   "mySetup.bat" ;安装sql sp4的批处理
  DetailPrint "SQL Server SP4安装完毕"
	StrCpy $log_name "sqlsp"
	Call "readlog"

  StrCmp $log_result "success" next2 fail2
  fail2:
	MessageBox MB_OK "SQLServer SP4 安装失败"
  DetailPrint "打开错误日志"
  ExecShell "open" "$WINDIR\sqlstp.log"
	Abort "SQLServer SP4 安装失败"
	
	next2:
	MessageBox MB_OK "SQLServer SP4 安装成功"

SectionEnd

;启动服务
Section "start_service"
	StrCpy $serviceName "MSSQLSERVER"
	Call start_service
	
	StrCpy $serviceName "SQLSERVERAGENT"
	Call start_service
	
SectionEnd

Function  start_service

	  ;DetailPrint "$serviceName服务存在"

		;检查当前的服务的状态
		SimpleSC::GetServiceStatus "$serviceName"
	  Pop $0
	  IntCmp $0 0 is000 lessthan000 morethan000
    is000:
		;DetailPrint "$serviceName查询服务状态:成功"
		Goto getStatus
  	lessthan000:
    Return
		morethan000:
		Return
		getStatus:
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
    isRuning:
    DetailPrint "$serviceName服务正在运行"
		Return
    noRuning:
    DetailPrint "$serviceName服务没有正在运行"
  	Goto start

		start:
		SimpleSC::StartService "$serviceName" "" 30
	  Pop $0
	  IntCmp $0 0 is00 other00
    is00:
    DetailPrint "$serviceName启动成功"
    Return
    other00:
    DetailPrint "$serviceName启动失败"
    Return

FunctionEnd




Function  readlog

		StrCpy  $0 "$WINDIR\$log_name.log"

		;DetailPrint $0

    ;IfFileExists $0 0 +2
    ;DetailPrint "$0文件存在"
    IfFileExists $0 exist noexist
    exist:
		;DetailPrint "$log_name.log安装日志存在"

		${LineFind} "$0" "" -1 "readlastline"

		StrCpy $lastLineContent $lastLineContent 24 -24

		${WordFind} "$lastLineContent" "Installation Succeeded" "+1{" $R0

		StrCmp $R0 "$lastLineContent" notfound found        ; error?
		found:
    DetailPrint "$log_name安装成功"
  	StrCpy $log_result "success"
		Return
		notfound:
		DetailPrint "$log_name安装失败"
		StrCpy $log_result "fail"
		Return

		noexist:
		DetailPrint "$log_name.log日志不存在不能确定是否安装成功"
		StrCpy $log_result "fail"
		Abort "执行完毕"
 		Return
FunctionEnd


Function "readlastline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...

	;当前行内容
	;DetailPrint $9
	StrCpy $lastLineContent $R9
	;当前行数
	;DetailPrint $R8

	Push $var ; If $var="StopFileReadFromEnd"  Then exit from function

FunctionEnd
























