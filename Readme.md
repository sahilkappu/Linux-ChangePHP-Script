# 🐘 Linux ChangePHP Script

A simple, interactive bash script to easily switch between multiple PHP versions on Ubuntu/Debian systems.

![PHP Version Switcher](https://img.shields.io/badge/PHP-Switcher-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## ✨ Features

- 🔍 **Auto-detects** all installed PHP versions
- 🎯 **Interactive menu** with numbered selection
- 🎨 **Color-coded output** for better visibility
- ⚡ **Quick switching** between PHP versions
- 🔧 **Updates both CLI and web server** configurations
- 🔄 **Auto-restarts services** (Apache/Nginx/PHP-FPM)
- 💡 **Shows current active version**

## 📋 Prerequisites

- Ubuntu/Debian-based Linux distribution
- Multiple PHP versions installed
- `sudo` privileges
- Apache or Nginx (optional, for web server PHP switching)

## 🚀 Quick Installation

### Method 1: One-Line Install (Recommended)

```bash
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git && cd Linux-ChangePHP-Script && chmod +x changephp.sh && sudo cp changephp.sh /usr/local/bin/changephp && cd .. && rm -rf Linux-ChangePHP-Script && changephp
```

### Method 2: Step-by-Step Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
   ```

2. **Navigate to the directory:**

   ```bash
   cd Linux-ChangePHP-Script
   ```

3. **Make it executable:**

   ```bash
   chmod +x changephp.sh
   ```

4. **Copy to system bin:**

   ```bash
   sudo cp changephp.sh /usr/local/bin/changephp
   ```

5. **Clean up (optional):**

   ```bash
   cd ..
   rm -rf Linux-ChangePHP-Script
   ```

6. **Run the command:**
   ```bash
   changephp
   ```

### Method 3: Direct Download (if wget works)

```bash
# Download directly
wget https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh

# Or using curl
curl -o changephp.sh https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh

# Make executable and install
chmod +x changephp.sh
sudo mv changephp.sh /usr/local/bin/changephp
```

## 📦 Installing Multiple PHP Versions

If you don't have multiple PHP versions installed yet, use these commands:

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
sudo apt install -y php7.4-{mysql,curl,xml,mbstring,zip,gd,bcmath}
sudo apt install -y php8.1-{mysql,curl,xml,mbstring,zip,gd,bcmath}
sudo apt install -y php8.2-{mysql,curl,xml,mbstring,zip,gd,bcmath}
sudo apt install -y php8.3-{mysql,curl,xml,mbstring,zip,gd,bcmath}
```

## 💻 Usage

Simply run the command:

```bash
changephp
```

### Example Output

```
================================================
         PHP Version Switcher
================================================

Current PHP version: 8.1

Available PHP versions:

  1. PHP 7.4
  2. PHP 8.1 (current)
  3. PHP 8.2
  4. PHP 8.3

Select version number (1-4): 3

Switching to PHP 8.2...
✓ Apache module enabled for PHP 8.2
✓ CLI version set to PHP 8.2
✓ Apache restarted
✓ PHP 8.2 is now active!

PHP 8.2.15 (cli) (built: Jan 20 2024 14:17:05) (NTS)
```

## 🔧 What It Does

The script automatically:

1. Detects all installed PHP versions on your system
2. Displays them in an easy-to-read numbered list
3. Highlights the currently active version
4. Switches PHP CLI version using `update-alternatives`
5. Switches Apache `mod_php` module (if Apache is installed)
6. Restarts PHP-FPM service for the selected version
7. Restarts Nginx (if running)
8. Restarts Apache (if running)

## 🛠️ Supported Configurations

- ✅ Apache with mod_php
- ✅ Nginx with PHP-FPM
- ✅ PHP CLI (Command Line Interface)
- ✅ Multiple PHP versions from Ondřej Surý's repository

## ⚠️ Troubleshooting

### Command not found

```bash
# Check if file exists and is executable
ls -l /usr/local/bin/changephp

# Make it executable
sudo chmod +x /usr/local/bin/changephp

# Check if /usr/local/bin is in PATH
echo $PATH
```

### No PHP versions detected

```bash
# Verify PHP installations
ls /usr/bin/php*

# Check installed PHP packages
dpkg -l | grep php
```

### Permission denied

```bash
# The script needs sudo privileges for switching versions
# Make sure you can run sudo commands
sudo -v
```

### Git clone not working

```bash
# If you don't have git installed
sudo apt update
sudo apt install git -y

# Then try cloning again
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
```

## 🔄 Updating

To update to the latest version:

```bash
# Method 1: Using git
cd /tmp
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git
cd Linux-ChangePHP-Script
sudo cp changephp.sh /usr/local/bin/changephp
chmod +x /usr/local/bin/changephp

# Method 2: Direct download
wget https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh -O /tmp/changephp.sh
sudo cp /tmp/changephp.sh /usr/local/bin/changephp
sudo chmod +x /usr/local/bin/changephp
```

## 🗑️ Uninstallation

To remove the script:

```bash
sudo rm /usr/local/bin/changephp
```

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Sahil Kappu**

- GitHub: [@sahilkappu](https://github.com/sahilkappu)
- Repository: [Linux-ChangePHP-Script](https://github.com/sahilkappu/Linux-ChangePHP-Script)

## 🌟 Show Your Support

If you found this helpful, please give it a ⭐️!

## 📚 Related Resources

- [PHP Official Website](https://www.php.net/)
- [Ondřej Surý's PHP PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php)
- [PHP Version Support](https://www.php.net/supported-versions.php)

---

Made with ❤️ for the PHP development community
