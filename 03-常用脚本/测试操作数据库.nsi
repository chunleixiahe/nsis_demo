

;测试数据库插件

Name "测试数据库插件"
OutFile "测试数据库插件.exe"
ShowInstDetails show

!include "OLEDB.NSH"
!include "WordFunc.nsh"


Var dbname
Var filename_data
Var filename_log
;初始化变量
Function .onInit

	StrCpy $INSTDIR "C:\meilian\"

FunctionEnd


Function "release_files"

	SetOverwrite "try"
	;准备文件
	SetOutPath "$INSTDIR\db\"   ;释放到哪里去
	File /r "C:\appdisk\db\*"   ;从哪里搜集
	DetailPrint "db文件夹释放完毕"
	DetailPrint "$\n$\n"

FunctionEnd


;设置页面


Section "连接数据库"
  ;连接数据库
	${OLEDB}::SQL_Logon  "localhost"  "sa" "!@#$$%12345" ;"0" Success, "1" Failure
  ;查询
	Pop $0

	DetailPrint "登陆结果：$0"

	;判断是否等于0，如果等于0就是登陆失败
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "登陆成功"
	Call release_files
	Call fetch_bea
	DetailPrint "$\n$\n"
	Call fetch_pri
	DetailPrint "$\n$\n"
	Return
	WRONG:
	DetailPrint "登陆失败"
	Return
	
SectionEnd


Function "fetch_bea"
  ;首先附加$dbname
	;检查有没有bea数据库，如果有先分离，然后附加。
  ${OLEDB}::SQL_Execute   "select name from  sysdatabases where  name='bea'" ;执行sql语句
	Pop $0
	Pop $0
	DetailPrint "查询数据库结果$0"

	${OLEDB}::SQL_GetRow ;取得的执行的sql的返回结果  "0" Success, "1" Failure, "2" No more data to read
	Pop $0
	Pop $0
	DetailPrint "查询数据库bea结果$0"


	;DetailPrint $0 ;只要大于0就是错误；如果错误，就比表示数据库$dbname不存在

	;==1的时候是失败的情况，没有数据库，否则(0)数据库已经存在   = [!=]
	StrCmp $0 "bea" existingDBBEA attachDBBEA

	existingDBBEA:
	DetailPrint "数据库bea已经存在"
  ;如果bea存在，先分离掉，然后附加新的。
  ${OLEDB}::SQL_Execute "EXEC sp_detach_db 'bea'"
	Pop $0
	DetailPrint $0执行分离数据库操作
  IntCmp $0 0 success  fail
	success:
	DetailPrint  "分离bea成功！"
	Goto fenliBEAdown
	fail:
	DetailPrint  "分离bea失败！"
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "$INSTDIR" ;调试变量
	;;;;附加bea数据库
	DetailPrint "正在附加数据库bea..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'bea', @filename1 = N'$INSTDIR\db\bea_Data.MDF',@filename2=N'$INSTDIR\db\bea_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "附加数据库bea完成..."
	Goto doneBEA

	attchBEAFail:
  DetailPrint "附加数据库bea失败..."

	doneBEA:
	DetailPrint "$\n$\n"
FunctionEnd



Function "fetch_pri"
  ;首先附加$dbname
	;检查有没有bea数据库，如果有先分离，然后附加。
  ${OLEDB}::SQL_Execute   "select name from  sysdatabases where  name='pri'" ;执行sql语句
	Pop $0
	Pop $0
	DetailPrint "查询数据库结果$0"

	${OLEDB}::SQL_GetRow ;取得的执行的sql的返回结果  "0" Success, "1" Failure, "2" No more data to read
	Pop $0
	Pop $0
	DetailPrint "查询数据库pri结果$0"


	;DetailPrint $0 ;只要大于0就是错误；如果错误，就比表示数据库$dbname不存在

	;==1的时候是失败的情况，没有数据库，否则(0)数据库已经存在   = [!=]
	StrCmp $0 "pri" existingDBBEA attachDBBEA

	existingDBBEA:
	DetailPrint "数据库pri已经存在"
  ;如果bea存在，先分离掉，然后附加新的。
  ${OLEDB}::SQL_Execute "EXEC sp_detach_db 'pri'"
	Pop $0
	DetailPrint $0执行分离数据库操作
  IntCmp $0 0 success  fail
	success:
	DetailPrint  "分离pri成功！"
	Goto fenliBEAdown
	fail:
	DetailPrint  "分离pri失败！"
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "$INSTDIR" ;调试变量
	;;;;附加bea数据库
	DetailPrint "正在附加数据库pri..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'pri', @filename1 = N'$INSTDIR\db\pri_Data.MDF',@filename2=N'$INSTDIR\db\pri_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "附加数据库pri完成..."
	Goto doneBEA

	attchBEAFail:
  DetailPrint "附加数据库pri失败..."

	doneBEA:
	
	 DetailPrint "$\n$\n"
FunctionEnd





