@echo off
SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"
SET batpath=%basepath%\bat
IF not exist "%batpath%" GOTO NoBatFolder

pushd %basepath%
        CALL "%batpath%\debug-ensure-buildable.bat"
        CALL "%batpath%\debug-build-clean.bat"

        IF %1.==. GOTO No1
        pushd %1
            SET rootpath=%cd%
            IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
        popd
        call :AddSource %rootpath%
        GOTO Work

    :No1
        SET rootpath=%~dp0
        IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
        SET rootpath=%rootpath%\src
        call :AddSource %rootpath%
        GOTO Work

    :Work
        pushd "%cd%\.obj\"
            echo Compiling TypeScript
            CALL tsc -p tsconfig.json
        popd
        CALL "%batpath%\debug-build-complete.bat" %rootpath%
        GOTO Postwork

    :Postwork
popd
Goto End

:NoBatFolder
    echo Not found bat folder, expected path "%batpath%"
    echo Currnet script: %~f0
    GOTO End

:AddSource
    echo Working on: "%~1"
    If not exist "%~1" GOTO NoSource
    CALL "%batpath%\debug-build-add.bat" %~1
    GOTO AddSourceEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO AddSourceEnd
    :AddSourceEnd
GOTO:eof

:End