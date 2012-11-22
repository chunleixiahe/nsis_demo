
Name "复制文件夹"
OutFile "复制文件夹.exe"
ShowInstDetails show

Section "复制文件夹"
  ;C:\install_test 是带着文件夹拷贝， C:\install_test\* 是拷贝指定文件夹下的文件
  CopyFiles /SILENT  "C:\install_test\*" "C:\install_test2"
 	DetailPrint "复制文件夹的结果是"
 	IfErrors err noerr
  err:
  DetailPrint "发生错误"
	Goto over
	noerr:
	DetailPrint "没有发生错误"
	Goto over
	over:
  
SectionEnd

Section  "检查文件是否存在"

SectionEnd


