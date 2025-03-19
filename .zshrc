# Start a tmux session or reattach to an existing session
if [ "$PS1" != "" -a -z "$TMUX" -a "${SSH_TTY:-x}" != x ]; then
  WHOAMI=$(whoami)
  ( (tmux has-session -t $WHOAMI && tmux attach-session -t $WHOAMI) || (tmux new-session -s $WHOAMI) ) && exit 0
fi

# Display Fastfetch only once
if [ -x "$(command -v fastfetch)" -a  -z "$_motd_listed" ]; then
  case "$TMUX_PANE" in
    %0) fastfetch
        export _motd_listed=yes
        ;;
    *)  ;;
  esac
fi

#######################################################
# Zinit
#######################################################

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

#######################################################
# Keybinds
#######################################################

# Add oh-my-zsh style key bindings.
zinit ice depth=1; zinit load "NickKaramoff/ohmyzsh-key-bindings"

#######################################################
# Plugin Settings
#######################################################

#######################################################
# Plugins
#######################################################

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light sunlei/zsh-ssh

#######################################################
# Snippets
#######################################################

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::nvm

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Initialize oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/powerlevel10k.omp.json)"

#######################################################
# History
#######################################################

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

#######################################################
# Aliases
#######################################################

alias sudo='sudo '
alias c='clear'
alias q='exit'
alias h='history'
alias la='ls -lAFh --color --group-directories-first'  # long list, show almost all, show type, human readable

# Directory navigation
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mv='mv -i'         # Interactive move with confirmation
alias rm='rm -i'         # Interactive remove with confirmation
alias cp='cp -i'         # Interactive copy with confirmation
alias mkdir='mkdir -pv'  # Always make parents and verbose

alias genv='printenv | grep -i'      # Search for an environment variable
alias now='date +"%T"'               # Current time
alias nowd='date +"%m-%d-%Y"'        # Current date
alias fastping='ping -c 100 -i 0.2'  # Fast ping with 100 packets with 0.2 second intervals

alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file
alias showhosts="sed -rn 's/^\s*Host\s+(.*)\s*/\1/ip' ~/.ssh/config"
alias df="df -Th | grep -Ev '(udev|tmpfs)'"

# Alias for neovim
if [[ -x "$(command -v nvim)" ]]; then
  alias vi='nvim'
  alias vim='nvim'
  alias svi='sudo nvim'
  export EDITOR=nvim
  export VISUAL=$EDITOR
elif [[ -x "$(command -v vim)" ]]; then
  alias vi='vim'
  alias svi='sudo vim'
  export EDITOR=vim
  export VISUAL=$EDITOR
fi

# Check for VSCode and set VISUAL
if [[ -x "$(command -v code)" ]]; then
  export VISUAL=code
fi

# Alias For bat
# Link: https://github.com/sharkdp/bat
if [[ -x "$(command -v bat)" ]]; then
  alias cat='bat'
elif [[ -x "$(command -v batcat)" ]]; then  # batcat on Ubuntu
  alias cat='batcat'
fi

# Get local IP addresses
if [[ -x "$(command -v ip)" ]]; then
  alias iplocal="ip -br -c a"
else
  alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
fi

# Get public IP addresses
if [[ -x "$(command -v curl)" ]]; then
  alias ipexternal="curl -s ifconfig.me && echo"
elif [[ -x "$(command -v wget)" ]]; then
  alias ipexternal="wget -qO- ifconfig.me && echo"
fi

#######################################################
# Functions
#######################################################

# Flush DNS cache
# sudo nmcli general reload dns-full   # Arch
# resolvectl flush-caches              # Ubuntu
# sudo systemd-resolve --flush-caches  # Older Ubuntu
flush-dns() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    if [[ -f /etc/os-release ]]; then
      source /etc/os-release
      if [[ "$ID" == "arch" || "$ID_LIKE" == "arch" ]]; then
        nmcli general reload dns-full
      elif [[ "$ID" == "ubuntu" || "$ID_LIKE" == "debian" ]]; then
        resolvectl flush-caches
      else
        echo "Unsupported Linux distribution. Please manually flush DNS cache."
      fi
    else
      echo "Unsupported OS. Please manually flush DNS cache."
    fi
  else
    echo "This alias is only supported on Linux."
  fi
}

