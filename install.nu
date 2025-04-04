if (which pacman | is-empty) {
    error make {msg: "This script requires Arch Linux and pacman"}
}

let installable = (ls --mime-type | where type == "dir")

let packages = (
    $installable 
    | get name 
    | each {|dir| if $dir == "hypr" { "hyprland" } else { $dir } }
    | where {|pkg| 
        do -i { pacman -Ss $pkg } | complete | $in.exit_code == 0
    }
)

let aur_packages = ["spicetify"]

let official = ($packages | where {|p| $p not-in $aur_packages })
let aur = ($packages | where {|p| $p in $aur_packages })

if ($official | length) > 0 {
    sudo pacman -S --needed --noconfirm ...$official
}

if ($aur | length) > 0 {
    if (which yay | is-not-empty) {
        yay -S --needed --noconfirm ...$aur
    } else if (which paru | is-not-empty) {
        paru -S --needed --noconfirm ...$aur
    } else {
        print $"(ansi yellow)⚠️ AUR packages skipped (install yay/paru): ($aur)(ansi reset)"
    }
}

let missing = (
    $installable.name 
    | where {|p| 
        let mapped = (if $p == "hypr" { "hyprland" } else { $p })
        $mapped not-in $packages and $mapped not-in $aur_packages
    }
)

if ($missing | length) > 0 {
    print $"(ansi yellow)⚠️ Directories without matching packages: ($missing)(ansi reset)"
}