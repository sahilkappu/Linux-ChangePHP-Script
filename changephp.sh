#!/bin/bash

# =============================================================================
# Linux ChangePHP Script - Advanced Version
# Author: Sahil Kappu
# Repository: https://github.com/sahilkappu/Linux-ChangePHP-Script
# =============================================================================

# Color codes for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

print_header() {
    clear
    echo -e "${CYAN}================================================================${NC}"
    echo -e "${CYAN}${BOLD}              PHP Version Switcher - Advanced${NC}"
    echo -e "${CYAN}================================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# =============================================================================
# PHP VERSION DETECTION
# =============================================================================

detect_php_versions() {
    local versions=()
    
    # Method 1: Check /usr/bin for phpX.Y binaries
    for php in /usr/bin/php[0-9]*; do
        if [ -x "$php" ] && [ ! -L "$php" ]; then
            version=$("$php" -v 2>/dev/null | head -n 1 | grep -oP 'PHP \K[0-9]+\.[0-9]+')
            if [ ! -z "$version" ]; then
                versions+=("$version")
            fi
        fi
    done
    
    # Method 2: Check installed PHP packages
    while IFS= read -r pkg; do
        version=$(echo "$pkg" | grep -oP 'php\K[0-9]+\.[0-9]+')
        if [ ! -z "$version" ] && [ -x "/usr/bin/php${version}" ]; then
            versions+=("$version")
        fi
    done < <(dpkg -l | grep -E '^ii.*php[0-9]+\.[0-9]+-common' | awk '{print $2}')
    
    # Remove duplicates and sort
    versions=($(printf '%s\n' "${versions[@]}" | sort -V -u))
    
    echo "${versions[@]}"
}

get_current_version() {
    if command -v php &> /dev/null; then
        php -v 2>/dev/null | head -n 1 | grep -oP 'PHP \K[0-9]+\.[0-9]+'
    else
        echo "None"
    fi
}

check_fpm_installed() {
    local version=$1
    systemctl list-unit-files | grep -q "php${version}-fpm.service"
    return $?
}

check_apache_installed() {
    command -v apache2 &> /dev/null || systemctl list-unit-files | grep -q "apache2.service"
    return $?
}

check_nginx_installed() {
    command -v nginx &> /dev/null || systemctl list-unit-files | grep -q "nginx.service"
    return $?
}

# =============================================================================
# PHP-FPM MANAGEMENT
# =============================================================================

stop_all_fpm() {
    echo -e "${YELLOW}Stopping all PHP-FPM services...${NC}"
    local stopped=0
    
    for service in $(systemctl list-units --type=service --all | grep -oP 'php[0-9]+\.[0-9]+-fpm'); do
        if systemctl is-active --quiet "$service"; then
            sudo systemctl stop "$service" 2>/dev/null
            if [ $? -eq 0 ]; then
                print_success "Stopped $service"
                ((stopped++))
            fi
        fi
    done
    
    if [ $stopped -eq 0 ]; then
        print_info "No PHP-FPM services were running"
    fi
    
    return 0
}

start_fpm() {
    local version=$1
    local service="php${version}-fpm"
    
    if ! check_fpm_installed "$version"; then
        print_warning "PHP-FPM $version is not installed"
        return 1
    fi
    
    sudo systemctl start "$service" 2>/dev/null
    if [ $? -eq 0 ]; then
        sudo systemctl enable "$service" 2>/dev/null
        print_success "Started and enabled $service"
        return 0
    else
        print_error "Failed to start $service"
        return 1
    fi
}

# =============================================================================
# APACHE MANAGEMENT
# =============================================================================

switch_apache_module() {
    local version=$1
    
    if ! check_apache_installed; then
        return 0
    fi
    
    echo -e "${YELLOW}Configuring Apache...${NC}"
    
    # Disable all PHP modules (only PHP-related ones)
    for mod in $(apache2ctl -M 2>/dev/null | grep -oP 'php[0-9]+_module' | sed 's/_module//'); do
        sudo a2dismod "$mod" 2>/dev/null
    done
    
    # Enable the selected version
    if [ -f "/etc/apache2/mods-available/php${version}.load" ]; then
        sudo a2enmod "php${version}" 2>/dev/null
        if [ $? -eq 0 ]; then
            print_success "Apache module php${version} enabled"
        else
            print_warning "Could not enable Apache module php${version}"
        fi
    else
        print_info "Apache module for PHP ${version} not found (may use PHP-FPM instead)"
    fi
    
    return 0
}

restart_apache() {
    if check_apache_installed && systemctl is-active --quiet apache2; then
        echo -e "${YELLOW}Restarting Apache...${NC}"
        sudo systemctl restart apache2
        if [ $? -eq 0 ]; then
            print_success "Apache restarted successfully"
        else
            print_error "Failed to restart Apache"
        fi
    fi
}

# =============================================================================
# NGINX MANAGEMENT
# =============================================================================

restart_nginx() {
    if check_nginx_installed && systemctl is-active --quiet nginx; then
        echo -e "${YELLOW}Restarting Nginx...${NC}"
        sudo systemctl restart nginx
        if [ $? -eq 0 ]; then
            print_success "Nginx restarted successfully"
            check_nginx_config
        else
            print_error "Failed to restart Nginx"
        fi
    fi
}

check_nginx_config() {
    local version=$1
    
    if ! check_nginx_installed; then
        return 0
    fi
    
    echo ""
    print_warning "IMPORTANT: Check your Nginx configuration!"
    print_info "Update fastcgi_pass to: unix:/var/run/php/php${version}-fpm.sock"
    print_info "Or: fastcgi_pass 127.0.0.1:90${version/./}"
    echo ""
}

# =============================================================================
# CLI ALTERNATIVES MANAGEMENT
# =============================================================================

update_cli_alternatives() {
    local version=$1
    
    echo -e "${YELLOW}Updating CLI alternatives...${NC}"
    
    # Update php
    if [ -f "/usr/bin/php${version}" ]; then
        sudo update-alternatives --set php "/usr/bin/php${version}" 2>/dev/null
        print_success "CLI php set to ${version}"
    fi
    
    # Update optional binaries (don't fail if missing)
    local optional_bins=("phar" "phar.phar" "phpize" "php-config" "phpdbg")
    
    for bin in "${optional_bins[@]}"; do
        if [ -f "/usr/bin/${bin}${version}" ]; then
            sudo update-alternatives --set "$bin" "/usr/bin/${bin}${version}" 2>/dev/null
        fi
    done
    
    return 0
}

# =============================================================================
# MAIN SWITCH FUNCTION
# =============================================================================

switch_php_version() {
    local version=$1
    
    echo ""
    echo -e "${CYAN}${BOLD}Switching to PHP ${version}...${NC}"
    echo ""
    
    # Step 1: Stop all PHP-FPM services
    stop_all_fpm
    echo ""
    
    # Step 2: Update CLI alternatives
    update_cli_alternatives "$version"
    echo ""
    
    # Step 3: Configure Apache if installed
    switch_apache_module "$version"
    echo ""
    
    # Step 4: Start the new PHP-FPM version
    if check_fpm_installed "$version"; then
        start_fpm "$version"
        echo ""
    fi
    
    # Step 5: Restart web servers
    restart_apache
    restart_nginx
    
    # Step 6: Show Nginx warning if applicable
    if check_nginx_installed; then
        check_nginx_config "$version"
    fi
    
    # Step 7: Verify the switch
    echo -e "${GREEN}${BOLD}✓ PHP ${version} is now active!${NC}"
    echo ""
    echo -e "${CYAN}Current PHP version:${NC}"
    php -v | head -n 1
    echo ""
}

# =============================================================================
# SYSTEM INFORMATION
# =============================================================================

show_system_info() {
    echo -e "${CYAN}${BOLD}System Information:${NC}"
    echo ""
    
    # Check web servers
    if check_apache_installed; then
        if systemctl is-active --quiet apache2; then
            print_success "Apache is installed and running"
        else
            print_info "Apache is installed but not running"
        fi
    fi
    
    if check_nginx_installed; then
        if systemctl is-active --quiet nginx; then
            print_success "Nginx is installed and running"
        else
            print_info "Nginx is installed but not running"
        fi
    fi
    
    echo ""
}

# =============================================================================
# INTERACTIVE MENU
# =============================================================================

show_menu() {
    local versions=("$@")
    local current_version=$(get_current_version)
    
    print_header
    show_system_info
    
    echo -e "${CYAN}Current PHP version: ${GREEN}${BOLD}${current_version}${NC}"
    echo ""
    echo -e "${CYAN}${BOLD}Available PHP versions:${NC}"
    echo ""
    
    for i in "${!versions[@]}"; do
        local version="${versions[$i]}"
        local marker=""
        local fpm_status=""
        
        if [ "$version" == "$current_version" ]; then
            marker=" ${GREEN}${BOLD}(current)${NC}"
        fi
        
        if check_fpm_installed "$version"; then
            if systemctl is-active --quiet "php${version}-fpm"; then
                fpm_status=" ${GREEN}[FPM: running]${NC}"
            else
                fpm_status=" ${YELLOW}[FPM: stopped]${NC}"
            fi
        else
            fpm_status=" ${RED}[FPM: not installed]${NC}"
        fi
        
        echo -e "  ${BOLD}$((i+1)).${NC} PHP ${version}${marker}${fpm_status}"
    done
    
    echo ""
    echo -e "  ${BOLD}0.${NC} ${RED}Exit${NC}"
    echo ""
}

# =============================================================================
# ADDITIONAL FEATURES MENU
# =============================================================================

show_advanced_menu() {
    while true; do
        print_header
        echo -e "${CYAN}${BOLD}Advanced Options:${NC}"
        echo ""
        echo -e "  ${BOLD}1.${NC} Install PHP versions"
        echo -e "  ${BOLD}2.${NC} Install missing PHP-FPM"
        echo -e "  ${BOLD}3.${NC} Show PHP modules for all versions"
        echo -e "  ${BOLD}4.${NC} Sync modules between versions"
        echo -e "  ${BOLD}5.${NC} Service status check"
        echo -e "  ${BOLD}0.${NC} ${RED}Back to main menu${NC}"
        echo ""
        echo -n "Select option: "
        read choice
        
        case $choice in
            1) install_php_versions ;;
            2) install_missing_fpm ;;
            3) show_all_modules ;;
            4) sync_modules ;;
            5) check_services ;;
            0) return ;;
            *) print_error "Invalid option" ; sleep 2 ;;
        esac
    done
}

