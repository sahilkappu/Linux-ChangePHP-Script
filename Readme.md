# 🐘 Linux ChangePHP Script - Advanced Edition

A powerful, interactive bash script to easily switch between multiple PHP versions on Ubuntu/Debian systems with advanced features for professional developers.

![PHP Version Switcher](https://img.shields.io/badge/PHP-Switcher-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## ✨ Features

### Core Features
- 🔍 **Auto-detects** all installed PHP versions by reading actual `php -v` output
- 🎯 **Interactive TUI menu** with numbered selection and color-coded status
- 🎨 **Beautiful color-coded output** for better visibility and UX
- ⚡ **Quick switching** between PHP versions with zero conflicts
- 🔧 **Updates CLI, Apache, and Nginx** configurations automatically
- 🔄 **Smart service management** - auto-restarts only active services
- 💡 **Shows current active version** with real-time status

### Advanced Features ✨
- ✅ **Fully correct PHP-FPM switching** - Stops old versions, starts new, prevents mixed versions
- ✅ **Apache switching without touching unrelated modules** - Only manages PHP modules
- ✅ **Works even when phpize, phar, or php-config binaries are missing** - Graceful handling
- ✅ **Nginx configuration warnings** - Reminds about fastcgi_pass updates
- ✅ **Multi-environment support** - Works with Apache, Nginx, both, or CLI only
- ✅ **Safe operations** - Prevents breaking the system accidentally
- ✅ **Advanced menu system** with additional utilities:
  - 📦 **Install PHP versions** directly from the script
  - 🔌 **Install missing PHP-FPM** for existing PHP installations
  - 📋 **Show all PHP modules** installed across versions
  - 🔄 **Sync modules between versions** - Copy extensions from one version to another
  - 📊 **Service status check** - See all PHP-FPM, Apache, and Nginx status at a glance

## 🎥 Demo

```
================================================================
              PHP Version Switcher - Advanced
================================================================

System Information:

✓ Apache is installed and running
✓ Nginx is installed and running

Current PHP version: 8.1

Available PHP versions:

  1. PHP 7.4 [FPM: stopped]
  2. PHP 8.1 (current) [FPM: running]
  3. PHP 8.2 [FPM: stopped]
  4. PHP 8.3 [FPM: not installed]

  0. Exit

Select version number (1-4) or 'a' for advanced: 
```

## 📋 Prerequisites

- Ubuntu/Debian-based Linux distribution (18.04+)
- Multiple PHP versions installed (or use built-in installer)
- `sudo` privileges
- Apache or Nginx (optional, for web server PHP switching)

## 🚀 Quick Installation

### Method 1: One-Line Install (Recommended)

```bash
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git && cd Linux-ChangePHP-Script && chmod +x install.sh && ./install.sh
```

### Method 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git

# Navigate to directory
cd Linux-ChangePHP-Script

# Run installer
chmod +x install.sh
./install.sh
```

### Method 3: Direct Installation

```bash
# Clone repository
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
cd Linux-ChangePHP-Script

# Copy script
sudo cp changephp.sh /usr/local/bin/changephp

# Make executable
sudo chmod +x /usr/local/bin/changephp

# Run it
changephp
```

## 💻 Usage

### Basic Usage

Simply run the command:

```bash
changephp
```

### Advanced Features

Press **'a'** in the main menu to access advanced options:

```
Advanced Options:

  1. Install PHP versions
  2. Install missing PHP-FPM
  3. Show PHP modules for all versions
  4. Sync modules between versions
  5. Service status check
  0. Back to main menu
```

### Example Workflows

#### Workflow 1: Install and Switch to PHP 8.3
```bash
changephp
# Press 'a' for advanced menu
# Select '1' to install PHP versions
# Enter: 8.3
# Wait for installation
# Press '0' to go back
# Select PHP 8.3 from main menu
```

#### Workflow 2: Copy Extensions from 8.1 to 8.2
```bash
changephp
# Press 'a' for advanced menu
# Select '4' for sync modules
# Source: 2 (PHP 8.1)
# Target: 3 (PHP 8.2)
# Wait for installation
```

#### Workflow 3: Check Service Status
```bash
changephp
# Press 'a' for advanced menu
# Select '5' for service status
# View all services
```

## 📦 Installing Multiple PHP Versions

### Using Built-in Installer (Recommended)
1. Run `changephp`
2. Press **'a'** for advanced menu
3. Select **'1'** for "Install PHP versions"
4. Enter versions (e.g., `8.1 8.2 8.3`)
5. Wait for automatic installation

### Manual Installation
```bash
# Add Ondřej Surý's PHP repository
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install PHP versions (example: 7.4, 8.1, 8.2, 8.3)
sudo apt install -y php7.4 php7.4-cli php7.4-fpm php7.4-common
sudo apt install -y php8.1 php8.1-cli php8.1-fpm php8.1-common
sudo apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-common
sudo apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-common

# Install common extensions for each version
sudo apt install -y php7.4-{mysql,curl,xml,mbstring,zip,gd,bcmath,intl,soap}
sudo apt install -y php8.1-{mysql,curl,xml,mbstring,zip,gd,bcmath,intl,soap}
sudo apt install -y php8.2-{mysql,curl,xml,mbstring,zip,gd,bcmath,intl,soap}
sudo apt install -y php8.3-{mysql,curl,xml,mbstring,zip,gd,bcmath,intl,soap}
```

## 🔧 What It Does

### Version Switching Process

1. **Detects installed versions** - Scans system for all PHP installations
2. **Shows current status** - Displays active version and FPM status
3. **Stops old PHP-FPM** - Cleanly stops all running PHP-FPM services
4. **Updates CLI alternatives** - Changes default `php` command
5. **Configures Apache** - Switches mod_php (if Apache is used)
6. **Starts new PHP-FPM** - Activates FPM for selected version
7. **Restarts web servers** - Reloads Apache/Nginx if running
8. **Verifies switch** - Confirms new version is active

### Supported Configurations

- ✅ Apache with mod_php
- ✅ Nginx with PHP-FPM
- ✅ Apache + PHP-FPM
- ✅ PHP CLI only
- ✅ Mixed environments (Apache + Nginx)
- ✅ Multiple PHP versions installed
- ✅ Partial installations (missing FPM)

## 🛡️ Safety Features

- 🔒 **Prevents running as root** - Requires sudo only when needed
- 🔒 **Validates all inputs** - Prevents invalid selections
- 🔒 **Graceful error handling** - Won't break existing configuration
- 🔒 **Service state awareness** - Only restarts active services
- 🔒 **Conflict prevention** - Stops old FPM before starting new
- 🔒 **Nginx warnings** - Alerts about manual configuration needs

## 📊 Advanced Features Explained

### 1. Install PHP Versions
Automatically adds the Ondřej Surý repository and installs:
- PHP core packages (cli, common, fpm)
- Essential extensions (mysql, curl, xml, mbstring, zip, gd, bcmath, intl, soap)
- Configures services automatically

### 2. Install Missing PHP-FPM
- Scans for PHP versions without FPM
- Offers to install missing FPM packages
- Enables and starts services

### 3. Show PHP Modules
- Lists all installed modules for each PHP version
- Helps identify missing extensions
- Useful for debugging

### 4. Sync Modules Between Versions
- Copies extensions from one version to another
- Automatically installs missing packages
- Perfect for maintaining consistency

### 5. Service Status Check
- Shows Apache status (running/stopped/not installed)
- Shows Nginx status (running/stopped/not installed)
- Shows PHP-FPM status for all versions
- Real-time service monitoring

## ⚠️ Troubleshooting

### Command not found
```bash
# Check if installed
which changephp

# Reinstall
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
cd Linux-ChangePHP-Script
./install.sh
```

### No PHP versions detected
```bash
# Check installations
dpkg -l | grep php | grep ^ii

# Install PHP via script
changephp
# Press 'a', then '1'
```

### FPM won't start
```bash
# Check FPM service
systemctl status php8.1-fpm

# View logs
journalctl -u php8.1-fpm -n 50

# Reinstall FPM
sudo apt install --reinstall php8.1-fpm
```

### Nginx not switching
The script will show this warning:
```
⚠ IMPORTANT: Check your Nginx configuration!
ℹ Update fastcgi_pass to: unix:/var/run/php/php8.2-fpm.sock
```

Edit your Nginx config:
```bash
sudo nano /etc/nginx/sites-available/default

# Change:
fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;

# Then:
sudo nginx -t
sudo systemctl reload nginx
```

## 🔄 Updating

```bash
cd /tmp
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
cd Linux-ChangePHP-Script
sudo cp changephp.sh /usr/local/bin/changephp
sudo chmod +x /usr/local/bin/changephp
```

## 🗑️ Uninstallation

```bash
sudo rm /usr/local/bin/changephp
```

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Sahil Kappu**
- GitHub: [@sahilkappu](https://github.com/sahilkappu)
- Repository: [Linux-ChangePHP-Script](https://github.com/sahilkappu/Linux-ChangePHP-Script)

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

## 📚 Related Resources

- [PHP Official Website](https://www.php.net/)
- [Ondřej Surý's PHP PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php)
- [PHP Version Support](https://www.php.net/supported-versions.php)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.php)
- [Nginx PHP-FPM Setup](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)

## 🎯 Roadmap

- [ ] Debian package (.deb) installer
- [ ] GUI version using dialog/whiptail
- [ ] Configuration backup/restore
- [ ] PHP.ini synchronization between versions
- [ ] Automatic Nginx config updates
- [ ] Performance testing for each version
- [ ] Docker support

---

Made with ❤️ for the PHP development community
