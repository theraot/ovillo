@echo off
echo Cleaning obj build
IF not exist "%cd%\.obj\" mkdir "%cd%\.obj\"
pushd "%cd%\.obj"
    rd /s /q . 2>nul
popd
echo Cleaning debug build
IF not exist "%cd%\.debug\" mkdir "%cd%\.debug\"
pushd "%cd%\.debug\"
    rd /s /q . 2>nul
popd