REM
@echo off
echo 1/4 Checking admin
echo -----------------
echo  BATCH GOT ADMIN
echo -----------------

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
echo 2/4 Installing chocolatey
powershell.exe -c Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
echo 3/4 Installing chocolatey packages
"%CSIDL_COMMON_APPDATA%/chocolatey/choco.exe" install chocolateygui
"%CSIDL_COMMON_APPDATA%/chocolatey/choco.exe" install chromium
"%CSIDL_COMMON_APPDATA%/chocolatey/choco.exe" install files
"%CSIDL_COMMON_APPDATA%/chocolatey/choco.exe" install mailspring

