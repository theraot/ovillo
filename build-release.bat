@echo off
SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"
SET batpath=%basepath%\bat
IF not exist "%batpath%" GOTO NoBatFolder

pushd %basepath%
    CALL "%batpath%\debug-ensure-buildable.bat"
    CALL "%batpath%\debug-build-clean.bat"
popd

    IF %1.==. GOTO No1Add
    FOR %%A IN (%*) DO CALL :AddSource %%A
    GOTO Work
:No1Add
    call :AddSource %~dp0\src
    GOTO Work
:Work
    pushd %basepath%
        pushd "%cd%\.obj\"
            echo Compiling TypeScript
            CALL tsc -p tsconfig.json
        popd
    popd
    IF %1.==. GOTO No1Complete
    FOR %%A IN (%*) DO CALL :CompleteSource %%A
    GOTO Postwork
:No1Complete
    call :CompleteSource %~dp0\src
    GOTO Postwork

:PostWork
    pushd %basepath%
        CALL "%batpath%\release-ensure-buildable.bat"
        CALL "%batpath%\release-build-clean.bat"
        CALL "%batpath%\release-from-debug.bat"
    popd
    Goto End

:NoBatFolder
    echo Not found bat folder, expected path "%batpath%"
    echo Currnet script: %~f0
    GOTO End

:AddSource
    pushd %~1
        SET rootpath=%cd%
    popd
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    echo Working on: "%rootpath%"
    pushd %basepath%
        CALL "%batpath%\debug-build-add.bat" %rootpath%
    popd
    GOTO AddSourceEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO AddSourceEnd
    :AddSourceEnd
GOTO:eof

:CompleteSource
    pushd %~1
        SET rootpath=%cd%
    popd
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    echo Working on: "%rootpath%"
    pushd %basepath%
        CALL "%batpath%\debug-build-complete.bat" %rootpath%
    popd
    GOTO AddSourceEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO AddSourceEnd
    :AddSourceEnd
GOTO:eof

:End