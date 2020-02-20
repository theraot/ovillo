@echo off
SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"
SET batpath=%basepath%\bat
IF not exist "%batpath%" GOTO NoBatFolder

pushd %basepath%
    IF %1.==. GOTO No1
    pushd %1
        SET rootpath=%cd%
        IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    popd
    GOTO Work

:No1
    SET rootpath=%~dp0
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    SET rootpath=%rootpath%\src
    GOTO Work

:Work
    echo Working on: "%rootpath%"
    If not exist "%rootpath%" GOTO NoSource
    CALL "%batpath%\ensure-debug-buildable.bat"
    CALL "%batpath%\debug-build-clean.bat"
    CALL "%batpath%\build-debug-actual.bat" %rootpath%
    GOTO End

:NoSource
    echo Not found source folder, expected path: "%rootpath%"
    echo Currnet script: %~f0
    GOTO End
popd

:NoBatFolder
    echo Not found bat folder, expected path "%batpath%"
    echo Currnet script: %~f0
    GOTO End

:End