IF %1.==. GOTO No1
    SET rootpath=%1
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource
    SET batpath=%~dp0
    IF "%batpath:~-1%"=="\" SET "batpath=%batpath:~0,-1%"
    echo Copying from source to compile
    xcopy "%rootpath%\*.*" "%cd%\.compile\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt
    GOTO End

:NoSource
    echo Not found source folder, expected path: "%rootpath%"
    echo Currnet script: %~f0
    GOTO End

:No1
    echo Missing path 
    GOTO End

:End