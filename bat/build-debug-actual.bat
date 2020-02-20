@echo off
IF %1.==. GOTO No1
    SET rootpath=%1
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    
    SET batpath=%~dp0
    IF "%batpath:~-1%"=="\" SET "batpath=%batpath:~0,-1%"
    
    echo Cleaning obj build
    IF not exist "%cd%\.obj\" mkdir "%cd%\.obj\"
    pushd "%cd%\.obj"
        rd /s /q . 2>nul
    popd
    echo Copying to obj
    xcopy "%rootpath%\*.*" "%cd%\.obj\" /S /Y
    CALL "%batpath%\ensure-debug-buildable.bat"
    echo Cleaning debug build
    IF not exist "%cd%\.debug\" mkdir "%cd%\.debug\"
    pushd "%cd%\.debug\"
        rd /s /q . 2>nul
    popd
    pushd "%cd%\.obj\"
        echo Compiling TypeScript
        CALL tsc -p tsconfig.json
    popd
    echo Copying to debug build
    xcopy "%rootpath%\*.*" "%cd%\.debug\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt
    GOTO End

:NoSource
    echo Not found source folder, expected path: "%rootpath%"
    echo Currnet script: %~f0
    GOTO End

:No1
    echo Missing path 
    GOTO End

:End