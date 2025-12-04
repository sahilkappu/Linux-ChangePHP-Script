# 🎯 Features Documentation

## Overview

Linux ChangePHP Script - Advanced Edition is a complete PHP version management solution for Ubuntu/Debian systems. This document explains all features in detail.

## 📊 Feature Comparison

| Feature                    | Basic Version | Advanced Version |
| -------------------------- | ------------- | ---------------- |
| Auto-detect PHP versions   | ✅            | ✅               |
| Interactive menu           | ✅            | ✅               |
| CLI switching              | ✅            | ✅               |
| Apache module switching    | ✅            | ✅               |
| PHP-FPM management         | ⚠️ Basic      | ✅ Advanced      |
| Stop old FPM services      | ❌            | ✅               |
| Prevent mixed FPM versions | ❌            | ✅               |
| Handle missing binaries    | ❌            | ✅               |
| Nginx warnings             | ❌            | ✅               |
| Service status display     | ❌            | ✅               |
| Install PHP versions       | ❌            | ✅               |
| Install missing FPM        | ❌            | ✅               |
| Show all modules           | ❌            | ✅               |
| Sync modules               | ❌            | ✅               |
| Advanced TUI menu          | ❌            | ✅               |
| Color-coded status         | ✅            | ✅ Enhanced      |
| Safety checks              | ✅            | ✅ Enhanced      |

## 🔧 Core Features

### 1. PHP Version Detection

**How it works:**

- Scans `/usr/bin` for PHP executables (php7.4, php8.1, etc.)
- Executes each binary to verify actual version via `php -v`
- Cross-references with installed packages via `dpkg`
- Removes duplicates and sorts versions

**Why it's better:**

- Detects actual installed versions, not just packages
- Works even with custom PHP installations
- Handles broken symlinks gracefully

**Example output:**

```
Available PHP versions:

  1. PHP 7.4 [FPM: stopped]
  2. PHP 8.1 (current) [FPM: running]
  3. PHP 8.2 [FPM: stopped]
```

### 2. Interactive TUI Menu

**Features:**

- Color-coded version list
- Shows current active version
- Displays FPM status for each version
- Advanced menu accessible via 'a' key
- Safe exit option (0)

**Status indicators:**

- 🟢 **Green (current)** - Currently active version
- 🟢 **[FPM: running]** - PHP-FPM is active
- 🟡 **[FPM: stopped]** - PHP-FPM installed but not running
- 🔴 **[FPM: not installed]** - PHP-FPM package missing

### 3. CLI Switching

**What it does:**

- Updates system-wide `php` command
- Changes default CLI version
- Updates alternatives for optional binaries

**Binaries managed:**

- `php` (required)
- `phar` (optional)
- `phar.phar` (optional)
- `phpize` (optional)
- `php-config` (optional)
- `phpdbg` (optional)

**Safe handling:**

- Won't fail if optional binaries are missing
- Gracefully handles incomplete installations
- Validates binary existence before switching

### 4. Apache Module Switching

**Smart management:**

- Only disables PHP-related modules
- Doesn't touch other Apache modules (rewrite, ssl, etc.)
- Handles both mod_php and PHP-FPM configurations
- Graceful handling when mod_php isn't installed

**Process:**

1. Lists all active modules
2. Filters for PHP modules only (`php7_module`, `php8_module`)
3. Disables old PHP modules
4. Enables selected PHP module
5. Only restarts Apache if it's running

### 5. PHP-FPM Management ⭐ ADVANCED

**Key improvements:**

- **Stops ALL old FPM services** before switching
- **Prevents mixed versions** running simultaneously
- **Cleans up zombie processes**
- **Enables new FPM service** automatically
- **Verifies service status** after switch

**Why this matters:**

```bash
# Before (Basic version):
# User switches from 8.1 to 8.2
# Problem: Both php8.1-fpm and php8.2-fpm running
# Result: Confusion, port conflicts, wrong version handling requests

# After (Advanced version):
# Stops php8.1-fpm
# Starts php8.2-fpm
# Result: Only one FPM version active, clean switching
```

**Process:**

1. Detect all running PHP-FPM services
2. Stop each one gracefully
3. Wait for clean shutdown
4. Start new version's FPM
5. Enable for automatic startup
6. Verify it's running

### 6. Nginx Support ⭐ ADVANCED

**Features:**

- Detects if Nginx is installed
- Restarts Nginx after FPM switch
- Shows configuration warnings
- Provides correct fastcgi_pass syntax

**Configuration warning:**

