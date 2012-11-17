; ����ע���
Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

!include "FileFunc.nsh"

;ɾ��sql��صķ���
Var serviceName
Section  "remove_mssql_service"

 	StrCpy $serviceName "MSSQLSERVER"
  Call findService_stop_remove
  
  StrCpy $serviceName "MSSQLServerADHelper"
  Call findService_stop_remove
  
  StrCpy $serviceName "SQLSERVERAGENT"
  Call findService_stop_remove
SectionEnd


;ɾ��mssql�İ�װ�ļ���
Section "remove_mssql_folder"

  ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\MSSQLServer\Setup" SQLPath
  DetailPrint "SQL��װλ��: $0" ;C:\Program Files (x86)\Microsoft SQL Server\MSSQL
	StrCpy $9 $0 -5
	DetailPrint "$9"


  StrCpy $1 "$0\Data"

	;��ȡϵͳ�̷�
  DetailPrint "ϵͳĿ¼: $WINDIR"
  StrCpy $0 $WINDIR 3  ;��ȡ���������ַ�
	DetailPrint "ϵͳ�����̷� $0"  ;��ȡϵͳ�̷�


	;���������ļ�
	StrCpy $7 $1
	StrCpy $8 $0
	${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6  ;������ʱ����
	CopyFiles /SILENT  "$7" "$8\sqldata_bak_$2_$1_$0_$4_$5_$6"

	IfErrors err noerr
  err:
  DetailPrint "�����ļ�ʱ�������󣺿���ԭ�ļ�������"
	Goto over
	noerr:
	DetailPrint "û�з�������"
	MessageBox MB_OK "�ļ����Ѿ�ɾ������\n���ݿ��ļ��Ѿ����ݵ�$8\sqldata_bak_$2_$1_$0_$4_$5_$6"
	Goto over
	over:

	;ɾ���ļ��� $9 "C:\Program Files (x86)\Microsoft SQL Server\"
 	RMDir /r /REBOOTOK $9
SectionEnd

;ɾ��mssql��ص�ע�����Ϣ
Section  "remove_mssql_regedit"

  ;�������
	DeleteRegValue HKLM  "SYSTEM\CurrentControlSet\Control\Session Manager" "PendingFileRenameOperations"
	DetailPrint  "delע���:SYSTEM\CurrentControlSet\Control\Session Manager->PendingFileRenameOperations"
	

  DeleteRegKey HKLM  "SOFTWARE\Microsoft\MSSQLServer"
  DetailPrint  "delע���:SOFTWARE\Microsoft\MSSQLServer"
  
  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Microsoft SQL Server"
  DetailPrint  "delע���:SOFTWARE\Microsoft\Microsoft SQL Server"
  
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServer"  ;��ʵ�����Ѿ�ɾ����[������Ȼ������������ֹͣ����]
  DetailPrint "delע���:SYSTEM\CurrentControlSet\Services\MSSQLServer"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT" ;��ʵ�����Ѿ�ɾ����
  DetailPrint   "delע���:SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT"
  DeleteRegKey HKLM  "SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper" ;��ʵ����ɾ����
  DetailPrint  "delע���:SYSTEM\CurrentControlSet\Services\MSSQLServerADHelper"

	;ɾ�������ط�
	DeleteRegKey HKCU  "Software\Microsoft\Microsoft SQL Server"
	DetailPrint  "delע���:Software\Microsoft\Microsoft SQL Server"
	
	;Wow6432Node��64λϵͳ�ϵ�λ��
  DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Wow6432Node\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

	;������32λϵͳ�ϵ�λ��
  DeleteRegKey HKLM  "SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Microsoft\Updates\SQL Server 2000"
	DeleteRegKey HKLM  "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"
	DetailPrint  "delע���:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 2000"

 	DetailPrint  "ɾ��ע���over"

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



















