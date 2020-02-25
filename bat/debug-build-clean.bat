echo Cleaning tmp
IF not exist "%cd%\.tmp\" mkdir "%cd%\.tmp\"
pushd "%cd%\.tmp"
    rd /s /q . 2>nul
popd
echo Cleaning debug
IF not exist "%cd%\.debug\" mkdir "%cd%\.debug\"
pushd "%cd%\.debug\"
    rd /s /q . 2>nul
popd