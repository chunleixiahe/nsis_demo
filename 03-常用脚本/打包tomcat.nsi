

;�������Ǵ��tomcat������jdk������javarebel

Name "��װ�����������"
OutFile "��װ�����������.exe"
ShowInstDetails show
loadlanguagefile "${NSISDIR}\Contrib\Language files\simpChinese.nlf" ;��һ����һ����ť��ʾ����

!include "FileFunc.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "OLEDB.NSH"
!include "WordFunc.nsh"

;���峣��
!define PRODUCT_NAME "���������������"
!define PRODUCT_VERSION "2012"
!define PRODUCT_PUBLISHER "������չ�Ƽ��������ι�˾"
!define PRODUCT_WEB_SITE "http://www.comdev.cn"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"  ;HKEY_LOCAL_MACHINE   HKLM�Ǽ�д

!define MUI_ABORTWARNING
!define MUI_ICON "c:\appdisk\config\sys.ico"
!define MUI_UNICON "c:\appdisk\config\sys.ico"
!define MUI_WELCOMEPAGE_TITLE "$\r$\n ���� V2012"
!define MUI_WELCOMEPAGE_TEXT "  ���� V2012�����¼��KMS-2010���Ǳ�����չ�Ƽ��������ι�˾�Ƴ���������������$\r$\n$\r$\n �����Ƚ���������㡣$\r$\n$\r$\n����$_CLICK"
!define MUI_FINISHPAGE_TEXT "��װ�ɹ���$\r$\n��ӭʹ�ã�$_CLICK"


;Ȼ�����Զ���ҳ���д��������ݿ�
Page custom nsDialogsPage nsDialogsPageLeave

;����ʾ��װҳ��
Page instfiles

; ж��ҳ��
UninstPage uninstConfirm
UninstPage instfiles


Var Dialog
Var Label

Var Text
Var Text_State

;��ʼ������
Function .onInit

	StrCpy $Text_State "������sa������"

FunctionEnd




Var installroot
Var hasD
;��d�̾�������d�̣�û��d�̾�������ϵͳ�����̷�
Section  "����tomcat�İ�װĿ¼"

	StrCpy $hasD "false"
	
  DetailPrint "��ʼ��װtomcat"

  StrCpy $installroot $WINDIR 3  ;��ȡ���������ַ�  c:\ ;;;;
	DetailPrint "ϵͳ�����̷� $installroot"  ;��ȡϵͳ�̷� c:\  ;;;;

	;������û��D�̣������D�̣���ʹ��D�̣�����ʹ��ϵͳ���ڵĸ�Ŀ¼������c:\meilian\;
	
  StrCmp hasD "false"  has no
  has:
  StrCpy $installroot "D:\meilian\"
	Return
	no:
	StrCpy $installroot "$installroot\meilian\"
	Return
	
SectionEnd

Section "�ͷ�tomcat�ļ���"
  ;׼���ļ�
	SetOutPath "$installroot\tomcat\"   ;�ͷŵ�����ȥ

	File /r "C:\appdisk\tomcat\*"   ;�������Ѽ�
	DetailPrint "tomcat��װ���"
	
	;׼�������ļ�
	
	SetOutPath "$installroot\config\"   ;�ͷŵ�����ȥ
	File /r "C:\appdisk\config\*"   ;�������Ѽ�

SectionEnd

Var  has
Section "�ͷ����ݿ��ļ���"
	SetOverwrite "try"
  ;׼���ļ�
	SetOutPath "$installroot\db\"   ;�ͷŵ�����ȥ
	File /r "C:\appdisk\db\*"   ;�������Ѽ�
	DetailPrint "db�ļ����ͷ����"
	
	Call readReg
	StrCmp $has "false" no yes
	no:
		
		MessageBox MB_OK  "tomcat��װ��ϣ����ǻ�û�а�װSQL Server$\n�밲װSQL Server���ֶ��������ݿ�"
		Abort "û�а�װSQL Server 2000"
	yes:
	  DetailPrint "�Ѿ���װ��SQL Server 2000"
		Call StartSQLServer ;���û���������������
		;�������Ѿ�����˰�װҳ�棬��ʼ������������ҳ��
