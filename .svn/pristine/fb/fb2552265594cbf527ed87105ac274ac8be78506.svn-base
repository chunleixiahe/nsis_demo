; 访问注册表
Name "uninstall_sql"
OutFile "uninstall_sql.exe"
ShowInstDetails show

!include "FileFunc.nsh"

Var test

;获取本地时间
Section
	${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
	; $0="01"      day
	; $1="04"      month
	; $2="2005"    year
	; $3="Friday"  day of week name
	; $4="11"      hour
	; $5="05"      minute
	; $6="50"      seconds
 	;MessageBox MB_OK 'Date=$0/$1/$2 ($3)$\nTime=$4:$5:$6'
	DetailPrint "$2_$1_$0_$4_$5_$6"
SectionEnd



