IF %1.==. GOTO No1
    SET rootpath=%1
    IF "%rootpath:~-1%"=="\" SET "rootpath=%rootpath:~0,-1%"
    If not exist "%rootpath%" GOTO NoSource   
    echo Copying to obj
    xcopy "%rootpath%\*.*" "%cd%\.obj\" /S /Y
    GOTO End

:NoSource
    echo Not found source folder, expected path: "%rootpath%"
    echo Currnet script: %~f0
    GOTO End

:No1
    echo Missing path 
    GOTO End

:End