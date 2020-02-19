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