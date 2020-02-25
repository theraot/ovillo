SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"

IF %1.==. GOTO NoArg
CALL "%basepath%\debug-ensure-buildable.bat"
CALL "%basepath%\debug-build-clean.bat"
FOR %%A IN (%*) DO CALL :AddSource %%A

pushd "%cd%\.tmp\"
    echo Compiling TypeScript
    CALL tsc -b tsconfig.json
popd
FOR %%A IN (%*) DO CALL :CompleteSource %%A

echo Copying from obj to debug
xcopy "%cd%\.obj\*.*" "%cd%\.debug\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt

CALL "%basepath%\release-ensure-buildable.bat"
CALL "%basepath%\release-build-clean.bat"
CALL "%basepath%\release-from-debug.bat"
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

:NoArg
    echo Missing path to source
    Goto End

:End