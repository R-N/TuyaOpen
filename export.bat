@echo off
setlocal enabledelayedexpansion

:: Set SDK root
set OPEN_SDK_ROOT=%~dp0
set OPEN_SDK_ROOT=%OPEN_SDK_ROOT:~0,-1%
echo OPEN_SDK_ROOT = %OPEN_SDK_ROOT%
cd /d %OPEN_SDK_ROOT%
echo Current working directory = %CD%

:: Check if Python is installed
echo Checking Python version...
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH!
    echo Please install Python 3.6.0 or higher.
    pause
    exit /b 1
)

:: Get Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Using Python %PYTHON_VERSION%

:: Check Python >= 3.6
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set MAJOR=%%a
    set MINOR=%%b
)
if %MAJOR% LSS 3 (
    echo Error: Python version %PYTHON_VERSION% is too old!
    pause
    exit /b 1
)
if %MAJOR% EQU 3 if %MINOR% LSS 6 (
    echo Error: Python version %PYTHON_VERSION% is too old!
    pause
    exit /b 1
)

:: Set environment variables
set OPEN_SDK_PYTHON=python
set OPEN_SDK_PIP=pip
set PATH=%PATH%;%OPEN_SDK_ROOT%

:: DOSKEY shortcuts
DOSKEY tos.py=python %OPEN_SDK_ROOT%\tos.py $*
DOSKEY exit=echo Exiting TuyaOpen environment... $T set OPEN_SDK_PYTHON= $T set OPEN_SDK_PIP= $T set OPEN_SDK_ROOT= $T echo TuyaOpen environment deactivated. $T exit

:: Install dependencies
echo Installing dependencies...
pip install -r %OPEN_SDK_ROOT%\requirements.txt
if errorlevel 1 (
    echo Warning: Some dependencies may not have been installed correctly.
)

:: Remove cache files
set CACHE_PATH=%OPEN_SDK_ROOT%\.cache
mkdir %CACHE_PATH% 2>nul
if exist "%CACHE_PATH%\.env.json" del /F /Q "%CACHE_PATH%\.env.json"
if exist "%CACHE_PATH%\.dont_prompt_update_platform" del /F /Q "%CACHE_PATH%\.dont_prompt_update_platform"

:: Hello Tuya
echo ****************************************
echo  ______                 ____
echo /_  __/_ ____ _____ _  / __ \___  ___ ___
echo  / / / // / // / _ `/ / /_/ / _ \/ -_) _ \
echo          /___/            /_/
echo Exit use: exit
echo ****************************************

:: Keep cmd open
cmd /k
