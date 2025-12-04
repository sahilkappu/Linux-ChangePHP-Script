# 📥 Installation Guide

## Method 1: One-Line Installation (Recommended)

Copy and paste this single command:

```bash
wget -O /tmp/changephp.sh https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh && sudo chmod +x /tmp/changephp.sh && sudo mv /tmp/changephp.sh /usr/local/bin/changephp && changephp
```

This will:

1. Download the script
2. Make it executable
3. Move it to `/usr/local/bin`
4. Run it immediately

## Method 2: Manual Installation

### Step 1: Download the Script

```bash
# Using wget
wget https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh

# OR using curl
curl -O https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh
```

### Step 2: Make it Executable

```bash
chmod +x changephp.sh
```

### Step 3: Move to System Path

```bash
sudo mv changephp.sh /usr/local/bin/changephp
```

### Step 4: Run It

```bash
changephp
```

## Method 3: Clone Repository

```bash
# Clone the repository
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git

# Navigate to directory
cd Linux-ChangePHP-Script

# Make executable
chmod +x changephp.sh

# Move to system path
sudo mv changephp.sh /usr/local/bin/changephp

# Run it
changephp
```

## Verify Installation

Check if the command is working:

```bash
which changephp
# Should output: /usr/local/bin/changephp

changephp
# Should display the PHP version switcher menu
```

## Uninstallation

To remove the script:

```bash
sudo rm /usr/local/bin/changephp
```

## Updating

To update to the latest version:

```bash
# Download latest version
wget -O /tmp/changephp.sh https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh

# Replace existing file
sudo mv /tmp/changephp.sh /usr/local/bin/changephp

# Make executable
sudo chmod +x /usr/local/bin/changephp
```

## System Requirements

- **OS**: Ubuntu 18.04+ or Debian 10+
- **Shell**: Bash 4.0+
- **Privileges**: sudo access
- **PHP**: At least 2 PHP versions installed

## Installing PHP Versions

If you need to install multiple PHP versions:

```bash
# Add repository
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Install desired versions
sudo apt install php7.4 php7.4-cli php7.4-fpm -y
sudo apt install php8.1 php8.1-cli php8.1-fpm -y
sudo apt install php8.2 php8.2-cli php8.2-fpm -y
sudo apt install php8.3 php8.3-cli php8.3-fpm -y

# Install common extensions (adjust as needed)
for version in 7.4 8.1 8.2 8.3; do
    sudo apt install php${version}-{mysql,curl,xml,mbstring,zip,gd,bcmath,intl} -y
done
```

## Troubleshooting

### Issue: "Command not found"

**Solution:**

```bash
# Check if file exists
ls -l /usr/local/bin/changephp

# If missing, reinstall
wget -O /usr/local/bin/changephp https://raw.githubusercontent.com/sahilkappu/Linux-ChangePHP-Script/main/changephp.sh
sudo chmod +x /usr/local/bin/changephp
```

### Issue: "Permission denied"

**Solution:**

```bash
sudo chmod +x /usr/local/bin/changephp
```

### Issue: "/usr/local/bin not in PATH"

**Solution:**

```bash
# Add to PATH temporarily
export PATH=$PATH:/usr/local/bin

# Add permanently (add to ~/.bashrc)
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
```

### Issue: "No PHP versions found"

**Solution:**

```bash
# Check installed PHP versions
dpkg -l | grep php | grep ^ii

# Verify PHP binaries
ls -la /usr/bin/php*
```

## Need Help?

If you encounter issues:

1. Check the [README.md](README.md) for usage instructions
2. Open an issue on [GitHub](https://github.com/sahilkappu/Linux-ChangePHP-Script/issues)
3. Ensure you have the latest version of the script
