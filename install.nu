#!/usr/bin/env nu

# Arch Linux Dotfiles Installer
# Professional installer for Arch Linux configuration files and packages

const OFFICIAL_PACKAGES = [
    "hyprland", "waybar", "rofi", "kitty", "alacritty", 
    "btop", "fastfetch", "lf", "wlogout", "hypridle", 
    "hyprlock", "pywal", "swww", "grim", "slurp", 
    "wl-clipboard", "brightnessctl", "pamixer", "playerctl",
    "polkit-kde-agent", "xdg-desktop-portal-hyprland",
    "noto-fonts", "noto-fonts-emoji", "ttf-jetbrains-mono-nerd"
]

const AUR_PACKAGES = [
    "spicetify-cli", "lunarvim-git", "oh-my-posh-bin", 
    "pywal16", "xava", "glava"
]

const CARGO_PACKAGES = [
    "anny-dock"
]

const CONFIG_MAPPINGS = [
    {src: "hypr", dest: "hypr"},
    {src: "waybar", dest: "waybar"},
    {src: "rofi", dest: "rofi"},
    {src: "kitty", dest: "kitty"},
    {src: "alacritty", dest: "alacritty"},
    {src: "btop", dest: "btop"},
    {src: "fastfetch", dest: "fastfetch"},
    {src: "lf", dest: "lf"},
    {src: "wlogout", dest: "wlogout"},
    {src: "spicetify", dest: "spicetify"},
    {src: "xava", dest: "xava"},
    {src: "glava", dest: "glava"},
    {src: "wal", dest: "wal"},
    {src: "lvim", dest: "lvim"}
]

const HOME_MAPPINGS = [
    {src: ".zshrc", dest: ".zshrc"},
    {src: "oh-my-posh.omp.json", dest: ".config/oh-my-posh.omp.json"}
]

const SCRIPT_DIRECTORIES = ["hypr/scripts", "hypr/UserScripts", "waybar/scripts"]

def main [
    --dry-run (-d): bool = false,
    --force (-f): bool = false,
    --skip-packages (-s): bool = false,
    --config-only (-c): bool = false
] {
    validate_environment
    
    let config = {
        dry_run: $dry_run,
        force: $force,
        skip_packages: $skip_packages,
        config_only: $config_only,
        dotfiles_root: (pwd),
        config_dir: $"($env.HOME)/.config"
    }
    
    print "Starting Arch Linux dotfiles installation..."
    
    if not $config.config_only {
        install_system_packages $config
    }
    
    setup_configuration $config
    set_script_permissions $config
    
    print_completion_notes
}

def validate_environment [] {
    if (which pacman | is-empty) {
        error make {msg: "This installer requires Arch Linux with pacman"}
    }
}

def install_system_packages [config: record] {
    if $config.skip_packages {
        print "Skipping package installation"
        return
    }
    
    print "Installing system packages..."
    install_official_packages $config
    install_aur_packages $config
}

def install_official_packages [config: record] {
    let missing_packages = get_missing_packages $OFFICIAL_PACKAGES "pacman"
    
    if ($missing_packages | is-empty) {
        print "All official packages are already installed"
        return
    }
    
    print $"Installing official packages: ($missing_packages | str join ', ')"
    
    if not $config.dry_run {
        sudo pacman -S --needed --noconfirm ...$missing_packages
    }
}

def install_aur_packages [config: record] {
    let aur_helper = detect_aur_helper
    
    if $aur_helper == null {
        print $"Warning: No AUR helper found. Please install yay or paru to install: ($AUR_PACKAGES | str join ', ')"
        return
    }
    
    let missing_packages = get_missing_packages $AUR_PACKAGES $aur_helper
    
    if ($missing_packages | is-empty) {
        print "All AUR packages are already installed"
        return
    }
    
    print $"Installing AUR packages with ($aur_helper): ($missing_packages | str join ', ')"
    
    if not $config.dry_run {
        ^$aur_helper -S --needed --noconfirm ...$missing_packages
    }
}

def get_missing_packages [packages: list<string>, manager: string] -> list<string> {
    $packages | where {|pkg| 
        let result = if $manager == "pacman" {
            pacman -Qi $pkg | complete
        } else {
            do -i { ^$manager -Qi $pkg } | complete
        }
        $result.exit_code != 0
    }
}

def detect_aur_helper [] -> string {
    if (which yay | is-not-empty) {
        return "yay"
    } else if (which paru | is-not-empty) {
        return "paru"
    }
    null
}

def setup_configuration [config: record] {
    print "Setting up configuration files..."
    
    ensure_config_directory $config
    create_config_symlinks $config
    create_home_symlinks $config
}

def ensure_config_directory [config: record] {
    if not ($config.config_dir | path exists) {
        if not $config.dry_run {
            mkdir $config.config_dir
        }
        print $"Created configuration directory: ($config.config_dir)"
    }
}

def create_config_symlinks [config: record] {
    for mapping in $CONFIG_MAPPINGS {
        let src_path = $"($config.dotfiles_root)/($mapping.src)"
        let dest_path = $"($config.config_dir)/($mapping.dest)"
        
        create_symlink $src_path $dest_path $config
    }
}

def create_home_symlinks [config: record] {
    for mapping in $HOME_MAPPINGS {
        let src_path = $"($config.dotfiles_root)/($mapping.src)"
        let dest_path = $"($env.HOME)/($mapping.dest)"
        
        create_symlink $src_path $dest_path $config
    }
}

def create_symlink [src: string, dest: string, config: record] {
    if not ($src | path exists) {
        print $"Warning: Source file not found: ($src)"
        return
    }
    
    if ($dest | path exists) {
        if $config.force {
            if not $config.dry_run {
                rm -rf $dest
            }
            print $"Removed existing file: ($dest)"
        } else {
            print $"File already exists (use --force to overwrite): ($dest)"
            return
        }
    }
    
    let parent_dir = ($dest | path dirname)
    if not ($parent_dir | path exists) and not $config.dry_run {
        mkdir $parent_dir
    }
    
    if not $config.dry_run {
        ln -sf $src $dest
    }
    
    print $"Linked: ($src) -> ($dest)"
}

def set_script_permissions [config: record] {
    if $config.dry_run {
        return
    }
    
    for dir in $SCRIPT_DIRECTORIES {
        let script_path = $"($config.dotfiles_root)/($dir)"
        
        if ($script_path | path exists) {
            chmod +x $"($script_path)/*.sh"
            print $"Set executable permissions for scripts in ($dir)"
        }
    }
}

def print_completion_notes [] {
    print "\nInstallation completed successfully!"
    print "\nPost-installation steps:"
    print "  • Restart your session or reboot your system"
    print "  • Initialize pywal: wal --theme base16-default-dark"
    print "  • Configure monitors in hypr/UserConfigs/Monitors.conf"
}