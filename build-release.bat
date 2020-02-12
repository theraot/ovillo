@echo off
SET mypath=%~dp0
IF "%mypath:~-1%"=="\" SET "mypath=%mypath:~0,-1%"

call build-debug.bat

echo Cleaning release build

if not exist "%mypath%\release" mkdir "%mypath%\release"

pushd "%mypath%\release"

    rd /s /q . 2>nul

popd

echo Copying to release build

xcopy "%mypath%\debug\*.*" "%mypath%\release\" /S /Y /exclude:xcopy-exclusion-list.txt

pushd "%mypath%\release"
    
    echo Minifying JavaScript

    for /r %%i in (*.js) do call uglifyjs %%i --output %%i
    
    echo Minifying CSS
    
    for /r %%i in (*.css) do call uglifycss %%i --output %%i
popd