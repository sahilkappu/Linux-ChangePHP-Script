#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}${BOLD}       Installing Linux ChangePHP Script - Advanced${NC}"
echo -e "${CYAN}================================================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}Please don't run this script as root${NC}"
    echo -e "${YELLOW}Run without sudo, it will ask for password when needed${NC}"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Installing git...${NC}"
    sudo apt update
    sudo apt install git -y
fi

echo -e "${YELLOW}Step 1/5: Checking for script file...${NC}"
if [ -f "changephp.sh" ]; then
    echo -e "${GREEN}✓ Script found: changephp.sh${NC}"
    SCRIPT_FILE="changephp.sh"
else
    echo -e "${RED}✗ changephp.sh not found in current directory${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 2/5: Copying script to /usr/local/bin/changephp...${NC}"
sudo cp "$SCRIPT_FILE" /usr/local/bin/changephp
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Script copied successfully${NC}"
else
    echo -e "${RED}✗ Failed to copy script${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 3/5: Making script executable...${NC}"
sudo chmod +x /usr/local/bin/changephp
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Script is now executable${NC}"
else
    echo -e "${RED}✗ Failed to make script executable${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 4/5: Verifying installation...${NC}"
if command -v changephp &> /dev/null; then
    echo -e "${GREEN}✓ Command 'changephp' is now available${NC}"
else
    echo -e "${RED}✗ Installation verification failed${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 5/5: Checking PHP versions...${NC}"
php_count=$(ls /usr/bin/php[0-9]* 2>/dev/null | wc -l)
if [ "$php_count" -gt 0 ]; then
    echo -e "${GREEN}✓ Found $php_count PHP version(s) installed${NC}"
else
    echo -e "${YELLOW}⚠ No PHP versions detected${NC}"
    echo ""
    echo -e "${CYAN}No problem! You can install PHP versions using the script itself.${NC}"
    echo -e "${CYAN}Just run 'changephp' and press 'a' for advanced menu,${NC}"
    echo -e "${CYAN}then select option 1 to install PHP versions.${NC}"
fi

echo ""
echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}${BOLD}                  Installation Complete!${NC}"
echo -e "${CYAN}================================================================${NC}"
echo ""
echo -e "${GREEN}${BOLD}Usage:${NC}"
echo -e "  ${BOLD}changephp${NC}           - Switch PHP versions (main menu)"
echo -e "  ${BOLD}changephp${NC} then 'a' - Access advanced features"
echo ""
echo -e "${GREEN}${BOLD}Advanced Features:${NC}"
echo -e "  1. Install PHP versions"
echo -e "  2. Install missing PHP-FPM"
echo -e "  3. Show PHP modules for all versions"
echo -e "  4. Sync modules between versions"
echo -e "  5. Service status check"
echo ""
echo -e "${CYAN}Ready to switch PHP versions? Run: ${BOLD}changephp${NC}"
echo ""