SectionEnd


;���ñ���has�������Ƿ��Ѿ���װ��SQL Server
Function "readReg"
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
FunctionEnd

;����Ѿ���װ��SQL Server 2000������Ƿ������ˣ����û��������������
Var serviceName
Function "startSQLServer"
	StrCpy $serviceName "MSSQLSERVER"
	StrCmp $has "true" is0 other0
	is0:
	  ;DetailPrint "�Ѿ���װ��SQL Server"
  Goto checkend
  other0:
    ;DetailPrint "��û�а�װSQL Server"
    MessageBox MB_OK  "tomcat��װ��ϣ����ǻ�û�а�װSQL Server$\n�밲װSQL Server���ֶ��������ݿ�"
    Abort "�����˳�"
  Goto checkend
	checkend:
	;����Ƿ�װ��SQL Server end


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
		MessageBox MB_OK "��������ʧ��"
		Abort
    Goto checkend0
	checkend0:

	;��ʼ��װ
	Call fetch_begin
	
FunctionEnd


Var  bea_result
Var  pri_result

;�����ݿ�����
Var  openresult
Function "openConn"
  ;$Text_State ����
    ;�������ݿ�
	${OLEDB}::SQL_Logon  "localhost"  "sa" "$Text_State" ;"0" Success, "1" Failure
  ;��ѯ
	Pop $0
	
	DetailPrint "��½���:$0"
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "���ӳɹ�"
	StrCpy $openresult "true"
	Return
	WRONG:
	DetailPrint "����ʧ��"
	StrCpy $openresult "false"
	Return
FunctionEnd

Function "fetch_begin"
	Call openConn
	StrCpy $openresult "false"
	StrCpy $bea_result "false"
	StrCpy $pri_result "false"
	
  ;�������ݿ�
	${OLEDB}::SQL_Logon  "localhost"  "sa" "$Text_State" ;"0" Success, "1" Failure
  ;��ѯ
	Pop $0
	
	DetailPrint "��½�����$0"

	;�ж��Ƿ����0���������0���ǵ�½ʧ��
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "��½�ɹ�"
	Call fetch_bea
	DetailPrint "$\n$\n"
	Call fetch_pri
	DetailPrint "$\n$\n"
	Return
	WRONG:
	DetailPrint "��½ʧ��"
	MessageBox MB_OK "�������ݿ�ʧ�ܣ��˳�"
	Abort
	Return
FunctionEnd

;�������ݿ�bea��pri

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
	StrCpy $bea_result "false"
	Return
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "��װ·��:$installroot" ;���Ա���
	;;;;����bea���ݿ�
	DetailPrint "���ڸ������ݿ�bea..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'bea', @filename1 = N'$installroot\db\bea_Data.MDF',@filename2=N'$installroot\db\bea_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "�������ݿ�bea���..."
  StrCpy $bea_result "true"
	Goto doneBEA

	attchBEAFail:
  DetailPrint "�������ݿ�beaʧ��..."
  StrCpy $bea_result "false"
  
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
	StrCpy $pri_result "false"
	Return
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "��װ·��:$installroot" ;���Ա���
	;;;;����bea���ݿ�
	DetailPrint "���ڸ������ݿ�pri..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'pri', @filename1 = N'$installroot\db\pri_Data.MDF',@filename2=N'$installroot\db\pri_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "�������ݿ�pri���..."
  StrCpy $pri_result "true"
	Goto doneBEA

	attchBEAFail:
  DetailPrint "�������ݿ�priʧ��..."
	StrCpy $pri_result "false"

	doneBEA:

	DetailPrint "$\n$\n"
	
	Call fetch_end
	
FunctionEnd


Function "fetch_end"
	MessageBox MB_OK "�������ݿ����$\nbea���ӽ��:$bea_result $\npri���ӽ��:$pri_result"
	;Quit
FunctionEnd





