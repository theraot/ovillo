SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"
CALL "%basepath%\debug-build-clean.bat"
CALL "%basepath%\debug-ensure-buildable.bat"
CALL "%basepath%\debug-build-clean.bat"
IF %1.==. GOTO No1Add
FOR %%A IN (%*) DO CALL :AddSource %%A
GOTO Work

:No1Add
    call :AddSource %~dp0\src
    GOTO Work
:Work
    pushd "%cd%\.obj\"
        echo Compiling TypeScript
        CALL tsc -b tsconfig.json
    popd
    IF %1.==. GOTO No1Complete
    FOR %%A IN (%*) DO CALL :CompleteSource %%A
    GOTO Postwork
:No1Complete
    call :CompleteSource %~dp0\src
    GOTO Postwork

:Postwork
    Goto End

:AddSource
    pushd %~1
        SET rootpath=%cd%
    popd
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    echo Working on: "%rootpath%"
    CALL "%basepath%\debug-build-add.bat" %rootpath%
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
    CALL "%basepath%\debug-build-complete.bat" %rootpath%
    GOTO AddSourceEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO AddSourceEnd
    :AddSourceEnd
GOTO:eof

:End