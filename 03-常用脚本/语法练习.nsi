

Name "Óï·¨"
OutFile "Óï·¨.exe"
ShowInstDetails show



Section "Óï·¨"

	!if 1 < 2
	  ;!echo "1 is smaller than 2!!"
	   MessageBox MB_OK "1 is smaller than 2!!"
	!else if ! 3.1 > 1.99
	  ;!error "this line should never appear"
		MessageBox MB_OK "3.1 > 1.99"
	!else
	  MessageBox MB_OK "neither should this"
	!endif

SectionEnd
