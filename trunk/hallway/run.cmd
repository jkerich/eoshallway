@echo off
set fileName=%1
SHIFT
:Loop
IF "%1" =="" GOTO Continue
	set fileName=%fileName% %1
SHIFT
GOTO Loop
:Continue
start "" "%fileName%"