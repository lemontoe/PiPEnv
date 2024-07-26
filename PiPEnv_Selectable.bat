@echo off
setlocal enabledelayedexpansion

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto continue ) else ( goto getadmin )

:getadmin
title PiPEnv
echo Requesting administrative privileges...
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:continue
title PiPEnv
echo NOTE: If you have the Microsoft Store version of Python, this script may not be applicable.
echo.

set BASE_PATH=%LOCALAPPDATA%\Programs\Python

if not exist "%BASE_PATH%" (
    echo No Python installations found in %BASE_PATH%.
    pause
    exit /B
)

set count=0
for /d %%D in ("%BASE_PATH%\*") do (
    set /a count+=1
    set "PYTHON_DIRS[!count!]=%%~nxD"
)

if %count% == 0 (
    echo No Python installations found in %BASE_PATH%.
    pause
    exit /B
)

echo Available Python installations:
for /l %%I in (1,1,%count%) do (
    echo %%I. !PYTHON_DIRS[%%I]!
)

set /p selection="Please select a Python installation (1-%count%): "

if %selection% lss 1 if %selection% gtr %count% (
    echo Invalid selection.
    pause
    exit /B
)

set "PYTHON_INSTALL_DIR=%BASE_PATH%\!PYTHON_DIRS[%selection%]!"

if exist "%PYTHON_INSTALL_DIR%" (
    setx PATH "%PATH%;%PYTHON_INSTALL_DIR%;%PYTHON_INSTALL_DIR%\Scripts"
    echo Python paths added to the user environment variables.
    echo Please restart your command prompt or computer for the changes to take effect.
) else (
    echo Specified Python install directory does not exist.
    echo Please check if the directory is correct and the installation is complete.
)

pause