#!/bin/bash

# Color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to detect installed PHP versions
detect_php_versions() {
    versions=()
    
    # Check for PHP versions in /usr/bin
    for php in /usr/bin/php[0-9]*; do
        if [ -x "$php" ]; then
            version=$(basename "$php" | grep -oP '\d+\.\d+')
            if [ ! -z "$version" ]; then
                versions+=("$version")
            fi
        fi
    done
    
    # Remove duplicates and sort
    versions=($(printf '%s\n' "${versions[@]}" | sort -V -u))
    
    echo "${versions[@]}"
}

# Function to get current PHP version
get_current_version() {
    if command -v php &> /dev/null; then
        php -v | head -n 1 | grep -oP 'PHP \K[0-9]+\.[0-9]+'
    else
        echo "None"
    fi
}

# Function to switch PHP version
switch_php_version() {
    local version=$1
    
    echo -e "${YELLOW}Switching to PHP ${version}...${NC}"
    
    # Disable all PHP versions for Apache
    sudo a2dismod php* 2>/dev/null
    
    # Enable selected PHP version for Apache
    if [ -f "/etc/apache2/mods-available/php${version}.load" ]; then
        sudo a2enmod php${version}
        echo -e "${GREEN}✓ Apache module enabled for PHP ${version}${NC}"
    fi
    
    # Update alternatives for CLI
    if [ -f "/usr/bin/php${version}" ]; then
        sudo update-alternatives --set php "/usr/bin/php${version}"
        sudo update-alternatives --set phar "/usr/bin/phar${version}" 2>/dev/null
        sudo update-alternatives --set phar.phar "/usr/bin/phar.phar${version}" 2>/dev/null
        sudo update-alternatives --set phpize "/usr/bin/phpize${version}" 2>/dev/null
        sudo update-alternatives --set php-config "/usr/bin/php-config${version}" 2>/dev/null
        echo -e "${GREEN}✓ CLI version set to PHP ${version}${NC}"
    fi
    
    # Restart Apache if it's running
    if systemctl is-active --quiet apache2; then
        sudo systemctl restart apache2
        echo -e "${GREEN}✓ Apache restarted${NC}"
    fi
    
    # Restart Nginx and PHP-FPM if they're running
    if systemctl is-active --quiet nginx; then
        sudo systemctl restart php${version}-fpm 2>/dev/null
        sudo systemctl restart nginx
        echo -e "${GREEN}✓ Nginx and PHP-FPM restarted${NC}"
    fi
    
    echo -e "${GREEN}✓ PHP ${version} is now active!${NC}"
    echo ""
    php -v | head -n 1
}

# Main script
clear
echo "================================================"
echo "         PHP Version Switcher"
echo "================================================"
echo ""

# Detect installed PHP versions
available_versions=($(detect_php_versions))

if [ ${#available_versions[@]} -eq 0 ]; then
    echo -e "${RED}No PHP versions found!${NC}"
    echo "Please install PHP first."
    exit 1
fi

# Display current version
current_version=$(get_current_version)
echo -e "Current PHP version: ${GREEN}${current_version}${NC}"
echo ""

# Display available versions
echo "Available PHP versions:"
echo ""
for i in "${!available_versions[@]}"; do
    version="${available_versions[$i]}"
    marker=""
    if [ "$version" == "$current_version" ]; then
        marker=" ${GREEN}(current)${NC}"
    fi
    echo -e "  $((i+1)). PHP ${version}${marker}"
done

echo ""
echo -n "Select version number (1-${#available_versions[@]}): "
read choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#available_versions[@]} ]; then
    echo -e "${RED}Invalid selection!${NC}"
    exit 1
fi

# Get selected version
selected_version="${available_versions[$((choice-1))]}"

# Check if it's already the current version
if [ "$selected_version" == "$current_version" ]; then
    echo -e "${YELLOW}PHP ${selected_version} is already active!${NC}"
    exit 0
fi

# Switch to selected version
echo ""
switch_php_version "$selected_version"