@echo off
SET batpath=%~dp0
IF "%batpath:~-1%"=="\" SET "batpath=%batpath:~0,-1%"

CALL "%batpath%\ensure-release-buildable.bat"
echo Cleaning release build
IF not exist "%cd%\.release\" mkdir "%cd%\.release\"
pushd "%cd%\.release\"
    rd /s /q . 2>nul
popd
echo Copying to release build
xcopy "%cd%\.debug\*.*" "%cd%\.release\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt
pushd "%cd%\.release"
    echo Minifying JavaScript
    FOR /r %%i in (*.js) do CALL minify %%i --out-file %%i           
    echo Minifying CSS
    FOR /r %%i in (*.css) do CALL uglifycss %%i --output %%i
popd