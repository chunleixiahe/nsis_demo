;��ȡ c:\windows\sqlsp.log
;��Ҫ��Ϊ����֤sql�Ƿ�װ�ɹ���

Name "��ȡָ�����ı��ļ�"
OutFile "��ȡָ�����ı��ļ�.exe"
ShowInstDetails show

!include "TextFunc.nsh"

Var lastLineContent
Section "��ȡ�ļ�"

		StrCpy  $0 "$WINDIR\sqlsp.log"

		DetailPrint $0
		
    ;IfFileExists $0 0 +2
    ;DetailPrint "$0�ļ�����"
    IfFileExists $0 exist noexist
    exist:
		DetailPrint "sql��װ��־����"

		${FileReadFromEnd} "$0" "readline"

    Goto checkend
		noexist:
		DetailPrint "sql��װ��־������"
		Goto end0
    checkend:
    
 		DetailPrint "���һ�е������ǣ�$lastLineContent"
		StrCpy $lastLineContent $lastLineContent 24 -24
		DetailPrint "end:$lastLineContent"
		DetailPrint $lastLineContent

		StrLen $1 "Installation Succeeded"
		DetailPrint "�ı�����$1"
		StrCmp $lastLineContent "Installation Succeeded"  success fail
		
		success:
		DetailPrint "SQL Server��װ�ɹ�"
		Goto end0
		fail:
		DetailPrint "SQL Server��װʧ��"
		Goto end0
		
		end0:
SectionEnd

Function "readline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...
	
	;��ǰ������
	DetailPrint $9
	StrCpy $lastLineContent $9
	;��ǰ����
	DetailPrint $7
	;Push $var ; If $var="StopFileReadFromEnd"  Then exit from function


FunctionEnd


