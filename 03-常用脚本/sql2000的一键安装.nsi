

;SQL Server 2000��һ����װ�����֮ǰ�Ƿ��Ѿ���װ��sql2000
;����Ѿ���װ�ˣ���汾���Ƕ��٣����û�д򲹶�����ô�ͽ����򲹶���������˲��������������Ƿ���������û�������������ͺ��ˡ�
;���û�а�װ����ô��������ܴ��ڵ�������������֤������������Ƿ���Сд��ĸ��
;��װ��ʱ�򵯳���ָ��sa�����룬ȡ��sa�������sql�����������ļ���ִ�о�Ĭ��װ��

Name "��װSQL Server 2000"
OutFile "��װSQL Server 2000.exe"
ShowInstDetails show

!include "FileFunc.nsh"
!include "WordFunc.nsh"

Var serviceName
Section "checksql_Status"
  
	;����Ƿ�װ��SQL Server
	StrCpy $serviceName "MSSQLSERVER"
  SimpleSC::ExistsService $serviceName
  Pop $0

	IntCmp $0 0 is0 other0
	is0:
	  DetailPrint "�Ѿ���װ��SQL Server"
	  Abort "�����˳�"
  Goto checkend
  other0:
    DetailPrint "��û�а�װSQL Server"
  Goto checkend
	checkend:
	;����Ƿ�װ��SQL Server end
	

	StrCmp $R0  10  hasExist  noExist
	hasExist:
	SimpleSC::GetServiceStatus "$serviceName"
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
		isRuning:
    DetailPrint "$serviceName������������"
    Goto checkend0
    noRuning:
    
    DetailPrint "$serviceName����û����������"
    SimpleSC::StartService "$serviceName" "" 30
    Pop $0
    IntCmp $1 0 runover0  otherRunover
    runover0:
    DetailPrint "$serviceName���������ɹ�"
    Goto checkend0
    otherRunover:
    DetailPrint "$serviceName��������ʧ��"
    Goto checkend0

	Goto checkend0

	noExist:

	;���������Sectionִ�а�װ
	Goto checkend0
	checkend0:
	
SectionEnd

;������Ҫ���ˣ��з�����������������
Section  "install_sql"
		SimpleSC::ExistsService "$serviceName"
	  Pop $0

		IntCmp $0 0 is0 other0
		is0:
		  ;DetailPrint "�Ѿ���װ��SQL Server"
    Goto checkend
	  other0:

		;�ͷ� �Ѿ����˰����ļ�

	  Goto checkend
		checkend:
	
SectionEnd












