# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to check Python version
function Test-PythonVersion {
    $pythonVersion = (python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    $major, $minor = $pythonVersion.Split('.')
    
    if ([int]$major -eq 3 -and [int]$minor -ge 12) {
        Write-Host "`n⚠️  Warning: Python $pythonVersion detected." -ForegroundColor Yellow
        Write-Host "   Some packages might have compatibility issues." -ForegroundColor Yellow
        Write-Host "   It's recommended to use Python 3.8-3.11 for better compatibility." -ForegroundColor Yellow
        return $false
    }
    return $true
}

# Function to create and activate Python virtual environment
function Setup-Python {
    Write-Host "`n🐍 Setting up Python environment..." -ForegroundColor Cyan
    
    # Check if Python is installed
    if (-not (Test-Command "python")) {
        Write-Host "❌ Python is not installed. Please install Python 3.8-3.11." -ForegroundColor Red
        exit 1
    }

    # Check Python version
    Test-PythonVersion

    # Create and activate virtual environment
    if (-not (Test-Path "API\venv")) {
        Write-Host "Creating virtual environment..." -ForegroundColor Yellow
        python -m venv API\venv
    }
    
    # Activate virtual environment
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & API\venv\Scripts\Activate.ps1

    # Install base packages first
    Write-Host "Installing base packages..." -ForegroundColor Yellow
    & API\venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install base packages" -ForegroundColor Red
        exit 1
    }

    # Install Python dependencies
    Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
    try {
        pip install --no-cache-dir -r API\requirements.txt
    } catch {
        Write-Host "First installation attempt failed, trying alternative method..." -ForegroundColor Yellow
        pip install flask==3.0.0 flask-cors==4.0.0 numpy==1.24.3 Werkzeug==3.0.1
        pip install opencv-python==4.8.1.78 opencv-contrib-python==4.8.1.78 --no-deps
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Installation failed. Please try using Python 3.8-3.11" -ForegroundColor Red
            exit 1
        }
    }

    Write-Host "✅ Python setup complete!" -ForegroundColor Green
}

# Function to setup Node.js environment
function Setup-Node {
    Write-Host "`n📦 Setting up Node.js environment..." -ForegroundColor Cyan
    
    # Check if Node.js is installed
    if (-not (Test-Command "node")) {
        Write-Host "❌ Node.js is not installed. Please install Node.js 16 or later." -ForegroundColor Red
        exit 1
    }

    # Check Node.js version
    $nodeVersion = (node -v).Replace('v', '')
    if ([version]$nodeVersion -lt [version]"16.0.0") {
        Write-Host "❌ Node.js version must be 16 or later. Current version: $nodeVersion" -ForegroundColor Red
        exit 1
    }

    # Check if pnpm is installed
    if (-not (Test-Command "pnpm")) {
        Write-Host "Installing pnpm globally..." -ForegroundColor Yellow
        npm install -g pnpm
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Failed to install pnpm" -ForegroundColor Red
            exit 1
        }
    }

    # Install frontend dependencies
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    Set-Location "Anime Image Enhancer UI"
    pnpm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install frontend dependencies" -ForegroundColor Red
        Set-Location ..
        exit 1
    }
    Set-Location ..

    Write-Host "✅ Node.js setup complete!" -ForegroundColor Green
}

# Function to start the application
function Start-Application {
    Write-Host "`n🚀 Starting the application..." -ForegroundColor Cyan

    # Create necessary directories
    if (-not (Test-Path "API\uploads")) {
        New-Item -ItemType Directory -Path "API\uploads"
    }
    if (-not (Test-Path "Anime Image Enhancer UI\public\outputs")) {
        New-Item -ItemType Directory -Path "Anime Image Enhancer UI\public\outputs"
    }

    # Start backend in a new window
    Write-Host "Starting backend server..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd API; ..\API\venv\Scripts\Activate.ps1; python api.py"

    # Start frontend in a new window
    Write-Host "Starting frontend server..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd 'Anime Image Enhancer UI'; pnpm dev"

    Write-Host "`n✨ Application is running!" -ForegroundColor Green
    Write-Host "📱 Frontend: http://localhost:5173" -ForegroundColor Cyan
    Write-Host "⚙️  Backend: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "`n❗ Press Ctrl+C in the respective windows to stop the servers" -ForegroundColor Yellow
}

# Main execution
Write-Host "🎮 Anime Image Enhancer Setup" -ForegroundColor Magenta
Write-Host "=============================" -ForegroundColor Magenta

try {
    Setup-Python
    Setup-Node
    Start-Application
} catch {
    Write-Host "`n❌ An error occurred: $_" -ForegroundColor Red
    exit 1
} 