# Copy file with a progress bar
function cpp() {
  if [[ -x "$(command -v rsync)" ]]; then
    # rsync -avh --progress "${1}" "${2}"
    rsync -ah --info=progress2 "${1}" "${2}"
  else
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
    count += $NF
    if (count % 10 == 0) {
      percent = count / total_size * 100
      printf "%3d%% [", percent
      for (i=0;i<=percent;i++)
        printf "="
        printf ">"
        for (i=percent;i<100;i++)
          printf " "
          printf "]\r"
        }
      }
    END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
  fi
}

# Copy and go to the directory
function cpg() {
  if [[ -d "$2" ]];then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

# Move and go to the directory
function mvg() {
  if [[ -d "$2" ]];then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Create and go to the directory
function mkdirg() {
  mkdir -p "$@" && cd "$@"
}

# YouTubeDL
function ytdl() {
  url="${1}"
  audio_only=""
  shift 1

  if [[ "${1}" == "-a" ]]; then
    audio_only="-a"
    shift 1
  fi

  extra=("$@")

  if [[ "$audio_only" == "-a" ]]; then
    yt-dlp "$url" "${extra[@]}" --windows-filenames --embed-thumbnail --embed-subs --audio-quality 0 --extract-audio --audio-format mp3
  else
    yt-dlp "$url" "${extra[@]}" --windows-filenames --sponsorblock-mark all --embed-thumbnail --embed-subs -f bestvideo+bestaudio --embed-chapters --remux-video mkv
  fi
}

#######################################################
# Add Common Binary Directories to Path
#######################################################

# Add directories to the end of the path if they exist and are not already in the path
# Link: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
function pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

# Add directories to the beginning of the path if they exist and are not already in the path
function pathprepend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

# Add the most common personal binary paths located inside the home folder
# (these directories are only added if they exist)
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin"

#######################################################
# NVM
#######################################################

# nvm-auto-switch
# Uses .nvmrc to automatically switch the node version
auto-switch-node-version() {
  NVMRC_PATH=$(nvm_find_nvmrc)
  CURRENT_NODE_VERSION=$(nvm version)

  if [[ ! -z "$NVMRC_PATH" ]]; then
    # .nvmrc file found!

    # Read the file
    REQUESTED_NODE_VERSION=$(cat $NVMRC_PATH)

    # Find an installed Node version that satisfies the .nvmrc
    MATCHED_NODE_VERSION=$(nvm_match_version $REQUESTED_NODE_VERSION)

    if [[ ! -z "$MATCHED_NODE_VERSION" && $MATCHED_NODE_VERSION != "N/A" ]]; then
      # A suitable version is already installed.

      # Clear any warning suppression
      unset AUTOSWITCH_NODE_SUPPRESS_WARNING

      # Switch to the matched version ONLY if necessary
      if [[ $CURRENT_NODE_VERSION != $MATCHED_NODE_VERSION ]]; then
        nvm use $REQUESTED_NODE_VERSION
      fi
    else
      # No installed Node version satisfies the .nvmrc.

      # Quit silently if we already just warned about this exact .nvmrc file, so you
      # only get spammed once while navigating around within a single project.
      if [[ $AUTOSWITCH_NODE_SUPPRESS_WARNING == $NVMRC_PATH ]]; then
        return
      fi

      # Convert the .nvmrc path to a relative one (if possible) for readability
      RELATIVE_NVMRC_PATH="$(realpath --relative-to=$(pwd) $NVMRC_PATH 2> /dev/null || echo $NVMRC_PATH)"

      # Print a clear warning message
      echo ""
      echo "WARNING"
      echo "  Found file: $RELATIVE_NVMRC_PATH"
      echo "  specifying: $REQUESTED_NODE_VERSION"
      echo "  ...but no installed Node version satisfies this."
      echo "  "
      echo "  Current node version: $CURRENT_NODE_VERSION"
      echo "  "
      echo "  You might want to run \"nvm install\""

      # Record that we already warned about this unsatisfiable .nvmrc file
      export AUTOSWITCH_NODE_SUPPRESS_WARNING=$NVMRC_PATH
    fi
  else
    # No .nvmrc file found.

    # Clear any warning suppression
    unset AUTOSWITCH_NODE_SUPPRESS_WARNING

    # Revert to default version, unless that's already the current version.
    if [[ $CURRENT_NODE_VERSION != $(nvm version default)  ]]; then
      nvm use default
    fi
  fi
}

# Run auto-switch-node-version whenever you change directory
if [[ -x "$(command -v nvm)" ]]; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd auto-switch-node-version
  auto-switch-node-version
fi
