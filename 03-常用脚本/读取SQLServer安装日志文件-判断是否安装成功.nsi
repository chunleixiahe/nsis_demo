;读取 c:\windows\sqlsp.log
;主要是为了验证sql是否安装成功了

Name "读取指定的文本文件"
OutFile "读取指定的文本文件.exe"
ShowInstDetails show

!include "TextFunc.nsh"
!include "WordFunc.nsh"


Var lastLineContent
Var log_name
Var log_result
Section "checkSQLSetup_Status"
  StrCpy $log_result "fail"
  
	StrCpy $log_name "sqlstp"
	Call "readlog"
	
	StrCpy $log_name "sqlsp"
	Call "readlog"
	
SectionEnd

Function  readlog

		StrCpy  $0 "$WINDIR\$log_name.log"

		;DetailPrint $0

    ;IfFileExists $0 0 +2
    ;DetailPrint "$0文件存在"
    IfFileExists $0 exist noexist
    exist:
		;DetailPrint "$log_name.log安装日志存在"

		${LineFind} "$0" "" -1 "readlastline"

		StrCpy $lastLineContent $lastLineContent 24 -24

		${WordFind} "$lastLineContent" "Installation Succeeded" "+1{" $R0

		StrCmp $R0 "$lastLineContent" notfound found        ; error?
		found:
    DetailPrint "$log_name安装成功"
  	StrCpy $log_result "success"
		Return
		notfound:
		DetailPrint "$log_name安装失败"
		StrCpy $log_result "fail"
		Return

		noexist:
		DetailPrint "$log_name.log日志不存在不能确定是否安装成功"
		StrCpy $log_result "fail"
		Abort "执行完毕"
 		Return
FunctionEnd


Function "readlastline"
	; $9       current line
	; $8       current line number
	; $7       current line negative number

	; $R0-$R9  are not used (save data in them).
	; ...
	
	;当前行内容
	;DetailPrint $9
	StrCpy $lastLineContent $R9
	;当前行数
	;DetailPrint $R8
	
	Push $var ; If $var="StopFileReadFromEnd"  Then exit from function

FunctionEnd




