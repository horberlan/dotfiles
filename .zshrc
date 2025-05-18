
# Use powerline
USE_POWERLINE="true"
HAS_WIDECHARS="false"

plugins=(z zsh-autosuggestions)

export ANDROID_HOME=/$HOME/Android/Sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
# export PATH=$PATH:~/.cargo/bin/
export PATH="$HOME/.cargo/bin:$PATH"
# pnpm
export PNPM_HOME="/home/poisnada/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
  eval "$(oh-my-posh init zsh --config "$HOME/oh-my-posh.omp.json")"
fi

#load env to run tte
alias lff="sh ~/.config/lf/lf-run.sh"

# get_joke() {
#   local response=$(curl --silent --location 'https://official-joke-api.appspot.com/random_joke')
#   local setup=$(echo "$response" | jq -r '.setup')
#   local punchLine=$(echo "$response" | jq -r '.punchline')

#   echo "$setup" | tte rain
#   echo "... $punchLine" | tte print
# }

history_file="$HOME/.zhistory"

# here has a conditional log: if `start_of_day` == true (first zsh shell of the day), run a figlet ASCII and tte (https://github.com/ChrisBuilds/terminaltexteffects), otherwise run a simple joke to make it more happy

# if [ -f "$history_file" ]; then
#   last_modified=$(stat -c %Y "$history_file")
#   today=$(date +%s)
#   start_of_day=$(date -d 'today 00:00:00' +%s)

#   if [ "$last_modified" -lt "$start_of_day" ]; then
#    figlet -f /usr/share/figlet/fonts/bolger "Welcome, $USER" | tte burn && clear &
#     disown

#   else
#     get_joke & disown
#   fi
# else
#   echo "history file not found."
# fi
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

alias ll="ls -lha"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# pyenv activate envname

# source $HOME/envname/bin/activate # to be productive :)
# eval "$(pyenv init -)"

# track_yt_command() {
#   local command=$1
#   response=$(curl --request POST \
#     --url http://localhost:9863/query \
#     --header 'Authorization: Bearer QHF9L' \
#     --header 'Content-Type: application/json' \
#     --header 'User-Agent: insomnia/10.0.0' \
#     --data "{ \"command\": \"$command\" }" 2>/dev/null)

#   if [ $? -ne 0 ]; then
#     echo "Curl request failed. Starting youtube-music-desktop-app..."
#     youtube-music-desktop-app >/dev/null 2>&1 &
#     disown
#   else
#     echo "POST request succeeded."
#   fi
# }

alias tn='track_yt_command "track-next"'
alias tp='track_yt_command "track-pause"' # toggle
alias tpre='track_yt_command "track-previous"'
alias ls="lsd"
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh)"

cd() {
  if [ -n "$1" ]; then
    builtin cd "$1" && ls
  else
    builtin cd $HOME
  fi
}

# bun completions
[ -s "/home/poisnada/.bun/_bun" ] && source "/home/poisnada/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

icat() {
  kitty +kitten icat "$1"
}


alias unmuted="amixer -c1 sset Headphone unmute; amixer -c1 sset Speaker unmute"
# unmuted

alias chromium="chromium --disable-accelerated-video-decode"
alias peek="GDK_BACKEND=x11 peek"
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



#py-env
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

#asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export PATH=$PATH:/home/poisnada/.spicetify
export PATH="$PATH:$HOME/go/bin"

alias c="clear"
alias v="nvim"
alias f="fff"
alias cat="bat"
alias l="lsd -lh --color=auto --group-directories-first"
alias ls="lsd -h --color=auto --group-directories-first"
alias la="lsd -lah --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias shell="exec $SHELL -l"
alias fk="sudo !!"
alias mv="mv -i"
alias rm="rm -Iv"
alias df="df -h"
alias du="du -h -d 1"
alias k="killall"
alias p="ps aux | grep $1"
alias nf='nerdfetch'
