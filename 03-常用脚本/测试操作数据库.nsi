

;�������ݿ���

Name "�������ݿ���"
OutFile "�������ݿ���.exe"
ShowInstDetails show

!include "OLEDB.NSH"
!include "WordFunc.nsh"


Var dbname
Var filename_data
Var filename_log
;��ʼ������
Function .onInit

	StrCpy $INSTDIR "C:\meilian\"

FunctionEnd


Function "release_files"

	SetOverwrite "try"
	;׼���ļ�
	SetOutPath "$INSTDIR\db\"   ;�ͷŵ�����ȥ
	File /r "C:\appdisk\db\*"   ;�������Ѽ�
	DetailPrint "db�ļ����ͷ����"
	DetailPrint "$\n$\n"

FunctionEnd


;����ҳ��


Section "�������ݿ�"
  ;�������ݿ�
	${OLEDB}::SQL_Logon  "localhost"  "sa" "!@#$$%12345" ;"0" Success, "1" Failure
  ;��ѯ
	Pop $0

	DetailPrint "��½�����$0"

	;�ж��Ƿ����0���������0���ǵ�½ʧ��
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "��½�ɹ�"
	Call release_files
	Call fetch_bea
	DetailPrint "$\n$\n"
	Call fetch_pri
	DetailPrint "$\n$\n"
	Return
	WRONG:
	DetailPrint "��½ʧ��"
	Return
	
SectionEnd


Function "fetch_bea"
  ;���ȸ���$dbname
	;�����û��bea���ݿ⣬������ȷ��룬Ȼ�󸽼ӡ�
  ${OLEDB}::SQL_Execute   "select name from  sysdatabases where  name='bea'" ;ִ��sql���
	Pop $0
	Pop $0
	DetailPrint "��ѯ���ݿ���$0"

	${OLEDB}::SQL_GetRow ;ȡ�õ�ִ�е�sql�ķ��ؽ��  "0" Success, "1" Failure, "2" No more data to read
	Pop $0
	Pop $0
	DetailPrint "��ѯ���ݿ�bea���$0"


	;DetailPrint $0 ;ֻҪ����0���Ǵ���������󣬾ͱȱ�ʾ���ݿ�$dbname������

	;==1��ʱ����ʧ�ܵ������û�����ݿ⣬����(0)���ݿ��Ѿ�����   = [!=]
	StrCmp $0 "bea" existingDBBEA attachDBBEA

	existingDBBEA:
	DetailPrint "���ݿ�bea�Ѿ�����"
  ;���bea���ڣ��ȷ������Ȼ�󸽼��µġ�
  ${OLEDB}::SQL_Execute "EXEC sp_detach_db 'bea'"
	Pop $0
	DetailPrint $0ִ�з������ݿ����
  IntCmp $0 0 success  fail
	success:
	DetailPrint  "����bea�ɹ���"
	Goto fenliBEAdown
	fail:
	DetailPrint  "����beaʧ�ܣ�"
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "$INSTDIR" ;���Ա���
	;;;;����bea���ݿ�
	DetailPrint "���ڸ������ݿ�bea..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'bea', @filename1 = N'$INSTDIR\db\bea_Data.MDF',@filename2=N'$INSTDIR\db\bea_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "�������ݿ�bea���..."
	Goto doneBEA

	attchBEAFail:
  DetailPrint "�������ݿ�beaʧ��..."

	doneBEA:
	DetailPrint "$\n$\n"
FunctionEnd



Function "fetch_pri"
  ;���ȸ���$dbname
	;�����û��bea���ݿ⣬������ȷ��룬Ȼ�󸽼ӡ�
  ${OLEDB}::SQL_Execute   "select name from  sysdatabases where  name='pri'" ;ִ��sql���
	Pop $0
	Pop $0
	DetailPrint "��ѯ���ݿ���$0"

	${OLEDB}::SQL_GetRow ;ȡ�õ�ִ�е�sql�ķ��ؽ��  "0" Success, "1" Failure, "2" No more data to read
	Pop $0
	Pop $0
	DetailPrint "��ѯ���ݿ�pri���$0"


	;DetailPrint $0 ;ֻҪ����0���Ǵ���������󣬾ͱȱ�ʾ���ݿ�$dbname������

	;==1��ʱ����ʧ�ܵ������û�����ݿ⣬����(0)���ݿ��Ѿ�����   = [!=]
	StrCmp $0 "pri" existingDBBEA attachDBBEA

	existingDBBEA:
	DetailPrint "���ݿ�pri�Ѿ�����"
  ;���bea���ڣ��ȷ������Ȼ�󸽼��µġ�
  ${OLEDB}::SQL_Execute "EXEC sp_detach_db 'pri'"
	Pop $0
	DetailPrint $0ִ�з������ݿ����
  IntCmp $0 0 success  fail
	success:
	DetailPrint  "����pri�ɹ���"
	Goto fenliBEAdown
	fail:
	DetailPrint  "����priʧ�ܣ�"
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "$INSTDIR" ;���Ա���
	;;;;����bea���ݿ�
	DetailPrint "���ڸ������ݿ�pri..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'pri', @filename1 = N'$INSTDIR\db\pri_Data.MDF',@filename2=N'$INSTDIR\db\pri_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "�������ݿ�pri���..."
	Goto doneBEA

	attchBEAFail:
  DetailPrint "�������ݿ�priʧ��..."

	doneBEA:
	
	 DetailPrint "$\n$\n"
FunctionEnd





