;读取 c:\windows\sqlsp.log
;主要是为了验证sql是否安装成功了

Name "读取指定的文本文件"
OutFile "读取指定的文本文件.exe"
ShowInstDetails show

!include "TextFunc.nsh"

Var lastLineContent
Section "读取文件"

		StrCpy  $0 "$WINDIR\sqlsp.log"

		DetailPrint $0
		
    ;IfFileExists $0 0 +2
    ;DetailPrint "$0文件存在"
    IfFileExists $0 exist noexist
    exist:
		DetailPrint "sql安装日志存在"

		${FileReadFromEnd} "$0" "readline"

    Goto checkend
		noexist:
		DetailPrint "sql安装日志不存在"
		Goto end0
    checkend:
    
 		DetailPrint "最后一行的内容是：$lastLineContent"
		StrCpy $lastLineContent $lastLineContent 24 -24
		DetailPrint "end:$lastLineContent"
		DetailPrint $lastLineContent

		StrLen $1 "Installation Succeeded"
		DetailPrint "文本长度$1"
		StrCmp $lastLineContent "Installation Succeeded"  success fail
		
		success:
		DetailPrint "SQL Server安装成功"
		Goto end0
		fail:
		DetailPrint "SQL Server安装失败"
		Goto end0
		
		end0:
SectionEnd

Function "readline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...
	
	;当前行内容
	DetailPrint $9
	StrCpy $lastLineContent $9
	;当前行数
	DetailPrint $7
	;Push $var ; If $var="StopFileReadFromEnd"  Then exit from function


FunctionEnd


