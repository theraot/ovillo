echo Cleaning archive
IF not exist "%cd%\.archive\" mkdir "%cd%\.archive\"
pushd "%cd%\.archive"
    rd /s /q . 2>nul
popd
echo Cleaning compile
IF not exist "%cd%\.compile\" mkdir "%cd%\.compile\"
pushd "%cd%\.compile\"
    rd /s /q . 2>nul
popd