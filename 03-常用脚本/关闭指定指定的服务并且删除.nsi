
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


;���sql��صķ����Ƿ���ڣ�������ھ�ֹͣ����Ȼ��ɾ��
;windows����Ĳ��:SimpleSC
Function  findService_stop_remove

	SimpleSC::ExistsService $serviceName
  Pop $0

	IntCmp $0 0 is0 lessthan0 morethan0
	is0:
	  DetailPrint "$serviceName�������"

		;��鵱ǰ�ķ����״̬
		SimpleSC::GetServiceStatus "$serviceName"
	  Pop $0
	  IntCmp $0 0 is000 lessthan000 morethan000
    is000:
		;DetailPrint "$serviceName��ѯ����״̬:�ɹ�"
		Goto getStatus
 		lessthan000:
		;DetailPrint "$serviceName��ѯ����״̬:ʧ��"
		Goto done
		morethan000:
		;DetailPrint "$serviceName��ѯ����״̬:ʧ��"
    Goto done
		getStatus:
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
    isRuning:
    DetailPrint "$serviceName������������"
		Goto stop
    noRuning:
    DetailPrint "$serviceName����û����������"
  	Goto rmservice

		stop:
	  SimpleSC::StopService "$serviceName" 1 30
	  Pop $0
	  IntCmp $0 0 is00 lessthan00 morethan00
    is00:
    DetailPrint "$serviceNameֹͣ�ɹ�"
    Goto rmservice

    rmservice:
    SimpleSC::RemoveService "$serviceName"
    Pop $0
	  IntCmp $0 0 is0000 other
	  is0000:
	  DetailPrint "$serviceNameɾ���ɹ�"
		Goto done
    other:
    DetailPrint "$serviceNameɾ��ʧ��"

		Goto done
    lessthan00:
    DetailPrint "$serviceNameֹͣʧ��"
    Goto done
    morethan00:
    DetailPrint "$serviceNameֹͣʧ��"
	  Goto done
	lessthan0:
	  DetailPrint "$serviceName���񲻴���"
	  Goto done
	morethan0:
	  DetailPrint "$serviceName���񲻴���"
	  Goto done
	done:

FunctionEnd

