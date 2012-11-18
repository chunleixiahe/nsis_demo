!include nsDialogs.nsh
!include LogicLib.nsh

Name "nsDialogs模板"
OutFile "nsDialogs模板.exe"
ShowInstDetails show

loadlanguagefile "${NSISDIR}\Contrib\Language files\simpChinese.nlf"

XPStyle on

Var Dialog
Var Label


Var Text
Var Text_State
Var Checkbox
Var Checkbox_State

Page custom nsDialogsPage nsDialogsPageLeave

Page instfiles

Function .onInit

	StrCpy $Text_State "欢迎访问梦想吧技术论坛WwW.Dreams8.CoM"
	StrCpy $Checkbox_State ${BST_CHECKED}

FunctionEnd

Function nsDialogsPage

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "欢迎使用nsDialogs插件!"
	Pop $Label

	${NSD_CreateText} 0 13u 100% 12u $Text_State
	Pop $Text

	${NSD_CreateCheckbox} 0 30u 100% 10u "勾选(&S)"
	Pop $Checkbox

	${If} $Checkbox_State == ${BST_CHECKED}
		${NSD_Check} $Checkbox
	${EndIf}
  nsDialogs::Show
  
	# 替换上面 ${If}:
	# ${NSD_SetState} $Checkbox  ${BST_CHECKED}



FunctionEnd

Function nsDialogsPageLeave

	${NSD_GetText} $Text $Text_State
	${NSD_GetState} $Checkbox $Checkbox_State

	MessageBox MB_OK "$Checkbox_State"

	StrCmp $Checkbox_State "0"  err0  right0
  err0:
  DetailPrint "没有勾选"
  ${NSD_OnBack} nsDialogsPage
	Abort
	Return
  right0:
  DetailPrint "勾选了"
  Return

  
FunctionEnd

Section

	DetailPrint "WwW.Dremas8.CoM"
	DetailPrint "框内文字:$Text_State"
	DetailPrint "勾选情况:$Checkbox_State"
  
 

SectionEnd
