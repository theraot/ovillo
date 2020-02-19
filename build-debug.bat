@echo off
SET mypath=%~dp0
IF "%mypath:~-1%"=="\" SET "mypath=%mypath:~0,-1%"

call ensure-debug-buildable.bat

echo Cleaning debug build

if not exist "%mypath%\.debug" mkdir "%mypath%\.debug"

pushd "%mypath%\.debug"

    rd /s /q . 2>nul

popd

if not exist "%mypath%\src" (

    echo Source not found

) else (
    pushd "%mypath%\src"

        echo Compiling TypeScript

        call tsc -p tsconfig.json
    popd

    echo Copying to debug build

    xcopy "%mypath%\src\*.*" "%mypath%\.debug\" /S /Y /exclude:xcopy-exclusion-list.txt
)