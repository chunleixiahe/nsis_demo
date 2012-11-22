@echo off  


set JAVA_HOME=./jdk1.6.0_25/
set path=;%JAVA_HOME%\bin;

java -jar GetSysInfo.jar
 
echo.
echo 按任意键退出...
pause>nul