```
⚠ IMPORTANT: Check your Nginx configuration!
ℹ Update fastcgi_pass to: unix:/var/run/php/php8.2-fpm.sock
ℹ Or: fastcgi_pass 127.0.0.1:9082
```

**Why it's needed:**

- Nginx configuration is static (not auto-updated)
- User must manually update fastcgi_pass
- Script provides exact syntax needed

### 7. System Information Display

**Shows:**

- Apache status (installed/running/stopped)
- Nginx status (installed/running/stopped)
- Web server configuration type
- PHP-FPM availability per version

**Example:**

```
System Information:

✓ Apache is installed and running
✓ Nginx is installed and running
```

## 🎨 Advanced Features

### 1. Install PHP Versions ⭐

**What it does:**
Installs complete PHP environments from scratch.

**Process:**

1. Adds Ondřej Surý's PHP repository
2. Updates package list
3. Installs PHP core packages:

   - `phpX.Y` - Base package
   - `phpX.Y-cli` - Command-line interface
   - `phpX.Y-common` - Common files
   - `phpX.Y-fpm` - FastCGI Process Manager

4. Installs common extensions:
   - `mysql` - MySQL database support
   - `curl` - HTTP client
   - `xml` - XML processing
   - `mbstring` - Multibyte string support
   - `zip` - ZIP archive support
   - `gd` - Image processing
   - `bcmath` - Arbitrary precision math
   - `intl` - Internationalization
   - `soap` - SOAP protocol support
   - `opcache` - Performance optimization

**Usage:**

```
Advanced Options:
Select option: 1

Enter versions to install: 8.1 8.2 8.3

Installing PHP 8.1...
[installation progress]
✓ PHP 8.1 installed successfully

Installing PHP 8.2...
[installation progress]
✓ PHP 8.2 installed successfully
```

**Use cases:**

- Setting up new development machine
- Adding new PHP version to existing setup
- Reinstalling corrupted PHP installation

### 2. Install Missing PHP-FPM ⭐

**What it does:**
Scans for PHP installations without FPM and offers to install it.

**Process:**

1. Detects all installed PHP versions
2. Checks which ones have PHP-FPM
3. Lists missing FPM packages
4. Installs FPM for selected versions
5. Enables and starts services

**Example scenario:**

```
You installed: php8.2 php8.2-cli php8.2-common
But forgot: php8.2-fpm

Script detects this and offers:
Missing PHP-FPM for versions:
  - PHP 8.2

Install missing PHP-FPM? (y/n): y
Installing PHP-FPM 8.2...
✓ PHP-FPM 8.2 installed
```

**Why it's useful:**

- Nginx users NEED PHP-FPM
- Easy to forget during manual installation
- Fixes incomplete installations

### 3. Show PHP Modules ⭐

**What it does:**
Lists all installed PHP extensions for each version.

**Output example:**

```
PHP 7.4 modules:
  bcmath
  calendar
  Core
  ctype
  curl
  date
  dom
  exif
  FFI
  fileinfo
  filter
  ftp
  gd
  gettext
  hash
  iconv
  intl
  json
  libxml
  mbstring
  mysqli
  mysqlnd
  openssl
  pcre
  PDO
  pdo_mysql
  Phar
  readline
  Reflection
  session
  SimpleXML
  soap
  sockets
  sodium
  SPL
  standard
  tokenizer
  xml
  xmlreader
  xmlwriter
  xsl
  Zend OPcache
  zip
  zlib

PHP 8.1 modules:
  [similar list]
```

**Use cases:**

- Debugging missing extensions
- Comparing module availability across versions
- Verifying installation completeness
- Documentation purposes

### 4. Sync Modules Between Versions ⭐

**What it does:**
Copies all extensions from one PHP version to another.

**Process:**

1. Shows list of installed PHP versions
2. User selects source version
3. User selects target version
4. Script gets list of modules from source
5. Checks which modules are missing in target
6. Installs missing packages automatically

**Example workflow:**

```
Available PHP versions:
  1. PHP 7.4
  2. PHP 8.1
  3. PHP 8.2

Source version number: 2
Target version number: 3

Getting modules from PHP 8.1...
Installing missing modules for PHP 8.2...

Installing php8.2-redis...
Installing php8.2-imagick...
Installing php8.2-xdebug...

✓ Module sync complete
```

**Real-world scenario:**

```
You've been developing on PHP 8.1 with many extensions installed.
Now you want to test on PHP 8.2.
Instead of manually installing each extension, use sync modules:
- All extensions from 8.1 → 8.2 automatically
- Saves time
- Ensures consistency
```

**Smart features:**

- Skips modules that don't have packages (e.g., Core, standard)
- Handles different package naming conventions
- Installs only what's missing

