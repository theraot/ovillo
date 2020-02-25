echo Cleaning compile
IF not exist "%cd%\.compile\" mkdir "%cd%\.compile\"
pushd "%cd%\.compile\"
    rd /s /q . 2>nul
popd