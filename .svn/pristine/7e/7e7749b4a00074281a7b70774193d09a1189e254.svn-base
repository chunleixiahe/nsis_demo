@echo off
rem 	Performs SQL Server Full Server Unattended Install operation

rem 	Before running this batch file, you must edit the corresponding 
rem	unattended install file (sqlins.iss), and enter your 
rem	Product Key (CD-Key) from your CD.


cls

echo *
echo     Unattended install for SQL Server SP4 is starting.
echo *
echo *
echo     Waiting for SQL Server Setup SP4 to finish...


@echo on
start /wait x86\setup\setupsql.exe -s -m -SMS -f1 "setup.iss"
@echo off
