

;不仅仅是打包tomcat，还有jdk，还有javarebel

Name "安装美容连锁软件"
OutFile "安装美容连锁软件.exe"
ShowInstDetails show
loadlanguagefile "${NSISDIR}\Contrib\Language files\simpChinese.nlf" ;上一步下一步按钮显示中文

!include "FileFunc.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "OLEDB.NSH"
!include "WordFunc.nsh"

;定义常量
!define PRODUCT_NAME "美联美容连锁软件"
!define PRODUCT_VERSION "2012"
!define PRODUCT_PUBLISHER "北京和展科技有限责任公司"
!define PRODUCT_WEB_SITE "http://www.comdev.cn"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"  ;HKEY_LOCAL_MACHINE   HKLM是简写

!define MUI_ABORTWARNING
!define MUI_ICON "c:\appdisk\config\sys.ico"
!define MUI_UNICON "c:\appdisk\config\sys.ico"
!define MUI_WELCOMEPAGE_TITLE "$\r$\n 美联 V2012"
!define MUI_WELCOMEPAGE_TEXT "  美联 V2012（以下简称KMS-2010）是北京和展科技有限责任公司推出的整体解决方案。$\r$\n$\r$\n 技术先进、操作简便。$\r$\n$\r$\n　　$_CLICK"
!define MUI_FINISHPAGE_TEXT "安装成功！$\r$\n欢迎使用！$_CLICK"


;然后在自定义页面中处理附加数据库
Page custom nsDialogsPage nsDialogsPageLeave

;先显示安装页面
Page instfiles

; 卸载页面
UninstPage uninstConfirm
UninstPage instfiles


Var Dialog
Var Label

Var Text
Var Text_State

;初始化变量
Function .onInit

	StrCpy $Text_State "请输入sa的密码"

FunctionEnd




Var installroot
Var hasD
;有d盘就设置在d盘，没有d盘就设置在系统所在盘符
Section  "设置tomcat的安装目录"

	StrCpy $hasD "false"
	
  DetailPrint "开始安装tomcat"

  StrCpy $installroot $WINDIR 3  ;截取左侧的三个字符  c:\ ;;;;
	DetailPrint "系统所在盘符 $installroot"  ;获取系统盘符 c:\  ;;;;

	;查找有没有D盘，如果有D盘，就使用D盘，否则使用系统所在的根目录。比如c:\meilian\;
	
  StrCmp hasD "false"  has no
  has:
  StrCpy $installroot "D:\meilian\"
	Return
	no:
	StrCpy $installroot "$installroot\meilian\"
	Return
	
SectionEnd

Section "释放tomcat文件夹"
  ;准备文件
	SetOutPath "$installroot\tomcat\"   ;释放到哪里去

	File /r "C:\appdisk\tomcat\*"   ;从哪里搜集
	DetailPrint "tomcat安装完毕"
	
	;准备配置文件
	
	SetOutPath "$installroot\config\"   ;释放到哪里去
	File /r "C:\appdisk\config\*"   ;从哪里搜集

SectionEnd

Var  has
Section "释放数据库文件夹"
	SetOverwrite "try"
  ;准备文件
	SetOutPath "$installroot\db\"   ;释放到哪里去
	File /r "C:\appdisk\db\*"   ;从哪里搜集
	DetailPrint "db文件夹释放完毕"
	
	Call readReg
	StrCmp $has "false" no yes
	no:
		
		MessageBox MB_OK  "tomcat安装完毕，但是还没有安装SQL Server$\n请安装SQL Server后手动附加数据库"
		Abort "没有安装SQL Server 2000"
	yes:
	  DetailPrint "已经安装了SQL Server 2000"
		Call StartSQLServer ;如果没有启动服务就启动
		;到这里已经完成了安装页面，开始弹出输入密码页面
SectionEnd


;设置变量has，表明是否已经安装了SQL Server
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

