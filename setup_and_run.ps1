# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to create and activate Python virtual environment
function Setup-Python {
    Write-Host "`n🐍 Setting up Python environment..." -ForegroundColor Cyan
    
    # Check if Python is installed
    if (-not (Test-Command "python")) {
        Write-Host "❌ Python is not installed. Please install Python 3.8 or later." -ForegroundColor Red
        exit 1
    }

    # Create and activate virtual environment
    if (-not (Test-Path "API\venv")) {
        Write-Host "Creating virtual environment..." -ForegroundColor Yellow
        python -m venv API\venv
    }
    
    # Activate virtual environment
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & API\venv\Scripts\Activate.ps1

    # Install Python dependencies
    Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
    pip install -r API\requirements.txt

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

    # Check if pnpm is installed
    if (-not (Test-Command "pnpm")) {
        Write-Host "Installing pnpm globally..." -ForegroundColor Yellow
        npm install -g pnpm
    }

    # Install frontend dependencies
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    Set-Location "Anime Image Enhancer UI"
    pnpm install
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