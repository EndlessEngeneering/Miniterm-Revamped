@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
set "VER=v1.0"
set "MENU_LEVEL=main"
color 0B

echo Initialising Miniterm Revamped %VER%
echo.
<nul set /p "=["
for /L %%I in (1,1,30) do <nul set /p "=#"
echo ] Done
echo.

echo [check] Looking for Ruby...
where ruby >nul 2>&1
if errorlevel 1 (
    echo Ruby was not found. Install Ruby and ensure it is on your PATH.
    goto :error
)

echo [check] Looking for RubyGems...
where gem >nul 2>&1
if errorlevel 1 (
    echo RubyGems was not found. Reinstall Ruby with RubyGems enabled.
    goto :error
)

echo [check] Checking tty-prompt...
gem list -i tty-prompt >nul 2>&1
if errorlevel 1 (
    echo Installing the tty-prompt gem...
    gem install tty-prompt --no-document
    if errorlevel 1 (
        echo Failed to install tty-prompt. Check your internet connection and RubyGems setup.
        goto :error
    )
)

echo [ready] Dependencies verified.
timeout /t 1 /nobreak >nul

:menu
cls
call :banner
set "MENU_FILE=%TEMP%\miniterm-menu-%RANDOM%-%RANDOM%.tmp"
set "ACTION="
ruby "%SCRIPT_DIR%1.rb" > "%MENU_FILE%"
if errorlevel 1 (
    del /q "%MENU_FILE%" >nul 2>&1
    echo The menu could not be started. Check that tty-prompt is installed.
    goto :error
)
set /p "ACTION="<"%MENU_FILE%"
del /q "%MENU_FILE%" >nul 2>&1

if "%ACTION%"=="check_ip" (
    set "MENU_LEVEL=network"
    goto :menu
)
if "%ACTION%"=="SYS_DISK" goto :disk
if "%ACTION%"=="SYS_MEM" goto :memory
if "%ACTION%"=="LCL" goto :local_ip
if "%ACTION%"=="ONL" goto :public_ip
if "%ACTION%"=="sub_back" (
    set "MENU_LEVEL=main"
    goto :menu
)
if "%ACTION%"=="exit_menu" goto :exit
set "MENU_LEVEL=main"
goto :menu

:banner
echo +----------------------------------------------+
echo ^|  Miniterm Revamped                           ^|
echo ^|  System utilities - version %VER%                 ^|
echo +----------------------------------------------+
echo.
exit /b 0

:disk
echo.
echo -- DISK USAGE --
echo.
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{Name='SizeGB';Expression={[math]::Round($_.Size/1GB,2)}},@{Name='FreeGB';Expression={[math]::Round($_.FreeSpace/1GB,2)}} | Format-Table -AutoSize"
pause
set "MENU_LEVEL=main"
goto :menu

:memory
echo.
echo -- MEMORY USAGE --
echo.
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; 'Total RAM: {0:N2} GB' -f ($os.TotalVisibleMemorySize/1MB); 'Free RAM:  {0:N2} GB' -f ($os.FreePhysicalMemory/1MB)"
pause
set "MENU_LEVEL=main"
goto :menu

:local_ip
echo.
echo -- LOCAL NETWORK --
echo.
powershell -NoProfile -Command "Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object {$_.IPAddress -ne '127.0.0.1' -and $_.IPAddress -notlike '169.254*'} | Select-Object -ExpandProperty IPAddress"
pause
set "MENU_LEVEL=network"
goto :menu

:public_ip
echo.
echo -- PUBLIC NETWORK --
echo.
powershell -NoProfile -Command "try {(Invoke-RestMethod -Uri 'https://icanhazip.com' -TimeoutSec 10).Trim()} catch {Write-Error 'Unable to fetch public IP. Check internet access.'; exit 1}"
pause
set "MENU_LEVEL=network"
goto :menu

:exit
echo.
echo Goodbye!
color 07
exit /b 0

:error
echo.
pause
color 07
exit /b 1
