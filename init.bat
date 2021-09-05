@echo off

:: get vagrant.exe path
for /f "usebackq delims=" %%a in (`where vagrant`) do set VAGRANTEXE=%%a
if "%VAGRANTEXE%" equ "" (
	echo Please install vagrant.
	pause
	exit
)

:: install vagrant-vbguest plugin
for /f "usebackq tokens=*" %%i IN (`vagrant plugin list`) DO @set RESULT=%%i
echo %RESULT% | find "vagrant-vbguest" >NUL
if ERRORLEVEL 1 vagrant plugin install vagrant-vbguest

:: change current directory
cd /d %~dp0

:: vagrant up
set TEEEXE=%VAGRANTEXE:\bin\vagrant.exe=%\embedded\usr\bin\tee.exe
set LOGFILE=init.log
vagrant up 2>&1 | %TEEEXE% -a %LOGFILE%

:: check mount point
type %LOGFILE% | find "umount: /mnt: no mount point specified." >NUL
if %ERRORLEVEL% == 0 (
	vagrant ssh --command "sudo mkdir /mnt" 2>&1 | %TEEEXE% -a %LOGFILE%
	vagrant reload 2>&1 | %TEEEXE% -a %LOGFILE%
)

:: check mount vboxsf
set ISMOUNTERROR=FALSE

type %LOGFILE% | find "mount: unknown filesystem type 'vboxsf'" >NUL
if %ERRORLEVEL% == 0 set ISMOUNTERROR=TRUE

type %LOGFILE% | find "/sbin/mount.vboxsf: mounting failed with the error: No such device" >NUL
if %ERRORLEVEL% == 0 set ISMOUNTERROR=TRUE

if %ISMOUNTERROR% == TRUE (
	vagrant ssh --command "sudo yum -y update" 2>&1 | %TEEEXE% -a %LOGFILE%
	vagrant ssh --command "sudo yum -y install gcc gcc-c++ make bzip2 kernel-headers kernel-devel elfutils-libelf-devel perl tar" 2>&1 | %TEEEXE% -a %LOGFILE%
	vagrant reload 2>&1 | %TEEEXE% -a %LOGFILE%
)

pause