# =============================================================================
# INSTALL PHP VERSIONS
# =============================================================================

install_php_versions() {
    print_header
    echo -e "${CYAN}${BOLD}Install PHP Versions${NC}"
    echo ""
    
    print_info "Available PHP versions: 7.4, 8.0, 8.1, 8.2, 8.3, 8.4"
    echo ""
    echo -n "Enter versions to install (space-separated, e.g., 8.1 8.2 8.3): "
    read -a versions_to_install
    
    if [ ${#versions_to_install[@]} -eq 0 ]; then
        print_error "No versions specified"
        sleep 2
        return
    fi
    
    echo ""
    print_info "Adding ondrej/php repository..."
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    
    for version in "${versions_to_install[@]}"; do
        echo ""
        echo -e "${YELLOW}Installing PHP ${version}...${NC}"
        
        # Install base packages
        sudo apt install -y \
            php${version} \
            php${version}-cli \
            php${version}-common \
            php${version}-fpm
        
        # Install common extensions
        echo -e "${YELLOW}Installing common extensions...${NC}"
        sudo apt install -y \
            php${version}-mysql \
            php${version}-curl \
            php${version}-xml \
            php${version}-mbstring \
            php${version}-zip \
            php${version}-gd \
            php${version}-bcmath \
            php${version}-intl \
            php${version}-soap \
            php${version}-opcache
        
        print_success "PHP ${version} installed successfully"
    done
    
    echo ""
    print_success "Installation complete!"
    echo ""
    read -p "Press Enter to continue..."
}

# =============================================================================
# INSTALL MISSING PHP-FPM
# =============================================================================

install_missing_fpm() {
    print_header
    echo -e "${CYAN}${BOLD}Install Missing PHP-FPM${NC}"
    echo ""
    
    local versions=($(detect_php_versions))
    local missing=()
    
    for version in "${versions[@]}"; do
        if ! check_fpm_installed "$version"; then
            missing+=("$version")
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        print_success "All installed PHP versions have PHP-FPM"
        echo ""
        read -p "Press Enter to continue..."
        return
    fi
    
    echo -e "${YELLOW}Missing PHP-FPM for versions:${NC}"
    for version in "${missing[@]}"; do
        echo "  - PHP $version"
    done
    echo ""
    
    read -p "Install missing PHP-FPM? (y/n): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        return
    fi
    
    for version in "${missing[@]}"; do
        echo ""
        echo -e "${YELLOW}Installing PHP-FPM ${version}...${NC}"
        sudo apt install -y php${version}-fpm
        print_success "PHP-FPM ${version} installed"
    done
    
    echo ""
    read -p "Press Enter to continue..."
}

# =============================================================================
# SHOW ALL MODULES
# =============================================================================

show_all_modules() {
    print_header
    echo -e "${CYAN}${BOLD}Installed PHP Modules${NC}"
    echo ""
    
    local versions=($(detect_php_versions))
    
    for version in "${versions[@]}"; do
        echo -e "${CYAN}PHP ${version} modules:${NC}"
        /usr/bin/php${version} -m 2>/dev/null | grep -v "^\[" | sort | sed 's/^/  /'
        echo ""
    done
    
    read -p "Press Enter to continue..."
}

# =============================================================================
# SYNC MODULES
# =============================================================================

sync_modules() {
    print_header
    echo -e "${CYAN}${BOLD}Sync PHP Modules${NC}"
    echo ""
    
    local versions=($(detect_php_versions))
    
    echo "Available PHP versions:"
    for i in "${!versions[@]}"; do
        echo "  $((i+1)). PHP ${versions[$i]}"
    done
    echo ""
    
    echo -n "Source version number: "
    read source_idx
    echo -n "Target version number: "
    read target_idx
    
    if ! [[ "$source_idx" =~ ^[0-9]+$ ]] || ! [[ "$target_idx" =~ ^[0-9]+$ ]]; then
        print_error "Invalid selection"
        sleep 2
        return
    fi
    
    local source_version="${versions[$((source_idx-1))]}"
    local target_version="${versions[$((target_idx-1))]}"
    
    if [ -z "$source_version" ] || [ -z "$target_version" ]; then
        print_error "Invalid version selection"
        sleep 2
        return
    fi
    
    echo ""
    echo -e "${YELLOW}Getting modules from PHP ${source_version}...${NC}"
    
    # Get list of modules
    local modules=()
    while IFS= read -r module; do
        modules+=("$module")
    done < <(/usr/bin/php${source_version} -m 2>/dev/null | grep -v "^\[" | sort)
    
    echo ""
    echo -e "${YELLOW}Installing missing modules for PHP ${target_version}...${NC}"
    
    for module in "${modules[@]}"; do
        # Convert module name to package name
        local pkg="php${target_version}-${module,,}"
        
        # Check if package exists and is not installed
        if apt-cache show "$pkg" &>/dev/null; then
            if ! dpkg -l | grep -q "^ii.*$pkg"; then
                echo "Installing $pkg..."
                sudo apt install -y "$pkg" 2>/dev/null
            fi
        fi
    done
    
    echo ""
    print_success "Module sync complete"
    echo ""
    read -p "Press Enter to continue..."
}

# =============================================================================
# CHECK SERVICES
# =============================================================================

check_services() {
    print_header
    echo -e "${CYAN}${BOLD}Service Status${NC}"
    echo ""
    
    # Check Apache
    if check_apache_installed; then
        if systemctl is-active --quiet apache2; then
            print_success "Apache: Running"
        else
            print_warning "Apache: Stopped"
        fi
    else
        print_info "Apache: Not installed"
    fi
    
    # Check Nginx
    if check_nginx_installed; then
        if systemctl is-active --quiet nginx; then
            print_success "Nginx: Running"
        else
            print_warning "Nginx: Stopped"
        fi
    else
        print_info "Nginx: Not installed"
    fi
    
    echo ""
    echo -e "${CYAN}${BOLD}PHP-FPM Services:${NC}"
    echo ""
    
    local versions=($(detect_php_versions))
    for version in "${versions[@]}"; do
        if check_fpm_installed "$version"; then
            if systemctl is-active --quiet "php${version}-fpm"; then
                print_success "PHP ${version} FPM: Running"
            else
                print_warning "PHP ${version} FPM: Stopped"
            fi
        else
            print_info "PHP ${version} FPM: Not installed"
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
}

# =============================================================================
# MAIN SCRIPT
# =============================================================================

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then 
        print_error "Please don't run this script as root"
        print_info "Run without sudo, it will ask for password when needed"
        exit 1
    fi
    
    while true; do
        # Detect installed PHP versions
        available_versions=($(detect_php_versions))
        
        if [ ${#available_versions[@]} -eq 0 ]; then
            print_header
            print_error "No PHP versions found!"
            echo ""
            print_info "Would you like to install PHP now? (y/n): "
            read install_now
            if [[ $install_now =~ ^[Yy]$ ]]; then
                install_php_versions
                continue
            else
                exit 1
            fi
        fi
        
        # Show menu
        show_menu "${available_versions[@]}"
        
        echo -ne "${BOLD}Select version number (1-${#available_versions[@]}) or 'a' for advanced: ${NC}"
        read choice
        
        # Handle advanced menu
        if [[ $choice == "a" ]] || [[ $choice == "A" ]]; then
            show_advanced_menu
            continue
        fi
        
        # Handle exit
        if [ "$choice" == "0" ]; then
            echo ""
            print_info "Goodbye!"
            exit 0
        fi
        
        # Validate input
        if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#available_versions[@]} ]; then
            print_error "Invalid selection!"
            sleep 2
            continue
        fi
        
        # Get selected version
        selected_version="${available_versions[$((choice-1))]}"
        current_version=$(get_current_version)
        
        # Check if it's already the current version
        if [ "$selected_version" == "$current_version" ]; then
            print_warning "PHP ${selected_version} is already active!"
            sleep 2
            continue
        fi
        
        # Switch to selected version
        switch_php_version "$selected_version"
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run main function
main