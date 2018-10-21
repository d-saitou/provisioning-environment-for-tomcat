@echo off

:: Get vagrant.exe path
for /f "usebackq delims=" %%a in (`where vagrant`) do set VAGRANTEXE=%%a

if "%VAGRANTEXE%" equ "" (
	echo.
	echo Please install vagrant.
	echo.
	pause
	exit
)

echo.
echo ***********************************
echo  vagrant initialization start!!
echo ***********************************
echo.

:: Install vagrant-vbguest plugin
for /f "usebackq tokens=*" %%i IN (`vagrant plugin list`) DO @set RESULT=%%i
echo %RESULT% | find "vagrant-vbguest" >NUL
if ERRORLEVEL 1 vagrant plugin install vagrant-vbguest

:: Change current directory
cd /d %~dp0

:: Get tee.exe path
set TEEEXE=%VAGRANTEXE:\bin\vagrant.exe=%\embedded\usr\bin\tee.exe

:: vagrant up
set LOGFILE=vagrantup.log
vagrant up 2>&1 | %TEEEXE% %LOGFILE%

:: Check mount vboxsf
:: 
:: [Note]
::  When the kernel is reinstalled at the time of starting the virtual machine,
::  the version of Vagnrant GuestAdditions does not correspond to the kernel,
::  so mounting of vboxsf may fail.
::  Therefore, if mounting of vboxsf fails, execute "yum update" to update the kernel,
::  then reboot the virtual machine and install Vagrant GuestAdditions again.
::
set ISMOUNTERROR=FALSE

type %LOGFILE% | find "mount: unknown filesystem type 'vboxsf'" >NUL
if %ERRORLEVEL% == 0 set ISMOUNTERROR=TRUE

type %LOGFILE% | find "/sbin/mount.vboxsf: mounting failed with the error: No such device" >NUL
if %ERRORLEVEL% == 0 set ISMOUNTERROR=TRUE

if %ISMOUNTERROR% == TRUE (
	vagrant ssh --command "sudo yum update -y" 2>&1 | %TEEEXE% %LOGFILE%
	vagrant reload 2>&1 | %TEEEXE% %LOGFILE%
)

del /Q %LOGFILE% 2>&1

echo.
echo ***********************************
echo  vagrant initialization finished!!
echo ***********************************
echo.

pause
