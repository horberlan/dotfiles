
export PATH="$HOME/.cargo/bin:$PATH"

export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NVM_DIR="$HOME/.nvm"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/go/bin"

export MOZ_ENABLE_WAYLAND=1

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

eval "$(zoxide init zsh)"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"


cd() {
  if [ -n "$1" ]; then
    builtin cd "$1" && lsd
  else
    builtin cd "$HOME"
  fi
}

icat() {
  kitty +kitten icat "$1"
}

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

ssh_kitty() {
  local ip=$1
  [[ -z "$ip" ]] && ip=$IP_PI

  if [[ "$TERM" == "xterm-kitty" ]]; then
    kitty +kitten ssh -t "$ip"
  else
    ssh -t "$ip"
  fi
}

# Azure Functions CLI wrapper
func() {
  local func_path="$HOME/Workspace/bernoulli/azure-functions-cli/func"

  [[ ! -x "$func_path" ]] && return 1

  "$func_path" "$@" --script-root "$PWD"
}


alias nf='nerdfetch'
alias spotify='spotify --disable-accelerated-video-decode'
alias zen='flatpak run app.zen_browser.zen'
alias chromium='chromium --disable-accelerated-video-decode'
alias peek='GDK_BACKEND=x11 peek'

alias unmuted='amixer -c1 sset Headphone unmute; amixer -c1 sset Speaker unmute'

alias tn='track_yt_command "track-next"'
alias tp='track_yt_command "track-pause"'
alias tpre='track_yt_command "track-previous"'

alias c="clear"
alias v="lvim"
alias cat="bat"
alias shell="exec $SHELL -l"
alias fk="sudo !!"

alias mv="mv -i"
alias rm="rm -Iv"

alias df="df -h"
alias du="du -h -d 1"

alias k="killall"

alias l="lsd -lh --color=auto --group-directories-first"
alias ls="lsd -h --color=auto --group-directories-first"
alias la="lsd -lah --color=auto --group-directories-first"

alias grep="grep --color=auto"
alias p="ps aux | grep $1"


hyprctl setcursor "Bibata-Modern-Ice" 18 > /dev/null

HISTFILE="$HOME/.zhistory"
eval "$(oh-my-posh init zsh --config "$HOME/.cache/wal/oh-my-posh-pywal.omp.json")"