#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Python version
check_python_version() {
    local python_version
    python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    IFS='.' read -r major minor <<< "$python_version"
    
    if [ "$major" -eq 3 ] && [ "$minor" -ge 12 ]; then
        echo -e "${YELLOW}⚠️  Warning: Python ${python_version} detected.${NC}"
        echo -e "${YELLOW}   Some packages might have compatibility issues.${NC}"
        echo -e "${YELLOW}   It's recommended to use Python 3.8-3.11 for better compatibility.${NC}"
        return 1
    fi
    return 0
}

# Function to check Node.js version
check_node_version() {
    local node_version
    node_version=$(node -v | cut -d'v' -f2)
    IFS='.' read -r major minor patch <<< "$node_version"
    
    if [ "$major" -lt 16 ]; then
        echo -e "${RED}❌ Node.js version must be 16 or later. Current version: ${node_version}${NC}"
        return 1
    fi
    return 0
}

# Function to setup Python environment
setup_python() {
    echo -e "\n${CYAN}🐍 Setting up Python environment...${NC}"
    
    # Check if Python is installed
    if ! command_exists python3; then
        echo -e "${RED}❌ Python is not installed. Please install Python 3.8-3.11.${NC}"
        exit 1
    fi

    # Check Python version
    check_python_version

    # Create and activate virtual environment
    if [ ! -d "API/venv" ]; then
        echo -e "${YELLOW}Creating virtual environment...${NC}"
        python3 -m venv API/venv || {
            echo -e "${RED}❌ Failed to create virtual environment${NC}"
            exit 1
        }
    fi
    
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    source API/venv/bin/activate || {
        echo -e "${RED}❌ Failed to activate virtual environment${NC}"
        exit 1
    }

    # Install base packages first
    echo -e "${YELLOW}Installing base packages...${NC}"
    API/venv/bin/python -m pip install --upgrade pip setuptools wheel || {
        echo -e "${RED}❌ Failed to install base packages${NC}"
        exit 1
    }

    # Install Python dependencies
    echo -e "${YELLOW}Installing Python dependencies...${NC}"
    if ! pip install --no-cache-dir -r API/requirements.txt; then
        echo -e "${YELLOW}First installation attempt failed, trying alternative method...${NC}"
        pip install flask==3.0.0 flask-cors==4.0.0 numpy==1.24.3 Werkzeug==3.0.1 || {
            echo -e "${RED}❌ Failed to install base dependencies${NC}"
            exit 1
        }
        pip install opencv-python==4.8.1.78 opencv-contrib-python==4.8.1.78 --no-deps || {
            echo -e "${RED}❌ Failed to install OpenCV. Please try using Python 3.8-3.11${NC}"
            exit 1
        }
    fi

    echo -e "${GREEN}✅ Python setup complete!${NC}"
}

# Function to setup Node.js environment
setup_node() {
    echo -e "\n${CYAN}📦 Setting up Node.js environment...${NC}"
    
    # Check if Node.js is installed
    if ! command_exists node; then
        echo -e "${RED}❌ Node.js is not installed. Please install Node.js 16 or later.${NC}"
        exit 1
    fi

    # Check Node.js version
    check_node_version || exit 1

    # Check if pnpm is installed
    if ! command_exists pnpm; then
        echo -e "${YELLOW}Installing pnpm globally...${NC}"
        npm install -g pnpm || {
            echo -e "${RED}❌ Failed to install pnpm${NC}"
            exit 1
        }
    fi

    # Install frontend dependencies
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    cd "Anime Image Enhancer UI" || {
        echo -e "${RED}❌ Failed to enter frontend directory${NC}"
        exit 1
    }
    pnpm install || {
        echo -e "${RED}❌ Failed to install frontend dependencies${NC}"
        cd ..
        exit 1
    }
    cd ..

    echo -e "${GREEN}✅ Node.js setup complete!${NC}"
}

# Function to start the application
start_application() {
    echo -e "\n${CYAN}🚀 Setting up project directories...${NC}"

    # Create necessary directories
    mkdir -p API/uploads
    mkdir -p "Anime Image Enhancer UI/public/outputs"

    # Function to get the default terminal
    get_terminal() {
        if command_exists gnome-terminal; then
            echo "gnome-terminal"
        elif command_exists konsole; then
            echo "konsole"
        elif command_exists xterm; then
            echo "xterm"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "terminal"
        else
            echo ""
        fi
    }

    TERMINAL=$(get_terminal)

    # Start backend
    echo -e "${YELLOW}Starting backend server...${NC}"
    case $TERMINAL in
        "gnome-terminal")
            gnome-terminal -- bash -c "cd API && source venv/bin/activate && python api.py"
            ;;
        "konsole")
            konsole -e bash -c "cd API && source venv/bin/activate && python api.py" &
            ;;
        "xterm")
            xterm -T "Backend Server" -e "cd API && source venv/bin/activate && python api.py" &
            ;;
        "terminal")
            osascript -e 'tell app "Terminal" to do script "cd \"$PWD/API\" && source venv/bin/activate && python api.py"'
            ;;
        *)
            echo -e "${RED}❌ No supported terminal emulator found. Please start the backend manually:${NC}"
            echo -e "cd API && source venv/bin/activate && python api.py"
            ;;
    esac

    # Start frontend
    echo -e "${YELLOW}Starting frontend server...${NC}"
    case $TERMINAL in
        "gnome-terminal")
            gnome-terminal -- bash -c "cd 'Anime Image Enhancer UI' && pnpm dev"
            ;;
        "konsole")
            konsole -e bash -c "cd 'Anime Image Enhancer UI' && pnpm dev" &
            ;;
        "xterm")
            xterm -T "Frontend Server" -e "cd 'Anime Image Enhancer UI' && pnpm dev" &
            ;;
        "terminal")
            osascript -e 'tell app "Terminal" to do script "cd \"$PWD/Anime Image Enhancer UI\" && pnpm dev"'
            ;;
        *)
            echo -e "${RED}❌ No supported terminal emulator found. Please start the frontend manually:${NC}"
            echo -e "cd 'Anime Image Enhancer UI' && pnpm dev"
            ;;
    esac

    echo -e "\n${GREEN}✨ Application is running!${NC}"
    echo -e "${CYAN}📱 Frontend: http://localhost:5173${NC}"
    echo -e "${CYAN}⚙️  Backend: http://localhost:5000${NC}"
    echo -e "\n${YELLOW}❗ Press Ctrl+C in the respective terminals to stop the servers${NC}"
}

# Main execution
echo -e "${MAGENTA}🎮 Anime Image Enhancer Setup${NC}"
echo -e "${MAGENTA}=============================${NC}"

# Execute setup
trap 'echo -e "\n${RED}❌ Setup interrupted${NC}"; exit 1' INT
setup_python
setup_node
start_application 