### 5. Service Status Check ⭐

**What it does:**
Provides complete overview of all PHP-related services.

**Shows:**

- Apache status
- Nginx status
- PHP-FPM status for each installed version
- Service enablement status

**Example output:**

```
Service Status

✓ Apache: Running
✓ Nginx: Running

PHP-FPM Services:

✓ PHP 7.4 FPM: Running
⚠ PHP 8.1 FPM: Stopped
✓ PHP 8.2 FPM: Running
ℹ PHP 8.3 FPM: Not installed
```

**Use cases:**

- Quick system health check
- Debugging service issues
- Verifying switches worked correctly
- System administration

## 🛡️ Safety Features

### 1. Root Prevention

```bash
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi
```

**Why:** Running as root can cause permission issues and is a security risk.

### 2. Input Validation

```bash
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    print_error "Invalid selection!"
    continue
fi
```

**Validates:**

- Numeric input only
- Range checking
- Non-empty input

### 3. Service State Awareness

```bash
if systemctl is-active --quiet apache2; then
    sudo systemctl restart apache2
fi
```

**Benefits:**

- Won't try to restart stopped services
- Prevents unnecessary errors
- Respects user's configuration

### 4. Graceful Error Handling

```bash
if [ $? -eq 0 ]; then
    print_success "Operation successful"
else
    print_error "Operation failed"
    # Continue anyway, don't break
fi
```

**Features:**

- Operations continue even if optional steps fail
- Clear error messages
- System remains functional

### 5. Conflict Prevention

```bash
# Stop ALL FPM services before starting new one
stop_all_fpm
start_fpm "$selected_version"
```

**Prevents:**

- Multiple FPM versions running
- Port conflicts
- Resource competition
- Confusion about active version

## 🎨 User Experience Enhancements

### Color Coding

- 🟢 **Green** - Success, active items
- 🟡 **Yellow** - Warnings, in-progress
- 🔴 **Red** - Errors, stopped items
- 🔵 **Blue** - Information
- 🟣 **Magenta** - Special states
- 🔵 **Cyan** - Headers, emphasis

### Clear Formatting

- Bold for important text
- Consistent spacing
- Organized sections
- Progress indicators

### Intuitive Navigation

- Numbered menus
- Single-key selections
- Back/Exit options always available
- Advanced menu easily accessible

## 🚀 Performance

**Fast operations:**

- PHP detection: <1 second
- Version switching: 2-5 seconds
- Module syncing: Depends on number of packages

**Optimizations:**

- Minimal system calls
- Efficient process management
- No unnecessary waits
- Parallel-safe operations

## 🔄 Compatibility

**Tested on:**

- Ubuntu 18.04, 20.04, 22.04, 24.04
- Debian 10, 11, 12
- Linux Mint 20, 21
- Pop!\_OS 20.04, 22.04

**PHP versions supported:**

- PHP 5.6 through 8.4
- All versions from ondrej/php repository

**Web servers:**

- Apache 2.4
- Nginx 1.14+
- Apache + Nginx (mixed)
- CLI only (no web server)

## 📋 Requirements

**Minimum:**

- Bash 4.0+
- sudo access
- systemctl (systemd)

**Recommended:**

- Git
- curl or wget
- Internet connection (for installations)

## 🎯 Use Cases

### Development Teams

- Standardize PHP environments across team
- Easy testing across PHP versions
- Quick switching for compatibility testing

### Web Hosting

- Manage multiple client PHP versions
- Safe version upgrades
- Per-site PHP versioning

### CI/CD Pipelines

- Test code against multiple PHP versions
- Automated version switching
- Consistent environments

### Learning

- Experiment with new PHP features
- Compare version differences
- Educational purposes

## 📖 Best Practices

1. **Always test after switching:**

   ```bash
   changephp
   php -v
   php -m
   ```

2. **Keep extensions synced:**
   Use module sync when adding extensions to ensure all versions have them.

3. **Monitor FPM services:**
   Regularly check service status to ensure only one FPM is running.

4. **Update Nginx configs:**
   Remember to update fastcgi_pass after switching.

5. **Backup configurations:**
   Before major changes, backup `/etc/php/` directory.

## 🔮 Future Features

Coming soon:

- [ ] Automatic Nginx config updates
- [ ] PHP.ini synchronization
- [ ] Configuration backup/restore
- [ ] Per-directory PHP version (using .php-version files)
- [ ] Performance benchmarking
- [ ] Docker support
- [ ] GUI version using dialog/whiptail
- [ ] Debian package (.deb) installer

---

For more information, visit: https://github.com/sahilkappu/Linux-ChangePHP-Script
