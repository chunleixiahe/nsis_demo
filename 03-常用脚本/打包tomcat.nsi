
;�������Ǵ��tomcat������jdk������javarebel

Name "���tomcat"
OutFile "���tomcat.exe"
ShowInstDetails show

!include "FileFunc.nsh"

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
	
SectionEnd

Section "�ͷ����ݿ��ļ���"
  ;׼���ļ�
	SetOutPath "$installroot\db\"   ;�ͷŵ�����ȥ
	File /r "C:\appdisk\db\*"   ;�������Ѽ�
	DetailPrint "db�ļ����ͷ����"
SectionEnd

Var  has
;���ñ���has�������Ƿ��Ѿ���װ��SQL Server
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
Section "���sqlserver�Ƿ�װ"
	;����Ƿ�װ��SQL Server
	StrCpy $serviceName "MSSQLSERVER"
	StrCmp $has "true" is0 other0
	is0:
	  DetailPrint "�Ѿ���װ��SQL Server"
  Goto checkend
  other0:
    DetailPrint "��û�а�װSQL Server"
    MessageBox MB_OK  "tomcat��װ��ϣ����ǻ�û�а�װSQL Server$\n�밲װSQL Server���ֶ��������ݿ�"
    Abort "�����˳�"
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


;�������ݿ��ʱ��������ݿ��Ѿ������ˣ��ȷ����ٸ���.(ÿ�δ����ʱ��Ҫ�����ݿ��ļ���һ��bea��pri)
Section "�������ݿ�"

SectionEnd






;��֤�Ƿ���D��,�����������ȫ�ֱ����� $hasD
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

