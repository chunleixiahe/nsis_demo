;��ȡ c:\windows\sqlsp.log
;��Ҫ��Ϊ����֤sql�Ƿ�װ�ɹ���

Name "��ȡָ�����ı��ļ�"
OutFile "��ȡָ�����ı��ļ�.exe"
ShowInstDetails show

!include "TextFunc.nsh"
!include "WordFunc.nsh"


Var lastLineContent
Var log_name
Section "checkSQLSetup_Status"
	StrCpy $log_name "sqlstp"
	Call "readlog"
	
	StrCpy $log_name "sqlsp"
	Call "readlog"
SectionEnd

Function  readlog

		StrCpy  $0 "$WINDIR\$log_name.log"

		;DetailPrint $0

    ;IfFileExists $0 0 +2
    ;DetailPrint "$0�ļ�����"
    IfFileExists $0 exist noexist
    exist:
		;DetailPrint "$log_name.log��װ��־����"

		${LineFind} "$0" "" -1 "readlastline"

		StrCpy $lastLineContent $lastLineContent 24 -24

		${WordFind} "$lastLineContent" "Installation Succeeded" "+1{" $R0

		StrCmp $R0 "$lastLineContent" notfound found        ; error?
		found:
    DetailPrint "$log_name��װ�ɹ�"
		Return
		notfound:
		DetailPrint "$log_name��װʧ��"
		Return

		noexist:
		DetailPrint "$log_name.log��־�����ڲ���ȷ���Ƿ�װ�ɹ�"
		Return

		;Abort "ִ�����"
FunctionEnd


Function "readlastline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...
	
	;��ǰ������
	;DetailPrint $9
	StrCpy $lastLineContent $R9
	;��ǰ����
	;DetailPrint $R8
	
	Push $var ; If $var="StopFileReadFromEnd"  Then exit from function

FunctionEnd




