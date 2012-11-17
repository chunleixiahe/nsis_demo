; 访问注册表
Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

!include "FileFunc.nsh"

;删除sql相关的服务
Var serviceName
Section  "remove_mssql_service"

 	StrCpy $serviceName "MSSQLSERVER"
  Call findService_stop_remove
  
  StrCpy $serviceName "MSSQLServerADHelper"
  Call findService_stop_remove
  
  StrCpy $serviceName "SQLSERVERAGENT"
  Call findService_stop_remove
SectionEnd


;删除mssql的安装文件夹
Section "remove_mssql_folder"

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
SectionEnd

;删除mssql相关的注册表信息
Section  "remove_mssql_regedit"

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
Function  findService_stop_remove

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



















