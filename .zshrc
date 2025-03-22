# Start a tmux session or reattach to an existing session
if [[ -n "$PS1" && -z "$TMUX" && -n "$SSH_TTY" ]]; then
  (tmux has-session -t $USER && tmux attach-session -t $USER) || tmux new-session -s $USER && exit 0
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

# Download Zinit, if it's not installed yet
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
# Environemt Variables
#######################################################

# Set directories
local -r cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
local -r config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# Lazy load NVM
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=true

# fzf configuration
if [[ -x "$(command -v fzf)" ]]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	  --info=inline-right \
	  --ansi \
	  --layout=reverse \
	  --border=rounded \
	  --color=border:#27a1b9 \
	  --color=fg:#c0caf5 \
	  --color=gutter:#16161e \
	  --color=header:#ff9e64 \
	  --color=hl+:#2ac3de \
	  --color=hl:#2ac3de \
	  --color=info:#545c7e \
	  --color=marker:#ff007c \
	  --color=pointer:#ff007c \
	  --color=prompt:#2ac3de \
	  --color=query:#c0caf5:regular \
	  --color=scrollbar:#27a1b9 \
	  --color=separator:#ff9e64 \
	  --color=spinner:#ff007c \
	"
fi

#######################################################
# Plugins
#######################################################

# Load completions before plugins to avoid reinitializing
autoload -Uz compinit && compinit

zinit light lukechilds/zsh-nvm
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light sunlei/zsh-ssh
zinit light Aloxaf/fzf-tab

#######################################################
# Snippets
#######################################################

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# Cache oh-my-posh init to avoid recomputation
local -r omp_cache=$cache_dir/oh-my-posh-init.zsh
local -r omp_config=$config_dir/ohmyposh/powerlevel10k.omp.json
if [[ ! -f $omp_cache || ! -f $omp_config || $omp_config -nt $omp_cache ||
      $(which oh-my-posh) -nt $omp_cache ]]; then
  mkdir -p ~/.cache
  oh-my-posh init zsh --config $omp_config > $omp_cache
fi
source $omp_cache

#######################################################
# Plugin Configuration
#######################################################

# Completion styling
# zstyle ':completion:*' use-cache true
# zstyle ':completion:*' cache-path $cache_dir/zsh/.zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
if [[ -x "$(command -v fzf)" ]]; then
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes
fi

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

#######################################################
# Aliases and Functions
#######################################################

if [[ -f ~/.zsh_aliases ]]; then
  source ~/.zsh_aliases
fi

#######################################################
# Shell integrations
#######################################################

# Set up fzf key bindings and fuzzy completion
if [[ -x "$(command -v fzf)" ]]; then
  source <(fzf --zsh)
fi
