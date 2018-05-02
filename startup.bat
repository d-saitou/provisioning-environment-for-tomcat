@echo off

:: Change current directory
cd /d %~dp0

:: Install vagrant-vbguest plugin
for /f "usebackq tokens=*" %%i IN (`vagrant plugin list`) DO @set RESULT=%%i
echo %RESULT% | find "vagrant-vbguest" >NUL
if ERRORLEVEL 1 vagrant plugin install vagrant-vbguest

:: Open command-prompt & startup vagrant
start cmd /k vagrant up

