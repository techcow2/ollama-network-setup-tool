@echo off
setlocal
title Ollama Network Exposer
color 1F

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :START
) else (
    echo.
    echo ========================================================
    echo  ERROR: ADMINISTRATOR PRIVILEGES REQUIRED
    echo ========================================================
    echo.
    echo  Please right-click this file and select "Run as Administrator".
    echo  This is needed to configure the Windows Firewall.
    echo.
    pause
    exit
)

:START
cls
echo ========================================================
echo      OLLAMA LOCAL NETWORK SETUP TOOL
echo ========================================================
echo.
echo  Steps to be performed:
echo  1. Set OLLAMA_HOST to 0.0.0.0 (Allows external connections)
echo  2. Open Port 11434 in Windows Firewall
echo  3. Restart Ollama Service
echo.
pause
echo.

:: 1. Set the Environment Variable
echo [*] Setting OLLAMA_HOST environment variable...
:: Try setting system-wide first (more reliable, requires admin)
setx OLLAMA_HOST "0.0.0.0" /M >nul
if %errorLevel% EQU 0 (
    echo     [OK] System-wide variable set successfully.
) else (
    echo     [!] Could not set system-wide variable. Trying user-level...
    setx OLLAMA_HOST "0.0.0.0" >nul
    if %errorLevel% EQU 0 (
        echo     [OK] User variable set successfully.
    ) else (
        echo     [ERROR] Failed to set variable.
    )
)
echo.

:: 2. Configure Firewall
echo [*] Configuring Windows Firewall...
:: Remove old rule if it exists to avoid duplicates
netsh advfirewall firewall delete rule name="Ollama LAN Access" >nul 2>&1
:: Add new rule
netsh advfirewall firewall add rule name="Ollama LAN Access" dir=in action=allow protocol=TCP localport=11434 >nul
if %errorLevel% EQU 0 (
    echo     [OK] Firewall port 11434 opened.
) else (
    echo     [ERROR] Failed to open firewall port.
)
echo.

:: 3. Restart Ollama Application
echo [*] Stopping running Ollama instances...
taskkill /F /IM "ollama.exe" >nul 2>&1
taskkill /F /IM "ollama app.exe" >nul 2>&1
echo     [OK] Ollama stopped.
echo.
echo [*] Starting Ollama...
:: Try to start from default install location
if exist "%LOCALAPPDATA%\Programs\Ollama\ollama app.exe" (
    start "" "%LOCALAPPDATA%\Programs\Ollama\ollama app.exe"
    echo     [OK] Ollama application started.
) else (
    echo     [!] Could not auto-start Ollama. Please open the Ollama app manually after restart.
)
echo.

:: 4. Display Connection Info
echo ========================================================
echo                 SETUP COMPLETE!
echo ========================================================
echo.
echo  You can now connect to this PC from other devices.
echo  Use one of the IP addresses below:
echo.
echo  YOUR IPs:
ipconfig | findstr /i "IPv4"
echo.
echo  Example URL: http://[YOUR_IP_ABOVE]:11434
echo.
echo  IMPORTANT:
echo  While we restarted the Ollama app, Windows environment variables 
echo  sometimes require a full system restart to take effect reliably.
echo.
echo ========================================================
echo.

:ASK_RESTART
set /P RESTART_CHOICE="Would you like to restart your computer now? (Y/N): "
if /I "%RESTART_CHOICE%"=="Y" goto :DO_RESTART
if /I "%RESTART_CHOICE%"=="N" goto :NO_RESTART
echo Please enter Y or N.
goto :ASK_RESTART

:DO_RESTART
echo.
echo Restarting Windows...
shutdown /r /t 5
exit

:NO_RESTART
echo.
echo Okay, restart skipped. If you cannot connect, please restart manually later.
echo Press any key to exit...
pause >nul
exit
