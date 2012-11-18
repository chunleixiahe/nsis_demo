!include nsDialogs.nsh
!include LogicLib.nsh

Name "nsDialogsģ��"
OutFile "nsDialogsģ��.exe"
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

	StrCpy $Text_State "��ӭ��������ɼ�����̳WwW.Dreams8.CoM"
	StrCpy $Checkbox_State ${BST_CHECKED}

FunctionEnd

Function nsDialogsPage

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "��ӭʹ��nsDialogs���!"
	Pop $Label

	${NSD_CreateText} 0 13u 100% 12u $Text_State
	Pop $Text

	${NSD_CreateCheckbox} 0 30u 100% 10u "��ѡ(&S)"
	Pop $Checkbox

	${If} $Checkbox_State == ${BST_CHECKED}
		${NSD_Check} $Checkbox
	${EndIf}
  nsDialogs::Show
  
	# �滻���� ${If}:
	# ${NSD_SetState} $Checkbox  ${BST_CHECKED}



FunctionEnd

Function nsDialogsPageLeave

	${NSD_GetText} $Text $Text_State
	${NSD_GetState} $Checkbox $Checkbox_State

	MessageBox MB_OK "$Checkbox_State"

	StrCmp $Checkbox_State "0"  err0  right0
  err0:
  DetailPrint "û�й�ѡ"
  ${NSD_OnBack} nsDialogsPage
	Abort
	Return
  right0:
  DetailPrint "��ѡ��"
  Return

  
FunctionEnd

Section

	DetailPrint "WwW.Dremas8.CoM"
	DetailPrint "��������:$Text_State"
	DetailPrint "��ѡ���:$Checkbox_State"
  
 

SectionEnd
