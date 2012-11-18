
Name "检查是否存在D盘"
OutFile "打包检查是否存在D盘.exe"
ShowInstDetails show
!include "FileFunc.nsh"


Var installroot
Section
	StrCpy $R0 "D:\"      ;Drive letter
	StrCpy $R1 "invalid"

	${GetDrives} "ALL" "getD"
	;MessageBox MB_OK "Type of drive $R0 is $R1"
	StrCmp $R1 "HDD" isHDD  noHDD
	isHDD:
	DetailPrint "有D盘"
  Return
  noHDD:
  DetailPrint "没有D盘"
  Return
SectionEnd

Function getD
	StrCmp $9 $R0 0 +3
	StrCpy $R1 $8
	StrCpy $0 StopGetDrives
	Push $0
FunctionEnd



