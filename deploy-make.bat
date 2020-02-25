@echo off
SET mypath=%~dp0
pushd %mypath%
    SET mypath = %cd%
    CALL %mypath%\bat\make-deploy.bat %mypath%\src
popd