Function nsDialogsPage

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "����sa������"
	Pop $Label

	${NSD_CreateText} 0 13u 100% 12u $Text_State
	Pop $Text

	;${NSD_CreateCheckbox} 0 30u 100% 10u "��ѡ(&S)"
	;Pop $Checkbox

	;${If} $Checkbox_State == ${BST_CHECKED}
	;	${NSD_Check} $Checkbox
	;${EndIf}
  nsDialogs::Show

	# �滻���� ${If}:
	# ${NSD_SetState} $Checkbox  ${BST_CHECKED}

FunctionEnd

Function nsDialogsPageLeave

	${NSD_GetText} $Text $Text_State
	;${NSD_GetState} $Checkbox $Checkbox_State

	;MessageBox MB_OK "$Text_State"

	;��֤�Ƿ��ܹ��������ݿ�
  Call OpenConn
	StrCmp $openresult "true" connright connerr
	connright:
  ;Call fetch_begin ;��ʼ�������ݿ� ;�Զ�ִ�а�װҳ�濪ʼ������
	Return
	connerr:
	MessageBox MB_OK "��������벻��ȷ"
	Abort
	
FunctionEnd

;�������ݿ��ʱ��������ݿ��Ѿ������ˣ��ȷ����ٸ���.(ÿ�δ����ʱ��Ҫ�����ݿ��ļ���һ��bea��pri)




;��֤�Ƿ���D��,�����������ȫ�ֱ����� $hasD;���ھ�����tomcat�ͷ����ĸ�Ŀ¼��
Function  "hasD"
	StrCpy $R0 "D:\"      ;Drive letter
		StrCpy $R1 "invalid"

		${GetDrives} "ALL" "getD"
		;MessageBox MB_OK "Type of drive $R0 is $R1"
		StrCmp $R1 "HDD" isHDD  noHDD
		isHDD:
		DetailPrint "��D��"
		StrCpy $hasD "true"
	  Return
	  noHDD:
	  DetailPrint "û��D��"
	  StrCpy $hasD "false"
	  Return
	  
FunctionEnd


; �ڲ������õķ������������
Function getD
	StrCmp $9 $R0 0 +3
	StrCpy $R1 $8
	StrCpy $0 StopGetDrives
	Push $0
FunctionEnd




;//������ݷ�ʽ
Section -AdditionalIcons
  SetOutPath   "$installroot\tomcat\bin\"
  CreateShortCut "$DESKTOP\����.lnk" "$installroot\tomcat\bin\startup.bat"
	WriteIniStr "$installroot\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\���������������"
  SetOutPath   "$installroot\tomcat\bin\"
  CreateShortCut "$SMPROGRAMS\���������������\�������.lnk" "$installroot\tomcat\bin\startup.bat"
  SetOutPath   "$installroot"
  ;CreateShortCut "$SMPROGRAMS\���������������\Uninstall.lnk" "$installroot\uninst.exe"

SectionEnd




;//д��ע���ϵͳ��Ϣ
Section -Post
  WriteUninstaller "$installroot\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  StrCpy $installroot $INSTDIR
SectionEnd

;//ɾ����ݷ�ʽ
Section Uninstall

  ;ж��tomcat����
  ;ExecWait "service.bat remove hztomcat";����ж�ط�����Ϊû�а�װ����

  ;ɾ���ļ���
  RMDir /r "$installroot\tomcat\"
  RMDir /r  "$installroot\config\"

  Delete "$installroot\${PRODUCT_NAME}.url"

  Delete "$SMPROGRAMS\���������������\Uninstall.lnk"
  Delete "$SMPROGRAMS\���������������\Tomcat.lnk"

  RMDir /r  "$SMPROGRAMS\���������������"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  
	DetailPrint "ɾ�����"
  Sleep 5000
  
  SetAutoClose true

SectionEnd


;;///////////    ������ж����Ϣ   /////////////////////////
;//confirm 1
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش���ļ�����Ƴ���"
FunctionEnd

;//confirm 2
Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���估���е������ �Ƴ����������ݺ��ļ�����ɾ����$\r$\n ��ȷ���Ƿ���иò�����" IDYES NoAbort
	Abort
	NoAbort:
FunctionEnd







