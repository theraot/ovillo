@echo off
echo Searching for Babel Minify

FOR %%X in (minify) do (set FOUNDUJS=%%~$PATH:X)
IF defined FOUNDUJS (

    echo Found Babel Minify

) ELSE (

    echo Installing Babel Minify

    CALL npm install babel-minify -g
)

echo Searching for uglifycss

FOR %%X in (uglifycss) do (set FOUNDUCSS=%%~$PATH:X)
IF defined FOUNDUCSS (

    echo Found uglifycss

) ELSE (

    echo Installing uglifycss

    CALL npm install uglifycss -g
)