# Arch Linux Dotfiles Collection

A comprehensive and professionally crafted collection of configuration files for Arch Linux, featuring a modern Hyprland-based desktop environment with dynamic theming capabilities. This repository provides a complete desktop setup optimized for productivity and visual appeal, utilizing pywal16 for seamless color scheme management across all applications.

## Preview

![Desktop Screenshot](https://i.ibb.co/s9yT3yfK/swappy-20250723-132522.png)

**Modern Hyprland desktop environment with coordinated theming across all applications**

## Features and Overview

### Environment Specifications
- **Operating System**: Arch Linux
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar with multiple style configurations
- **Terminal Emulators**: Kitty and Alacritty
- **Application Launcher**: Rofi with custom themes
- **Shell**: Zsh with Oh My Posh prompt

### Key Features

- **Dynamic Theming**: pywal16 integration for automatic color coordination across all applications
- **Hyprland**: Modern Wayland compositor with custom keybindings and multi-monitor support
- **Audio Visualizers**: Xava and GLava with themed integration
- **Productivity Tools**: Btop system monitor, LF file manager, custom scripts

### Included Applications

- **Hyprland**: Wayland compositor with extensive customization
- **Waybar**: Status bar with system information and custom modules
- **Rofi**: Application launcher with multiple themes
- **Kitty/Alacritty**: Terminal emulators with theming
- **Btop**: System resource monitor
- **LunarVim**: Neovim-based IDE
- **Spicetify**: Spotify theming integration
- **Audio Visualizers**: Xava and GLava with pywal16 integration



## Prerequisites and Dependencies

### System Requirements

This dotfiles collection is specifically designed for **Arch Linux** and requires the following system components:

- **Arch Linux**: The configuration is optimized for Arch Linux and uses pacman for package management
- **Pacman**: Arch Linux package manager (included with Arch Linux)
- **Internet Connection**: Required for downloading packages and dependencies
- **Sudo Access**: Administrative privileges needed for package installation

### Required Tools and Utilities

Before installation, ensure the following tools are available on your system:

#### Essential Tools
- **Git**: For cloning the repository
- **Nushell**: Required to run the install.nu installation script
- **Base Development Tools**: For building AUR packages

#### AUR Helper (Required for AUR Packages)
An AUR (Arch User Repository) helper is required to install AUR packages. Install one of the following:

- **yay** (recommended): `sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si`
- **paru**: Alternative AUR helper with similar functionality

### Package Dependencies

The installation script will automatically install the following packages:

#### Official Repository Packages
The following packages will be installed from the official Arch Linux repositories:

**Core Desktop Environment:**
- `hyprland` - Wayland compositor and window manager
- `waybar` - Highly customizable status bar
- `rofi` - Application launcher and menu system
- `wlogout` - Logout menu with custom styling

**Terminal and Shell:**
- `kitty` - GPU-accelerated terminal emulator
- `alacritty` - Cross-platform terminal emulator

**System Utilities:**
- `btop` - Modern system resource monitor
- `fastfetch` - System information display tool
- `lf` - Terminal file manager
- `hypridle` - Idle daemon for screen management
- `hyprlock` - Screen locker

**Theming and Visual:**
- `pywal` - Color scheme generator
- `swww` - Wallpaper daemon with transitions

**Media and Screenshot:**
- `grim` - Screenshot utility for Wayland
- `slurp` - Screen area selection tool
- `wl-clipboard` - Wayland clipboard utilities
- `brightnessctl` - Screen brightness control
- `pamixer` - Audio control utility
- `playerctl` - Media player control

**System Integration:**
- `polkit-kde-agent` - Authentication agent
- `xdg-desktop-portal-hyprland` - Desktop portal for Hyprland

**Fonts:**
- `noto-fonts` - Google Noto font family
- `noto-fonts-emoji` - Emoji font support
- `ttf-jetbrains-mono-nerd` - JetBrains Mono Nerd Font

#### AUR (Arch User Repository) Packages
The following packages will be installed from the AUR:

- `spicetify-cli` - Spotify theming tool
- `lunarvim-git` - Neovim-based IDE
- `oh-my-posh-bin` - Cross-platform prompt theme engine
- `pywal16` - Extended 16-color version of pywal
- `xava` - Audio visualizer
- `glava` - OpenGL audio visualizer

#### Cargo Packages
The following Rust packages will be installed via Cargo:

- `anny-dock` - Dock application for the desktop

### Installation Script Features

The `install.nu` script provides several options for flexible installation:

- `--dry-run (-d)`: Preview installation without making changes
- `--force (-f)`: Overwrite existing configuration files
- `--skip-packages (-s)`: Skip package installation, only configure dotfiles
- `--config-only (-c)`: Install only configuration files, skip all packages

### Pre-Installation Checklist

Before running the installation script, ensure:

1. **System Update**: Run `sudo pacman -Syu` to update your system
2. **AUR Helper**: Install yay or paru for AUR package management
3. **Backup**: Create backups of existing configuration files (see Safety Considerations)
4. **Network**: Ensure stable internet connection for package downloads
5. **Permissions**: Verify sudo access is available

## Installation

### Quick Start (Automated Installation)

The easiest way to install this dotfiles collection is using the automated installation script:

```bash
# Clone the repository
git clone https://github.com/[your-username]/dotfiles.git
cd dotfiles

# Run the installation script
nu install.nu
```

This will automatically install all required packages and configure the dotfiles with default settings.

### Installation Script Options

The `install.nu` script provides several command-line options for customized installation:

#### Available Options

- `--dry-run` or `-d`: Preview the installation process without making any changes to your system
- `--force` or `-f`: Overwrite existing configuration files without prompting
- `--skip-packages` or `-s`: Skip package installation and only configure dotfiles
- `--config-only` or `-c`: Install only configuration files, skip all package installation

#### Usage Examples

**Preview Installation (Recommended First Step):**
```bash
nu install.nu --dry-run
```
This shows exactly what will be installed and configured without making changes.

**Force Overwrite Existing Configurations:**
```bash
nu install.nu --force
```
Use this if you want to replace existing configuration files.

**Install Only Configuration Files:**
```bash
nu install.nu --config-only
```
Useful if you already have the required packages installed.

**Skip Package Installation:**
```bash
nu install.nu --skip-packages
```
Only sets up configuration files, assumes packages are already installed.

**Combined Options:**
```bash
nu install.nu --dry-run --force
nu install.nu --config-only --force
```

### Step-by-Step Manual Installation

If you prefer manual installation or need to install selectively, follow these steps:

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

#### 2. Install Required Packages

**Install Official Packages:**
```bash
sudo pacman -S --needed hyprland waybar rofi kitty alacritty btop fastfetch lf wlogout hypridle hyprlock pywal swww grim slurp wl-clipboard brightnessctl pamixer playerctl polkit-kde-agent xdg-desktop-portal-hyprland noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd
```

**Install AUR Packages (requires yay or paru):**
```bash
yay -S --needed spicetify-cli lunarvim-git oh-my-posh-bin pywal16 xava glava
```

**Install Cargo Packages:**
```bash
cargo install anny-dock
```

#### 3. Create Configuration Directories
```bash
mkdir -p ~/.config
```

#### 4. Link Configuration Files

**Link Application Configurations:**
```bash
ln -sf $(pwd)/hypr ~/.config/hypr
ln -sf $(pwd)/waybar ~/.config/waybar
ln -sf $(pwd)/rofi ~/.config/rofi
ln -sf $(pwd)/kitty ~/.config/kitty
ln -sf $(pwd)/alacritty ~/.config/alacritty
ln -sf $(pwd)/btop ~/.config/btop
ln -sf $(pwd)/fastfetch ~/.config/fastfetch
ln -sf $(pwd)/lf ~/.config/lf
ln -sf $(pwd)/wlogout ~/.config/wlogout
ln -sf $(pwd)/spicetify ~/.config/spicetify
ln -sf $(pwd)/xava ~/.config/xava
ln -sf $(pwd)/glava ~/.config/glava
ln -sf $(pwd)/wal ~/.config/wal
ln -sf $(pwd)/lvim ~/.config/lvim
```

**Link Home Directory Files:**
```bash
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/oh-my-posh.omp.json ~/.config/oh-my-posh.omp.json
```

#### 5. Set Script Permissions
```bash
chmod +x hypr/scripts/*.sh
chmod +x hypr/UserScripts/*.sh
chmod +x waybar/scripts/*.sh
```

### Selective Installation Guide

You can install specific components of this dotfiles collection based on your needs:

#### Window Manager Only (Hyprland)
```bash
# Install Hyprland and essential dependencies
sudo pacman -S --needed hyprland hypridle hyprlock xdg-desktop-portal-hyprland

# Link Hyprland configuration
ln -sf $(pwd)/hypr ~/.config/hypr
chmod +x hypr/scripts/*.sh hypr/UserScripts/*.sh
```

#### Terminal Setup Only
```bash
# Install terminal emulators and shell tools
sudo pacman -S --needed kitty alacritty
yay -S --needed oh-my-posh-bin

# Link terminal configurations
ln -sf $(pwd)/kitty ~/.config/kitty
ln -sf $(pwd)/alacritty ~/.config/alacritty
ln -sf $(pwd)/.zshrc ~/.zshrc
ln -sf $(pwd)/oh-my-posh.omp.json ~/.config/oh-my-posh.omp.json
```

#### Status Bar Only (Waybar)
```bash
# Install Waybar
sudo pacman -S --needed waybar

# Link Waybar configuration
ln -sf $(pwd)/waybar ~/.config/waybar
chmod +x waybar/scripts/*.sh
```

#### Theming System Only
```bash
# Install theming tools
sudo pacman -S --needed pywal swww
yay -S --needed pywal16

# Link theming configurations
ln -sf $(pwd)/wal ~/.config/wal
```

#### Audio Visualizers Only
```bash
# Install audio visualizers
yay -S --needed xava glava

# Link visualizer configurations
ln -sf $(pwd)/xava ~/.config/xava
ln -sf $(pwd)/glava ~/.config/glava
```

### Installation Verification

After installation, verify the setup by checking:

1. **Configuration Files**: Ensure symlinks are created correctly
   ```bash
   ls -la ~/.config/ | grep -E "(hypr|waybar|rofi|kitty)"
   ```

2. **Script Permissions**: Verify scripts are executable
   ```bash
   ls -la ~/.config/hypr/scripts/*.sh
   ```

3. **Package Installation**: Check if key packages are installed
   ```bash
   pacman -Q hyprland waybar rofi kitty
   ```

### Troubleshooting Installation Issues

**Common Installation Problems:**

1. **Missing AUR Helper**: If AUR packages fail to install, install yay first:
   ```bash
   sudo pacman -S --needed git base-devel
   git clone https://aur.archlinux.org/yay.git
   cd yay && makepkg -si
   ```

2. **Permission Denied**: If script permissions fail, manually set them:
   ```bash
   find ~/.config/hypr -name "*.sh" -exec chmod +x {} \;
   find ~/.config/waybar -name "*.sh" -exec chmod +x {} \;
   ```

3. **Existing Configuration Conflicts**: Use `--force` flag or manually backup and remove existing configs:
   ```bash
   mv ~/.config/hypr ~/.config/hypr.backup
   nu install.nu
   ```

4. **Network Issues**: If package downloads fail, check your internet connection and try again:
   ```bash
   sudo pacman -Syu
   nu install.nu
   ```

## Safety and Backup Considerations

### Important: Backup Your Existing Configuration

**Before installing these dotfiles, it is strongly recommended to backup your existing configuration files.** This installation will overwrite existing configurations, and recovery without backups may be difficult or impossible.

#### Quick Backup Commands

Create a backup of your current configurations before installation:

```bash
# Create backup directory with timestamp
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing configurations that will be overwritten
cp -r ~/.config/hypr "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/waybar "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/rofi "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/kitty "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/alacritty "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/btop "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/fastfetch "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/lf "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/wlogout "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/spicetify "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/xava "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/glava "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/wal "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.config/lvim "$BACKUP_DIR/" 2>/dev/null || true
cp ~/.zshrc "$BACKUP_DIR/" 2>/dev/null || true
cp ~/.config/oh-my-posh.omp.json "$BACKUP_DIR/" 2>/dev/null || true

echo "Backup created in: $BACKUP_DIR"
```

#### Automated Backup Script

For convenience, you can create a backup script:

```bash
#!/bin/bash
# Save as backup-configs.sh and make executable

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

CONFIGS=(
    "hypr" "waybar" "rofi" "kitty" "alacritty" "btop" 
    "fastfetch" "lf" "wlogout" "spicetify" "xava" 
    "glava" "wal" "lvim"
)

HOME_FILES=(".zshrc" ".config/oh-my-posh.omp.json")

echo "Creating backup in: $BACKUP_DIR"

for config in "${CONFIGS[@]}"; do
    if [ -d "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
        echo "Backed up: ~/.config/$config"
    fi
done

for file in "${HOME_FILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        echo "Backed up: ~/$file"
    fi
done

echo "Backup completed successfully!"
```

### Files That Will Be Overwritten

The installation process will create symbolic links that **replace existing files and directories**. The following locations will be affected:

#### Configuration Directories (in ~/.config/)
These entire directories will be replaced with symbolic links:

- `~/.config/hypr/` - Hyprland window manager configuration
- `~/.config/waybar/` - Status bar configuration
- `~/.config/rofi/` - Application launcher configuration
- `~/.config/kitty/` - Kitty terminal configuration
- `~/.config/alacritty/` - Alacritty terminal configuration
- `~/.config/btop/` - System monitor configuration
- `~/.config/fastfetch/` - System information tool configuration
- `~/.config/lf/` - File manager configuration
- `~/.config/wlogout/` - Logout menu configuration
- `~/.config/spicetify/` - Spotify theming configuration
- `~/.config/xava/` - Audio visualizer configuration
- `~/.config/glava/` - OpenGL audio visualizer configuration
- `~/.config/wal/` - Pywal theming templates
- `~/.config/lvim/` - LunarVim IDE configuration

#### Home Directory Files
These individual files will be replaced:

- `~/.zshrc` - Zsh shell configuration
- `~/.config/oh-my-posh.omp.json` - Shell prompt theme configuration

#### Important Notes About File Replacement

- **Symbolic Links**: The installer creates symbolic links, not copies. This means the original files in the dotfiles repository remain the source of truth.
- **Complete Directory Replacement**: When a configuration directory exists, the entire directory is removed and replaced with a symbolic link.
- **No Selective Merging**: The installer does not merge configurations - it performs complete replacement.
- **Immediate Effect**: Changes take effect immediately since configurations are linked to the repository.

### Understanding the --force Flag

The `--force` (or `-f`) flag controls how the installer handles existing configuration files:

#### Default Behavior (without --force)
```bash
nu install.nu
```

**What happens:**
- If a configuration file or directory already exists, the installer will **skip it**
- A warning message is displayed: "File already exists (use --force to overwrite): [path]"
- Installation continues with other files
- **Result**: Partial installation with existing configurations preserved

#### With --force Flag
```bash
nu install.nu --force
```

**What happens:**
- Existing configuration files and directories are **immediately removed**
- New symbolic links are created without prompting
- **No confirmation is requested** - removal is automatic
- **Result**: Complete replacement of all existing configurations

#### Critical --force Flag Implications

**WARNING: The --force flag will permanently delete existing configurations**

- **Irreversible**: Once removed, existing configurations cannot be recovered without backups
- **No Confirmation**: The installer does not ask for confirmation before removing files
- **Complete Replacement**: All existing customizations will be lost
- **Immediate Effect**: Changes happen instantly during installation

**Use --force only when:**
- You have created proper backups of existing configurations
- You are certain you want to completely replace existing setups
- You are reinstalling after testing with --dry-run

### Safe Testing with --dry-run Flag

The `--dry-run` (or `-d`) flag allows you to preview the installation process without making any changes to your system:

#### Basic Dry Run
```bash
nu install.nu --dry-run
```

**What it shows:**
- Which packages would be installed
- Which configuration files would be created or overwritten
- Which symbolic links would be established
- Script permissions that would be set

**What it doesn't do:**
- Install any packages
- Create or modify any files
- Change any system configurations
- Set any permissions

#### Combining Dry Run with Other Flags

**Preview with force overwrite:**
```bash
nu install.nu --dry-run --force
```
Shows what would happen if existing files were forcefully overwritten.

**Preview configuration-only installation:**
```bash
nu install.nu --dry-run --config-only
```
Shows only configuration changes without package installation.

**Preview selective installation:**
```bash
nu install.nu --dry-run --skip-packages
```
Shows configuration setup without package installation.

#### Recommended Testing Workflow

1. **Initial Preview**: Always start with a dry run to understand the impact
   ```bash
   nu install.nu --dry-run
   ```

2. **Review Output**: Carefully examine which files would be affected

3. **Create Backups**: Use the backup commands provided above

4. **Test Configuration Only**: Try configuration setup without packages first
   ```bash
   nu install.nu --config-only --dry-run
   nu install.nu --config-only  # If satisfied with preview
   ```

5. **Full Installation**: Proceed with complete installation
   ```bash
   nu install.nu --force  # Only if you have backups
   ```

### Recovery and Rollback Procedures

#### Restoring from Backup

If you need to restore your previous configuration:

```bash
# Remove dotfiles symbolic links
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/kitty
rm -rf ~/.config/alacritty ~/.config/btop ~/.config/fastfetch ~/.config/lf
rm -rf ~/.config/wlogout ~/.config/spicetify ~/.config/xava ~/.config/glava
rm -rf ~/.config/wal ~/.config/lvim
rm -f ~/.zshrc ~/.config/oh-my-posh.omp.json

# Restore from backup (replace with your backup directory)
BACKUP_DIR="$HOME/dotfiles-backup-YYYYMMDD-HHMMSS"
cp -r "$BACKUP_DIR"/* ~/
```

#### Selective Restoration

To restore only specific configurations:

```bash
# Example: Restore only terminal configuration
rm -rf ~/.config/kitty
cp -r "$BACKUP_DIR/kitty" ~/.config/

# Example: Restore shell configuration
rm -f ~/.zshrc
cp "$BACKUP_DIR/.zshrc" ~/
```

#### Emergency Recovery

If you encounter issues and need to quickly restore a working environment:

1. **Remove all dotfiles links**:
   ```bash
   find ~/.config -type l -delete  # Removes all symbolic links
   ```

2. **Restore essential configurations**:
   ```bash
   # Restore basic terminal functionality
   cp "$BACKUP_DIR/.zshrc" ~/ 2>/dev/null || echo 'export PATH=$PATH' > ~/.zshrc
   ```

3. **Restart your session** to ensure changes take effect

### Best Practices for Safe Installation

#### Before Installation
- **Always create backups** using the provided backup commands
- **Test with --dry-run** to understand the impact
- **Ensure you have a working terminal** available for recovery
- **Document your current setup** if you have custom configurations

#### During Installation
- **Start with --config-only** to test configuration setup
- **Use --dry-run first** with any new flag combinations
- **Monitor the output** for any error messages or warnings
- **Keep backup directory paths** noted for easy recovery

#### After Installation
- **Test basic functionality** before removing backups
- **Verify all applications launch correctly**
- **Check that custom keybindings work as expected**
- **Keep backups for at least a few days** until you're satisfied with the new setup

#### Additional Safety Measures

**Create a recovery script:**
```bash
#!/bin/bash
# Save as restore-backup.sh
BACKUP_DIR="$1"
if [ -z "$BACKUP_DIR" ]; then
    echo "Usage: $0 <backup-directory>"
    exit 1
fi

echo "Restoring from: $BACKUP_DIR"
# Add your specific restoration commands here
```

**Version control your customizations:**
If you plan to customize the dotfiles, consider forking the repository and tracking your changes with git.

**Test in a virtual machine:**
For maximum safety, test the installation in a virtual machine first to understand the complete process and impact.

## Configuration and Directory Structure

### Repository Structure Overview

This dotfiles collection is organized into application-specific directories, each containing complete configuration files for their respective applications. The structure follows standard Linux configuration conventions with clear separation between different components.

```
dotfiles/
├── hypr/                    # Hyprland window manager configuration
├── waybar/                  # Status bar configuration and themes
├── rofi/                    # Application launcher and menu system
├── kitty/                   # Kitty terminal emulator configuration
├── alacritty/               # Alacritty terminal emulator configuration
├── btop/                    # System monitor configuration and themes
├── fastfetch/               # System information display configuration
├── lf/                      # Terminal file manager configuration
├── wlogout/                 # Logout menu configuration
├── spicetify/               # Spotify theming configuration
├── xava/                    # Audio visualizer configuration
├── glava/                   # OpenGL audio visualizer configuration
├── wal/                     # Pywal theming templates
├── lvim/                    # LunarVim IDE configuration
├── .zshrc                   # Zsh shell configuration
├── oh-my-posh.omp.json      # Shell prompt theme configuration
└── install.nu               # Automated installation script
```

### Configuration Mapping

The installation script creates symbolic links from the repository to standard configuration locations:

#### ~/.config/ Directory Mappings
These configurations are linked to `~/.config/[application]/`:

- **hypr** → `~/.config/hypr/` - Hyprland window manager
- **waybar** → `~/.config/waybar/` - Status bar
- **rofi** → `~/.config/rofi/` - Application launcher
- **kitty** → `~/.config/kitty/` - Kitty terminal
- **alacritty** → `~/.config/alacritty/` - Alacritty terminal
- **btop** → `~/.config/btop/` - System monitor
- **fastfetch** → `~/.config/fastfetch/` - System information
- **lf** → `~/.config/lf/` - File manager
- **wlogout** → `~/.config/wlogout/` - Logout menu
- **spicetify** → `~/.config/spicetify/` - Spotify theming
- **xava** → `~/.config/xava/` - Audio visualizer
- **glava** → `~/.config/glava/` - OpenGL visualizer
- **wal** → `~/.config/wal/` - Pywal templates
- **lvim** → `~/.config/lvim/` - LunarVim IDE

#### Home Directory Mappings
These files are linked directly to the home directory:

- **.zshrc** → `~/.zshrc` - Zsh shell configuration
- **oh-my-posh.omp.json** → `~/.config/oh-my-posh.omp.json` - Prompt theme

### Major Configuration Directories

#### Hyprland Window Manager (`hypr/`)
The core window manager configuration with modular structure:

**Key Files:**
- `hyprland.conf` - Main configuration file that sources other components
- `hypridle.conf` - Idle daemon configuration for screen management
- `hyprlock.conf` - Screen locker configuration

**Subdirectories:**
- `configs/` - Core settings and keybindings
  - `Settings.conf` - Window manager behavior and appearance
  - `Keybinds.conf` - Keyboard shortcuts and bindings
- `UserConfigs/` - User-customizable settings
  - `Monitors.conf` - Display configuration (primary customization point)
  - `Startup_Apps.conf` - Applications to launch at startup
  - `UserKeybinds.conf` - Custom keyboard shortcuts
  - `UserSettings.conf` - Personal preferences
  - `WindowRules.conf` - Application-specific window behavior
- `scripts/` - System utility scripts
- `UserScripts/` - User-customizable scripts for wallpapers, themes, etc.

#### Waybar Status Bar (`waybar/`)
Highly customizable status bar with multiple themes:

**Key Files:**
- `config.jsonc` - Main configuration defining modules and layout
- `style.css` - Current active styling
- `colors.css` - Color definitions for theming

**Subdirectories:**
- `style/` - Multiple pre-configured themes
  - `catppuccin/` - Catppuccin color scheme theme
  - `blur-pywal/` - Pywal integration with blur effects
  - `overlay/` - Overlay-style theme
  - Additional theme variants for different preferences
- `scripts/` - Custom modules and functionality scripts

#### Rofi Application Launcher (`rofi/`)
Comprehensive launcher and menu system:

**Key Files:**
- `config.rasi` - Main configuration file
- `master-config.rasi` - Base theme definitions

**Subdirectories:**
- `shared/` - Common theme components
  - `colors.rasi` - Color definitions
  - `fonts.rasi` - Font configurations
- `resolution/` - Resolution-specific configurations
  - `1080p/` - Full HD optimized settings
  - `1440p/` - QHD optimized settings

**Specialized Configurations:**
- `config-calc.rasi` - Calculator interface
- `config-emoji.rasi` - Emoji picker
- `config-wallpaper.rasi` - Wallpaper selector
- `config-powermenu.rasi` - Power management menu

#### Terminal Configurations

**Kitty Terminal (`kitty/`):**
- `kitty.conf` - Main configuration file
- `current-theme.conf` - Active color theme
- Multiple theme files for different color schemes
- `open-actions.conf` - File handling configuration

**Alacritty Terminal (`alacritty/`):**
- Lightweight alternative terminal configuration
- Optimized for performance and simplicity

#### System Monitoring and Information

**Btop System Monitor (`btop/`):**
- `btop.conf` - Main configuration file
- `themes/` - Color themes including Catppuccin variants

**Fastfetch System Info (`fastfetch/`):**
- `config.jsonc` - Display configuration
- `ascii.txt` - Custom ASCII art for system info display

#### Audio Visualizers

**Xava (`xava/`):**
- `config` - Main configuration file
- `gl/` - OpenGL shader configurations for visual effects

**GLava (`glava/`):**
- Multiple shader files for different visualization modes
- `bars.glsl`, `circle.glsl`, `wave.glsl` - Different visualization types
- Environment-specific configurations for various window managers

#### Development Environment

**LunarVim (`lvim/`):**
- `config.lua` - Main Neovim configuration
- `statusline.lua` - Custom status line configuration
- `lazy-lock.json` - Plugin version lock file

### Main Configuration Entry Points

For customization, focus on these key files:

#### Essential Customization Files
1. **Monitor Setup**: `hypr/UserConfigs/Monitors.conf`
   - Configure display resolution, position, and scaling
   - Primary file for multi-monitor setups

2. **Startup Applications**: `hypr/UserConfigs/Startup_Apps.conf`
   - Define which applications launch automatically
   - Configure autostart behavior

3. **Personal Keybindings**: `hypr/UserConfigs/UserKeybinds.conf`
   - Add custom keyboard shortcuts
   - Override default keybindings

4. **Waybar Layout**: `waybar/config.jsonc`
   - Customize status bar modules and layout
   - Configure system information display

5. **Terminal Preferences**: `kitty/kitty.conf`
   - Font, size, and appearance settings
   - Terminal behavior configuration

#### Theme Customization Points
1. **Waybar Themes**: Switch between themes in `waybar/style/`
2. **Rofi Themes**: Modify appearance through files in `rofi/`
3. **Terminal Themes**: Multiple color schemes available in `kitty/`
4. **Pywal Templates**: Custom theming templates in `wal/templates/`

#### Script Customization
1. **User Scripts**: `hypr/UserScripts/` - Custom automation scripts
2. **Waybar Scripts**: `waybar/scripts/` - Status bar functionality
3. **System Scripts**: `hypr/scripts/` - Core system functionality

### Configuration Dependencies

The configurations are designed to work together as a cohesive system:

- **Hyprland** serves as the foundation, managing windows and launching other components
- **Waybar** integrates with Hyprland for workspace and window information
- **Rofi** uses Hyprland's focus system for application launching
- **Pywal/Pywal16** generates color schemes used across all applications
- **Terminal configurations** inherit colors from the pywal theming system

This interconnected design ensures visual consistency and functional integration across all components of the desktop environment.

## Post-Installation Setup

1. **Restart your session** or reboot
2. **Initialize theming**: `wal --theme base16-default-dark`
3. **Configure monitors**: Edit `~/.config/hypr/UserConfigs/Monitors.conf`
4. **Reload Hyprland**: `hyprctl reload`

### Theming

Generate themes from wallpapers:
```bash
# Set wallpaper and generate theme
wal -i /path/to/wallpaper.jpg

# Use wallpaper selector script
~/.config/hypr/UserScripts/WallpaperSelect.sh
```

### Customization

1. **Edit monitor configuration**:
   ```bash
   nano ~/.config/hypr/UserConfigs/Monitors.conf
   ```

2. **Common adjustments**:
   - Resolution and refresh rate
   - Monitor positioning for multi-monitor setups
   - Scaling for high-DPI displays
   - Monitor-specific workspace assignments

3. **Apply changes**: Reload Hyprland configuration:
   ```bash
   hyprctl reload
   ```

#### Startup Applications
**Customize which applications launch automatically**:

1. **Edit startup configuration**:
   ```bash
   nano ~/.config/hypr/UserConfigs/Startup_Apps.conf
   ```

2. **Add custom applications**:
   ```bash
   exec-once = your-application &
   ```

3. **Disable unwanted applications**: Comment out lines with `#`

#### Keybinding Customization
**Add or modify keyboard shortcuts**:

1. **Edit user keybindings**:
   ```bash
   nano ~/.config/hypr/UserConfigs/UserKeybinds.conf
   ```

2. **Add custom bindings**:
   ```bash
   bind = SUPER, T, exec, kitty
   bind = SUPER SHIFT, S, exec, grim -g "$(slurp)"
   ```

#### Waybar Customization
**Modify status bar appearance and modules**:

1. **Edit Waybar configuration**:
   ```bash
   nano ~/.config/waybar/config.jsonc
   ```

2. **Switch between themes**:
   ```bash
   ~/.config/hypr/scripts/WaybarStyles.sh
   ```

3. **Customize modules**: Add or remove system information displays

### Script Usage and Automation

The configuration includes numerous utility scripts for common tasks:

#### Wallpaper Management
```bash
# Interactive wallpaper selector
~/.config/hypr/UserScripts/WallpaperSelect.sh

# Random wallpaper with auto-change
~/.config/hypr/UserScripts/WallpaperAutoChange.sh

# Apply effects to current wallpaper
~/.config/hypr/UserScripts/WallpaperEffects.sh
```

#### System Management
```bash
# Refresh all components
~/.config/hypr/scripts/Refresh.sh

# Toggle game mode (disable effects for performance)
~/.config/hypr/scripts/GameMode.sh

# Brightness control
~/.config/hypr/scripts/Brightness.sh

# Volume control
~/.config/hypr/scripts/Volume.sh
```

#### Theme and Appearance
```bash
# Switch Waybar styles
~/.config/hypr/scripts/WaybarStyles.sh

# Toggle dark/light mode
~/.config/hypr/scripts/DarkLight.sh

# Change keyboard layout
~/.config/hypr/scripts/SwitchKeyboardLayout.sh
```

#### Quick Access Menus
```bash
# Application launcher
rofi -show drun

# Emoji picker
~/.config/hypr/scripts/RofiEmoji.sh

# Calculator
~/.config/hypr/scripts/RofiCalc.sh

# Power menu
~/.config/waybar/scripts/power-menu/powermenu.sh
```

## Troubleshooting

### Common Issues

**AUR Helper Missing:**
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

**Script Permission Errors:**
```bash
find ~/.config/hypr -name "*.sh" -exec chmod +x {} \;
find ~/.config/waybar -name "*.sh" -exec chmod +x {} \;
```

**Theming Not Working:**
```bash
wal --theme base16-default-dark
~/.config/hypr/scripts/Refresh.sh
```

**Monitor Issues:**
```bash
hyprctl monitors
nano ~/.config/hypr/UserConfigs/Monitors.conf
hyprctl reload
```
## License

This project is open source. Feel free to fork and customize for your needs.
