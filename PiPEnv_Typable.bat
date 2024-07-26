@echo off
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
echo NOTE: If you have the microsoft store verison of Python, this will be useless to you.
echo.
set /p PYTHON_INSTALL_DIR="Please enter your Python install directory: "

if exist "%PYTHON_INSTALL_DIR%" (
    setx PATH "%PATH%;%PYTHON_INSTALL_DIR%;%PYTHON_INSTALL_DIR%\Scripts"
    echo Python paths added to the user environment variables.
    echo Please restart your command prompt, or computer for the changes to take effect.
) else (
    echo Specified Python install directory does not exist.
    echo Please check if the directory is correct and the installation is complete.
)

pause