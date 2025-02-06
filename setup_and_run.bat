@echo off
setlocal enabledelayedexpansion

:: Colors for Windows CMD
set "CYAN=[96m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "MAGENTA=[95m"
set "RESET=[0m"

:: Title
echo %MAGENTA%🎮 Anime Image Enhancer Setup%RESET%
echo %MAGENTA%=============================%RESET%

:: Check Python
echo.
echo %CYAN%🐍 Checking Python installation...%RESET%
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %RED%❌ Python is not installed. Please install Python 3.8-3.11.%RESET%
    exit /b 1
)

:: Check Python version
for /f "tokens=*" %%i in ('python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"') do set PYTHON_VERSION=%%i
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)
if %PYTHON_MAJOR% equ 3 (
    if %PYTHON_MINOR% geq 12 (
        echo %YELLOW%⚠️  Warning: Python %PYTHON_VERSION% detected.%RESET%
        echo %YELLOW%   Some packages might have compatibility issues.%RESET%
        echo %YELLOW%   It's recommended to use Python 3.8-3.11 for better compatibility.%RESET%
    )
)

:: Check Node.js version
echo.
echo %CYAN%📦 Checking Node.js installation...%RESET%
where node >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %RED%❌ Node.js is not installed. Please install Node.js 16 or later.%RESET%
    exit /b 1
)

for /f "tokens=1,2,3 delims=." %%a in ('node -v') do (
    set NODE_VERSION=%%a
    set NODE_VERSION=!NODE_VERSION:v=!
    if !NODE_VERSION! lss 16 (
        echo %RED%❌ Node.js version must be 16 or later. Current version: %%a.%%b.%%c%RESET%
        exit /b 1
    )
)

:: Setup Python environment
echo %CYAN%Setting up Python environment...%RESET%
if not exist "API\venv" (
    echo %YELLOW%Creating virtual environment...%RESET%
    python -m venv API\venv
    if %ERRORLEVEL% neq 0 (
        echo %RED%❌ Failed to create virtual environment%RESET%
        exit /b 1
    )
)

echo %YELLOW%Activating virtual environment...%RESET%
call API\venv\Scripts\activate.bat

:: Install base packages first
echo %YELLOW%Installing base packages...%RESET%
API\venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
if %ERRORLEVEL% neq 0 (
    echo %RED%❌ Failed to install base packages%RESET%
    exit /b 1
)

:: Install Python dependencies
echo %YELLOW%Installing Python dependencies...%RESET%
pip install --no-cache-dir -r API\requirements.txt
if %ERRORLEVEL% neq 0 (
    echo %YELLOW%First installation attempt failed, trying alternative method...%RESET%
    pip install flask==3.0.0 flask-cors==4.0.0 numpy==1.24.3 Werkzeug==3.0.1
    pip install opencv-python==4.8.1.78 opencv-contrib-python==4.8.1.78 --no-deps
    if %ERRORLEVEL% neq 0 (
        echo %RED%❌ Installation failed. Please try using Python 3.8-3.11%RESET%
        exit /b 1
    )
)
echo %GREEN%✅ Python setup complete!%RESET%

:: Check and install pnpm
echo %YELLOW%Checking pnpm installation...%RESET%
where pnpm >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo %YELLOW%Installing pnpm globally...%RESET%
    call npm install -g pnpm
    if %ERRORLEVEL% neq 0 (
        echo %RED%❌ Failed to install pnpm%RESET%
        exit /b 1
    )
)

:: Install frontend dependencies
echo %YELLOW%Installing frontend dependencies...%RESET%
cd "Anime Image Enhancer UI"
call pnpm install
if %ERRORLEVEL% neq 0 (
    echo %RED%❌ Failed to install frontend dependencies%RESET%
    cd ..
    exit /b 1
)
cd ..
echo %GREEN%✅ Node.js setup complete!%RESET%

:: Create necessary directories
echo.
echo %CYAN%🚀 Setting up project directories...%RESET%
if not exist "API\uploads" mkdir "API\uploads"
if not exist "Anime Image Enhancer UI\public\outputs" mkdir "Anime Image Enhancer UI\public\outputs"

:: Start the servers
echo %YELLOW%Starting backend server...%RESET%
start "Backend Server" cmd /k "cd API && ..\API\venv\Scripts\activate.bat && python api.py"

echo %YELLOW%Starting frontend server...%RESET%
start "Frontend Server" cmd /k "cd Anime Image Enhancer UI && pnpm dev"

:: Final message
echo.
echo %GREEN%✨ Application is running!%RESET%
echo %CYAN%📱 Frontend: http://localhost:5173%RESET%
echo %CYAN%⚙️  Backend: http://localhost:5000%RESET%
echo.
echo %YELLOW%❗ Press Ctrl+C in the respective windows to stop the servers%RESET%

:: Keep the window open
pause 