;如果已经安装了SQL Server 2000，检查是否启动了，如果没有启动就启动。
Var serviceName
Function "startSQLServer"
	StrCpy $serviceName "MSSQLSERVER"
	StrCmp $has "true" is0 other0
	is0:
	  ;DetailPrint "已经安装了SQL Server"
  Goto checkend
  other0:
    ;DetailPrint "还没有安装SQL Server"
    MessageBox MB_OK  "tomcat安装完毕，但是还没有安装SQL Server$\n请安装SQL Server后手动附加数据库"
    Abort "程序退出"
  Goto checkend
	checkend:
	;检查是否安装了SQL Server end


	SimpleSC::GetServiceStatus "$serviceName"
	  Pop $1
	  IntCmp $1 4 isRuning  noRuning
		isRuning:
    DetailPrint "$serviceName服务正在运行"
    Goto checkend0
    noRuning:

    DetailPrint "$serviceName服务没有正在运行"
    SimpleSC::StartService "$serviceName" "" 30
    Pop $0
    IntCmp $1 0 runover0  otherRunover
    runover0:
    DetailPrint "$serviceName服务启动成功"
    Goto checkend0
    otherRunover:
    DetailPrint "$serviceName服务启动失败"
		MessageBox MB_OK "服务启动失败"
		Abort
    Goto checkend0
	checkend0:

	;开始安装
	Call fetch_begin
	
FunctionEnd


Var  bea_result
Var  pri_result

;打开数据库连接
Var  openresult
Function "openConn"
  ;$Text_State 密码
    ;连接数据库
	${OLEDB}::SQL_Logon  "localhost"  "sa" "$Text_State" ;"0" Success, "1" Failure
  ;查询
	Pop $0
	
	DetailPrint "登陆结果:$0"
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "连接成功"
	StrCpy $openresult "true"
	Return
	WRONG:
	DetailPrint "连接失败"
	StrCpy $openresult "false"
	Return
FunctionEnd

Function "fetch_begin"
	Call openConn
	StrCpy $openresult "false"
	StrCpy $bea_result "false"
	StrCpy $pri_result "false"
	
  ;连接数据库
	${OLEDB}::SQL_Logon  "localhost"  "sa" "$Text_State" ;"0" Success, "1" Failure
  ;查询
	Pop $0
	
	DetailPrint "登陆结果：$0"

	;判断是否等于0，如果等于0就是登陆失败
	StrCmp $0 "0" OK WRONG
	OK:
	DetailPrint "登陆成功"
	Call fetch_bea
	DetailPrint "$\n$\n"
	Call fetch_pri
	DetailPrint "$\n$\n"
	Return
	WRONG:
	DetailPrint "登陆失败"
	MessageBox MB_OK "连接数据库失败，退出"
	Abort
	Return
FunctionEnd

;附加数据库bea和pri

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
	StrCpy $bea_result "false"
	Return
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "安装路径:$installroot" ;调试变量
	;;;;附加bea数据库
	DetailPrint "正在附加数据库bea..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'bea', @filename1 = N'$installroot\db\bea_Data.MDF',@filename2=N'$installroot\db\bea_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "附加数据库bea完成..."
  StrCpy $bea_result "true"
	Goto doneBEA

	attchBEAFail:
  DetailPrint "附加数据库bea失败..."
  StrCpy $bea_result "false"
  
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
	StrCpy $pri_result "false"
	Return
	fenliBEAdown:

  attachDBBEA:
  ClearErrors

	DetailPrint "安装路径:$installroot" ;调试变量
	;;;;附加bea数据库
	DetailPrint "正在附加数据库pri..."


	${OLEDB}::SQL_Execute   "exec sp_attach_db @dbname = 'pri', @filename1 = N'$installroot\db\pri_Data.MDF',@filename2=N'$installroot\db\pri_Log.LDF'"
	Pop $0
  StrCmp $0 '0' attchBEASuccess attchBEAFail
  attchBEASuccess:
  DetailPrint "附加数据库pri完成..."
  StrCpy $pri_result "true"
	Goto doneBEA

	attchBEAFail:
  DetailPrint "附加数据库pri失败..."
	StrCpy $pri_result "false"

	doneBEA:

	DetailPrint "$\n$\n"
	
	Call fetch_end
	
FunctionEnd


