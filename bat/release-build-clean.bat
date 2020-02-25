echo Cleaning release
IF not exist "%cd%\.release\" mkdir "%cd%\.release\"
pushd "%cd%\.release"
    rd /s /q . 2>nul
popd