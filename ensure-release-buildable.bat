@echo off
SET mypath=%~dp0
IF "%mypath:~-1%"=="\" SET "mypath=%mypath:~0,-1%"

echo Searching for Babel Minify

for %%X in (minify) do (set FOUNDUJS=%%~$PATH:X)
if defined FOUNDUJS (

    echo Babel Minify found

) else (

    echo Installing Babel Minify

    call npm install babel-minify -g
)

echo Searching for uglifycss

for %%X in (uglifycss) do (set FOUNDUCSS=%%~$PATH:X)
if defined FOUNDUCSS (

    echo uglifycss found

) else (

    echo Installing uglifycss

    call npm install uglifycss -g
)