@echo off
SET mypath=%~dp0
IF "%mypath:~-1%"=="\" SET "mypath=%mypath:~0,-1%"

echo Searching for uglifyjs

for %%X in (uglifyjs) do (set FOUNDUJS=%%~$PATH:X)
if defined FOUNDUJS (

    echo uglifyjs found

) else (

    echo Installing uglifyjs

    call npm install uglify-js -g
)

echo Searching for uglifycss

for %%X in (uglifycss) do (set FOUNDUCSS=%%~$PATH:X)
if defined FOUNDUCSS (

    echo uglifycss found

) else (

    echo Installing uglifycss

    call npm install uglifycss -g
)