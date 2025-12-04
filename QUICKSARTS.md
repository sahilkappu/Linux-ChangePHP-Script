# 🚀 Quick Start Guide

Get up and running with Linux ChangePHP Script in under 5 minutes!

## ⚡ Installation (30 seconds)

```bash
git clone https://github.com/sahilkappu/Linux-ChangePHP-Script.git && cd Linux-ChangePHP-Script && chmod +x install.sh && ./install.sh
```

That's it! The script is now installed as `changephp`.

## 📖 Basic Usage

### Switch PHP Version

```bash
changephp
```

You'll see:

```
Available PHP versions:

  1. PHP 7.4 [FPM: stopped]
  2. PHP 8.1 (current) [FPM: running]
  3. PHP 8.2 [FPM: stopped]

Select version number (1-3): 3
```

Enter `3` and press Enter. Done! ✅

### Verify Switch

```bash
php -v
# Output: PHP 8.2.x (cli) (built: ...)
```

## 🎯 Common Scenarios

### Scenario 1: First Time Setup (No PHP Installed)

```bash
# Step 1: Run changephp
changephp

# Step 2: Choose to install PHP
# When prompted "No PHP versions found", type 'y'

# Step 3: Or press 'a' for advanced menu, then '1'

# Step 4: Enter versions to install
# Type: 8.1 8.2 8.3
# Press Enter and wait

# Step 5: Switch to desired version
# Script will return to main menu
# Select your preferred version
```

**Time:** 5-10 minutes (depending on internet speed)

### Scenario 2: Have PHP, Need to Switch

```bash
# Step 1: Run changephp
changephp

# Step 2: Select version number
# Type: 2
# Press Enter

# Done! ✅
```

**Time:** 10 seconds

### Scenario 3: Missing PHP-FPM (Nginx Users)

```bash
# Step 1: Run changephp
changephp

# Step 2: Press 'a' for advanced menu

# Step 3: Select option '2' (Install missing PHP-FPM)

# Step 4: Confirm installation
# Type: y
# Press Enter

# Done! ✅
```

**Time:** 1-2 minutes

### Scenario 4: Copy Extensions to New PHP Version

```bash
# Step 1: Run changephp
changephp

# Step 2: Press 'a' for advanced menu

# Step 3: Select option '4' (Sync modules)

# Step 4: Choose source version
# Type: 2 (PHP 8.1)
# Press Enter

# Step 5: Choose target version
# Type: 3 (PHP 8.2)
# Press Enter

# Wait for installation to complete
# Done! ✅
```

**Time:** 2-5 minutes

## 🎨 Menu Navigation

### Main Menu

```
Press number (1-4): Switch to that PHP version
Press 'a': Access advanced features
Press '0': Exit
```

### Advanced Menu

```
Press '1': Install PHP versions
Press '2': Install missing PHP-FPM
Press '3': Show all modules
Press '4': Sync modules between versions
Press '5': Check service status
Press '0': Back to main menu
```

## 🔧 Common Commands

### After Installation

```bash
# Switch versions
changephp

# Check current version
php -v

# List installed versions
ls /usr/bin/php* | grep -oP 'php\K[0-9]+\.[0-9]+'

# Check PHP-FPM status
systemctl status php8.1-fpm

# Restart web server
sudo systemctl restart apache2
sudo systemctl restart nginx
```

## ⚠️ Important Notes

### For Apache Users

- ✅ Script handles everything automatically
- ✅ Apache restarts automatically
- ✅ No manual configuration needed

### For Nginx Users

- ⚠️ **Manual step required!**
- After switching, update your Nginx config:

```bash
sudo nano /etc/nginx/sites-available/default
```

Change:

```nginx
fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
```

To:

```nginx
fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
```

Then:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### For Laravel/Symfony/WordPress Users

- ✅ Just switch and continue working
- ✅ Composer still works
- ✅ Artisan still works
- ✅ WP-CLI still works

## 🐛 Troubleshooting

### "Command not found"

```bash
# Check installation
which changephp

# If missing, reinstall
cd ~/Linux-ChangePHP-Script
./install.sh
```

### "No PHP versions detected"

```bash
# Install PHP using the script
changephp
# Press 'a', then '1'
# Enter versions: 8.1 8.2 8.3
```

### "Permission denied"

```bash
# Make sure you're not using sudo
changephp
# NOT: sudo changephp

# Script will ask for password when needed
```

### "PHP-FPM not starting"

```bash
# Check what's wrong
systemctl status php8.1-fpm

# View detailed logs
journalctl -u php8.1-fpm -n 50

# Reinstall if needed
changephp
# Press 'a', then '2'
```

### "Version switched but still showing old"

```bash
# Restart terminal
exit
# Open new terminal

# Or reload shell
source ~/.bashrc

# Check again
php -v
```

## 📚 Next Steps

Once you're comfortable with basic switching:

1. **Explore Advanced Features**

   - Press 'a' in the main menu
   - Try each option to see what it does

2. **Read Full Documentation**

   - [README.md](README.md) - Complete guide
   - [FEATURES.md](FEATURES.md) - Detailed feature explanations

3. **Configure Your Environment**
   - Set up your preferred PHP version
   - Install needed extensions
   - Configure php.ini settings

## 💡 Pro Tips

### Tip 1: Create Aliases

```bash
# Add to ~/.bashrc
alias php74='/usr/bin/php7.4'
alias php81='/usr/bin/php8.1'
alias php82='/usr/bin/php8.2'

# Use specific version without switching
php81 script.php
```

### Tip 2: Quick Version Check

```bash
# See all installed PHP versions
for php in /usr/bin/php[0-9]*; do
    $php -v | head -n1
done
```

### Tip 3: Test Multiple Versions

```bash
# Test your code on all versions
for php in /usr/bin/php[0-9]*; do
    echo "Testing with $php"
    $php script.php
done
```

### Tip 4: Project-Specific Versions

```bash
# Create .php-version file in project
echo "8.2" > .php-version

# Before working, check and switch
cat .php-version
changephp  # switch to 8.2
```

### Tip 5: Nginx Config Template

```nginx
# Save this for quick switching
location ~ \.php$ {
    fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```

## 🎯 5-Minute Checklist

- [ ] Install script (`git clone` + `./install.sh`)
- [ ] Run `changephp` for the first time
- [ ] Install PHP versions if needed (press 'a', then '1')
- [ ] Switch to your preferred version
- [ ] Verify with `php -v`
- [ ] Update Nginx config if using Nginx
- [ ] Test your application
- [ ] You're done! 🎉

## 📞 Getting Help

- **Quick questions:** Check [README.md](README.md)
- **Feature details:** Read [FEATURES.md](FEATURES.md)
- **Issues:** Open issue on [GitHub](https://github.com/sahilkappu/Linux-ChangePHP-Script/issues)
- **Discussions:** GitHub Discussions

## ⭐ Like It?

Give the repo a star! It helps others discover the tool.

```bash
# Star the repo on GitHub
https://github.com/sahilkappu/Linux-ChangePHP-Script
```

---

**Ready to switch PHP versions like a pro?** Run `changephp` now! 🚀
