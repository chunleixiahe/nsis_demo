
Name "uninstall"
OutFile "uninstall.exe"
ShowInstDetails show

Var serviceName

Section  "remove_ervice"

 	StrCpy $serviceName "MSSQLSERVER"
  Call findService_stop_remove

  ;StrCpy $serviceName "MSSQLServerADHelper"
  ;Call findService_stop_remove

  ;StrCpy $serviceName "SQLSERVERAGENT"
  ;Call findService_stop_remove

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

