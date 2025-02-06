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

# Function to setup Python environment
setup_python() {
    echo -e "\n${CYAN}🐍 Setting up Python environment...${NC}"
    
    # Check if Python is installed
    if ! command_exists python3; then
        echo -e "${RED}❌ Python is not installed. Please install Python 3.8 or later.${NC}"
        exit 1
    fi

    # Create and activate virtual environment
    if [ ! -d "API/venv" ]; then
        echo -e "${YELLOW}Creating virtual environment...${NC}"
        python3 -m venv API/venv
    fi
    
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    source API/venv/bin/activate

    # Install Python dependencies
    echo -e "${YELLOW}Installing Python dependencies...${NC}"
    pip install -r API/requirements.txt

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

    # Check if pnpm is installed
    if ! command_exists pnpm; then
        echo -e "${YELLOW}Installing pnpm globally...${NC}"
        npm install -g pnpm
    fi

    # Install frontend dependencies
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    cd "Anime Image Enhancer UI"
    pnpm install
    cd ..

    echo -e "${GREEN}✅ Node.js setup complete!${NC}"
}

# Function to start the application
start_application() {
    echo -e "\n${CYAN}🚀 Starting the application...${NC}"

    # Create necessary directories
    mkdir -p API/uploads
    mkdir -p "Anime Image Enhancer UI/public/outputs"

    # Start backend
    echo -e "${YELLOW}Starting backend server...${NC}"
    gnome-terminal --title="Backend Server" -- bash -c "cd API && source venv/bin/activate && python api.py" 2>/dev/null || \
    osascript -e 'tell app "Terminal" to do script "cd \"$PWD/API\" && source venv/bin/activate && python api.py"' 2>/dev/null || \
    xterm -T "Backend Server" -e "cd API && source venv/bin/activate && python api.py" 2>/dev/null || \
    konsole --new-tab -e "cd API && source venv/bin/activate && python api.py" 2>/dev/null || \
    (echo -e "${RED}❌ No supported terminal emulator found. Please start the backend manually:${NC}" && \
     echo -e "cd API && source venv/bin/activate && python api.py")

    # Start frontend
    echo -e "${YELLOW}Starting frontend server...${NC}"
    gnome-terminal --title="Frontend Server" -- bash -c "cd 'Anime Image Enhancer UI' && pnpm dev" 2>/dev/null || \
    osascript -e 'tell app "Terminal" to do script "cd \"$PWD/Anime Image Enhancer UI\" && pnpm dev"' 2>/dev/null || \
    xterm -T "Frontend Server" -e "cd 'Anime Image Enhancer UI' && pnpm dev" 2>/dev/null || \
    konsole --new-tab -e "cd 'Anime Image Enhancer UI' && pnpm dev" 2>/dev/null || \
    (echo -e "${RED}❌ No supported terminal emulator found. Please start the frontend manually:${NC}" && \
     echo -e "cd 'Anime Image Enhancer UI' && pnpm dev")

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