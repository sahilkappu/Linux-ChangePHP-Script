#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  Installing Linux ChangePHP Script${NC}"
echo -e "${GREEN}================================================${NC}"
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

echo -e "${YELLOW}Step 1/4: Copying script file...${NC}"
if [ -f "changephp.sh" ]; then
    sudo cp changephp.sh /usr/local/bin/changephp
    echo -e "${GREEN}✓ Script copied to /usr/local/bin/changephp${NC}"
else
    echo -e "${RED}✗ changephp.sh not found in current directory${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 2/4: Making script executable...${NC}"
sudo chmod +x /usr/local/bin/changephp
echo -e "${GREEN}✓ Script is now executable${NC}"

echo -e "${YELLOW}Step 3/4: Verifying installation...${NC}"
if command -v changephp &> /dev/null; then
    echo -e "${GREEN}✓ Command 'changephp' is now available${NC}"
else
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 4/4: Checking PHP versions...${NC}"
php_count=$(ls /usr/bin/php[0-9]* 2>/dev/null | wc -l)
if [ "$php_count" -gt 0 ]; then
    echo -e "${GREEN}✓ Found $php_count PHP version(s) installed${NC}"
else
    echo -e "${YELLOW}⚠ No PHP versions detected${NC}"
    echo -e "${YELLOW}You may need to install PHP first${NC}"
    echo ""
    echo "To install multiple PHP versions, run:"
    echo "  sudo add-apt-repository ppa:ondrej/php -y"
    echo "  sudo apt update"
    echo "  sudo apt install php7.4 php8.1 php8.2 php8.3"
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "Run 'changephp' to switch PHP versions"
echo ""
