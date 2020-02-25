SET basepath=%~dp0
IF "%basepath:~-1%"=="\" SET "basepath=%basepath:~0,-1%"

IF %1.==. GOTO NoArg
CALL "%basepath%\archive-clean.bat"
FOR %%A IN (%*) DO CALL :ArchivePut %%A

CALL "%basepath%\build-ensure.bat"
pushd "%cd%\.archive\"
    echo Building TypeScript
    CALL tsc -b tsconfig.json
popd

CALL "%basepath%\compile-clean.bat"
FOR %%A IN (%*) DO CALL :CompilePut %%A
echo Copying from build to compile
xcopy "%cd%\.build\*.*" "%cd%\.compile\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt

CALL "%basepath%\deploy-clean.bat"
CALL "%basepath%\deploy-ensure.bat"
CALL "%basepath%\deploy-from-compile.bat"
Goto End

:ArchivePut
    pushd %~1
        SET rootpath=%cd%
    popd
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    echo Working on: "%rootpath%"
    CALL "%basepath%\archive-put.bat" %rootpath%
    GOTO ArchivePutEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO ArchivePutEnd
    :ArchivePutEnd
GOTO:eof

:CompilePut
    pushd %~1
        SET rootpath=%cd%
    popd
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    echo Working on: "%rootpath%"
    CALL "%basepath%\compile-put.bat" %rootpath%
    GOTO CompilePutEnd
    :NoSource
        echo Not found source folder, expected path: "%rootpath%"
        echo Currnet script: %~f0
        GOTO CompilePutEnd
    :CompilePutEnd
GOTO:eof

:NoArg
    echo Missing path to source
    Goto End

:End