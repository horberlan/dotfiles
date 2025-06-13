# ------------------------------------------------------------------------------
# SECTION: Environment Variables & Path
# ------------------------------------------------------------------------------
# Set the home directory for Zsh files
export ZDOTDIR="$HOME"

# Add Cargo (Rust) to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PNPM_HOME:$PATH"
fi

# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Node.js (nvm)
export NVM_DIR="$HOME/.nvm"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# ------------------------------------------------------------------------------
# SECTION: Shell Options & Plugins
# ------------------------------------------------------------------------------
# Powerline Settings
USE_POWERLINE="true"
HAS_WIDECHARS="false"

# Zsh plugins
plugins=(
    z
    zsh-autosuggestions
    zoxide
    git-auto-fetch
    zsh-interactive-cd
    colorize
    fzf
    colored-man-pages
    colored
)

# ------------------------------------------------------------------------------
# SECTION: Functions
# ------------------------------------------------------------------------------
# Enhanced cd: list contents after changing directory
cd() {
  if [ -n "$1" ]; then
    builtin cd "$1" && lsd
  else
    builtin cd "$HOME"
  fi
}

# Kitty: display images in the terminal
icat() {
  kitty +kitten icat "$1"
}

# fzf: fuzzy find over git diff
fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# Kitty: SSH wrapper
ssh_kitty() {
  local ip=$1
  if [ -z "$1" ]; then
    ip=$IP_PI
  fi

  if [ "$TERM" = "xterm-kitty" ]; then
    kitty +kitten ssh -t $ip
  else
    ssh -t $ip
  fi
}

# track_yt_command() {
#   local command=$1
#   response=$(curl --request POST \
#     --url http://localhost:9863/query \
#     --header 'Authorization: Bearer QHF9L' \
#     --header 'Content-Type: application/json' \
#     --header 'User-Agent: insomnia/10.0.0' \
#     --data "{ \"command\": \"$command\" }" 2>/dev/null)
#
#   if [ $? -ne 0 ]; then
#     echo "Curl request failed. Starting youtube-music-desktop-app..."
#     youtube-music-desktop-app >/dev/null 2>&1 &
#     disown
#   else
#     echo "POST request succeeded."
#   fi
# }


# ------------------------------------------------------------------------------
# SECTION: Initializations
# ------------------------------------------------------------------------------
# Manjaro-specific configurations
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
    source /usr/share/zsh/manjaro-zsh-config
fi
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
    source /usr/share/zsh/manjaro-zsh-prompt
    eval "$(oh-my-posh init zsh --config "$HOME/oh-my-posh.omp.json")"
fi

# Load nvm (Node Version Manager)
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
    . "$NVM_DIR/bash_completion"
fi

# Initialize pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Initialize zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Load bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Set Hyprland cursor
hyprctl setcursor "Bibata-Modern-Ice" 18 > /dev/null

function ssh_kitty () {
  local ip=$1

  if [ -z "$1" ]; then
    ip=$IP_PI
  fi

  if [ "$TERM" = "xterm-kitty" ]; then
    kitty +kitten ssh -t $ip
  else
    ssh -t $ip
  fi
}
# export PATH=/home/poisnada/.meteor:$PATH
export MOZ_ENABLE_WAYLAND=1



# Path Management
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$PATH:/home/poisnada/.spicetify"
export PATH="$PATH:$HOME/go/bin"

# Python (pyenv)
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# ------------------------------------------------------------------------------
# SECTION: Aliases
# ------------------------------------------------------------------------------

# Applications & UI
alias nf='nerdfetch'
alias spotify='spotify --disable-accelerated-video-decode'
alias zen='flatpak run app.zen_browser.zen'
alias chromium='chromium --disable-accelerated-video-decode'
alias peek='GDK_BACKEND=x11 peek'
alias unmuted='amixer -c1 sset Headphone unmute; amixer -c1 sset Speaker unmute'

# Custom Commands (requires functions below)
alias tn='track_yt_command "track-next"'
alias tp='track_yt_command "track-pause"' # toggle
alias tpre='track_yt_command "track-previous"'

# General
alias c="clear"
alias v="lvim"
alias cat="bat"
alias shell="exec $SHELL -l"
alias fk="sudo !!"

# File Management
alias mv="mv -i"
alias rm="rm -Iv"
alias df="df -h"
alias du="du -h -d 1"
alias k="killall"

# Listing
alias l="lsd -lh --color=auto --group-directories-first"
alias ls="lsd -h --color=auto --group-directories-first"
alias la="lsd -lah --color=auto --group-directories-first"

# Search
alias grep="grep --color=auto"
alias p="ps aux | grep $1"

