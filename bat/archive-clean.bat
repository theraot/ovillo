echo Cleaning archive
IF not exist "%cd%\.archive\" mkdir "%cd%\.archive\"
pushd "%cd%\.archive"
    rd /s /q . 2>nul
popd