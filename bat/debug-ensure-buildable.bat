echo Searching for Node.js

FOR %%X in (npm) do (set FOUNDNODE=%%~$PATH:X)
IF defined FOUNDNODE (

    echo Found Node.js

) ELSE (

    echo Installing Node.js

    msiexec.exe /i https://nodejs.org/dist/v12.15.0/node-v12.15.0-x64.msi
)

echo Searching for TypeScript Compiler

FOR %%X in (tsc) do (set FOUNDTSC=%%~$PATH:X)
IF defined FOUNDTSC (

    echo Found TypeScript Compiler

) ELSE (

    echo Installing TypeScript

    CALL npm install typescript -g
)