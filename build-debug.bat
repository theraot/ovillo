@echo off
SET mypath=%~dp0
IF "%mypath:~-1%"=="\" SET "mypath=%mypath:~0,-1%"

echo Searching Node.js

for %%X in (npm) do (set FOUNDNODE=%%~$PATH:X)
if defined FOUNDNODE (

    echo Node.js found

) else (

    echo Installing Node.js

    msiexec.exe /i https://nodejs.org/dist/v12.15.0/node-v12.15.0-x64.msi
)

echo Searching for TypeScript Compiler

for %%X in (tsc) do (set FOUNDTSC=%%~$PATH:X)
if defined FOUNDTSC (

    echo TypeScript Compiler found

) else (

    echo Installing TypeScript

    call npm install typescript -g
)

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

echo Cleaning debug build

if not exist "%mypath%\debug" mkdir "%mypath%\debug"

pushd "%mypath%\debug"

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

    xcopy "%mypath%\src\*.*" "%mypath%\debug\" /S /Y /exclude:xcopy-exclusion-list.txt
)