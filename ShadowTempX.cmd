@echo off
title ShadowTempX
set LogFolder=%~dp0\Logs

call :isAdmin
if %errorlevel% neq 0 (
    echo Please run this script as Administrator.
    pause
    exit /b 1
)

if not exist "%LogFolder%" mkdir "%LogFolder%"
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set LogTimestamp=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set LogFile=%LogFolder%\Log_%LogTimestamp%.txt

echo Cleaning up user temporary files...
echo Cleaning up user temporary files... >>"%LogFile%" 2>&1
del /q /s /f %TEMP%\*.* >>"%LogFile%" 2>&1
for /d %%i in (%TEMP%\*) do rd /s /q "%%i" >>"%LogFile%" 2>&1

echo Cleaning up system temporary files... 
echo Cleaning up system temporary files... >>"%LogFile%" 2>&1
del /q /s /f C:\Windows\Temp\*.* >>"%LogFile%" 2>&1
for /d %%i in (C:\Windows\Temp\*) do rd /s /q "%%i" >>"%LogFile%" 2>&1

for /f "skip=2 delims=" %%F in ('dir /b /o-d "%LogFolder%\Log_*.txt"') do del /q "%LogFolder%\%%F"
echo.
echo Temporary files and folders cleaned successfully.
echo.
echo.
echo You can now close this window; it will close automatically in 3 seconds.
timeout /t 3 >nul
exit /b 0

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b %errorlevel%