Function "fetch_end"
	MessageBox MB_OK "附加数据库完毕$\nbea附加结果:$bea_result $\npri附加结果:$pri_result"
	;Quit
FunctionEnd





Function nsDialogsPage

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "输入sa的密码"
	Pop $Label

	${NSD_CreateText} 0 13u 100% 12u $Text_State
	Pop $Text

	;${NSD_CreateCheckbox} 0 30u 100% 10u "勾选(&S)"
	;Pop $Checkbox

	;${If} $Checkbox_State == ${BST_CHECKED}
	;	${NSD_Check} $Checkbox
	;${EndIf}
  nsDialogs::Show

	# 替换上面 ${If}:
	# ${NSD_SetState} $Checkbox  ${BST_CHECKED}

FunctionEnd

Function nsDialogsPageLeave

	${NSD_GetText} $Text $Text_State
	;${NSD_GetState} $Checkbox $Checkbox_State

	;MessageBox MB_OK "$Text_State"

	;验证是否能够连接数据库
  Call OpenConn
	StrCmp $openresult "true" connright connerr
	connright:
  ;Call fetch_begin ;开始附加数据库 ;自动执行安装页面开始附加了
	Return
	connerr:
	MessageBox MB_OK "输入的密码不正确"
	Abort
	
FunctionEnd

;附加数据库的时候如果数据库已经存在了，先分离再附加.(每次打包的时候要求数据库文件名一样bea和pri)




;验证是否有D盘,将结果设置在全局变量中 $hasD;用于决定把tomcat释放在哪个目录下
Function  "hasD"
	StrCpy $R0 "D:\"      ;Drive letter
		StrCpy $R1 "invalid"

		${GetDrives} "ALL" "getD"
		;MessageBox MB_OK "Type of drive $R0 is $R1"
		StrCmp $R1 "HDD" isHDD  noHDD
		isHDD:
		DetailPrint "有D盘"
		StrCpy $hasD "true"
	  Return
	  noHDD:
	  DetailPrint "没有D盘"
	  StrCpy $hasD "false"
	  Return
	  
FunctionEnd


; 内部被调用的方法，无需关心
Function getD
	StrCmp $9 $R0 0 +3
	StrCpy $R1 $8
	StrCpy $0 StopGetDrives
	Push $0
FunctionEnd




;//创建快捷方式
Section -AdditionalIcons
  SetOutPath   "$installroot\tomcat\bin\"
  CreateShortCut "$DESKTOP\美联.lnk" "$installroot\tomcat\bin\startup.bat"
	WriteIniStr "$installroot\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\美联美容连锁软件"
  SetOutPath   "$installroot\tomcat\bin\"
  CreateShortCut "$SMPROGRAMS\美联美容连锁软件\美联软件.lnk" "$installroot\tomcat\bin\startup.bat"
  SetOutPath   "$installroot"
  ;CreateShortCut "$SMPROGRAMS\美联美容连锁软件\Uninstall.lnk" "$installroot\uninst.exe"

SectionEnd




;//写入注册表系统信息
Section -Post
  WriteUninstaller "$installroot\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  StrCpy $installroot $INSTDIR
SectionEnd

;//删除快捷方式
Section Uninstall

  ;卸载tomcat服务
  ;ExecWait "service.bat remove hztomcat";不用卸载服务，因为没有安装服务

  ;删除文件夹
  RMDir /r "$installroot\tomcat\"
  RMDir /r  "$installroot\config\"

  Delete "$installroot\${PRODUCT_NAME}.url"

  Delete "$SMPROGRAMS\美联美容连锁软件\Uninstall.lnk"
  Delete "$SMPROGRAMS\美联美容连锁软件\Tomcat.lnk"

  RMDir /r  "$SMPROGRAMS\美联美容连锁软件"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  
	DetailPrint "删除完成"
  Sleep 5000
  
  SetAutoClose true

SectionEnd


;;///////////    以下是卸载信息   /////////////////////////
;//confirm 1
Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd

;//confirm 2
Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，其及所有的组件？ 移除后，所有数据和文件都将删除。$\r$\n 请确认是否进行该操作？" IDYES NoAbort
	Abort
	NoAbort:
FunctionEnd







