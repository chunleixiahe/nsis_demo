!include "dialog_header_defines.nsh"

Name "InputBox"
OutFile "InputBox.exe"
ShowInstDetails show
XPStyle on

Page instfiles


Section "-boo"
DetailPrint "Executing plugin...."
Dialogs::InputBox "InputBox sample" "Please type something" "OKbtn" "Cancelbtn" "0" ${VAR_R2}
StrCmp $R2 "" Cancel Ok

Cancel:
DetailPrint "No info was inputed by the user"
goto Exit

Ok:
DetailPrint "User info: $R2"
goto Exit

Exit:
SectionEnd
