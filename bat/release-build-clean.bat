echo Cleaning deploy
IF not exist "%cd%\.deploy\" mkdir "%cd%\.deploy\"
pushd "%cd%\.deploy"
    rd /s /q . 2>nul
popd