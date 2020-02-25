SET batpath=%~dp0
IF "%batpath:~-1%"=="\" SET "batpath=%batpath:~0,-1%"
echo Copying from compile to deploy
xcopy "%cd%\.compile\*.*" "%cd%\.deploy\" /S /Y /exclude:%batpath%\xcopy-exclusion-list.txt
pushd "%cd%\.deploy"
    echo Minifying JavaScript
    FOR /r %%i in (*.js) do CALL minify %%i --out-file %%i
    echo Minifying CSS
    FOR /r %%i in (*.css) do CALL uglifycss %%i --output %%i
popd