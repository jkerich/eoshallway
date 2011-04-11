@echo off
TASKKILL /T /F /IM pptview.exe
set fileName=%1
SHIFT
:Loop
IF "%1" =="" GOTO Continue
	set fileName=%fileName% %1
SHIFT
GOTO Loop
:Continue
start "" /WAIT "%fileName%"
echo "Exit"