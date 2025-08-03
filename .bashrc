# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Start a tmux session or reattach to an existing session
if [[ -x "$(command -v tmux)" && -n "$PS1" && -z "$TMUX" && -n "$SSH_TTY" ]]; then
  (tmux has-session -t $USER && tmux attach-session -t $USER) || tmux new-session -s $USER && exit 0
fi

# Display Fastfetch in Tmux only once
if [[ -x "$(command -v fastfetch)" && -z "$_motd_listed" ]]; then
  case "$TMUX_PANE" in
    %0) fastfetch
        export _motd_listed=yes
        ;;
    *)  ;;
  esac
fi

#######################################################
# Environment Variables
#######################################################

# fzf configuration
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=rounded \
  --color=bg+:#283457 \
  --color=bg:#16161e \
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

# Sometimes bat is installed as batcat.
if [[ -x "$(command -v batcat)" ]]; then
  batname="batcat"
elif [[ -x "$(command -v bat)" ]]; then
  batname="bat"
fi

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
# (directories are only added if they exist)
pathprepend "$HOME/bin" "$HOME/sbin" "$HOME/.local/bin" "$HOME/local/bin" "$HOME/.bin"
pathappend "$HOME/.composer/vendor/bin" "$HOME/.config/composer/vendor/bin"

#######################################################
# History
#######################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#######################################################
# Prompt
#######################################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Trim the current directory prompt
export PROMPT_DIRTRIM=10

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    prompt_symbol='\[\e[0m\]󰹻'
    user_color='\[\e[92;1m\]'
    if [ "$EUID" -eq 0 ]; then
        prompt_symbol='\[\e[0;93m\]󱐋'
        user_color='\[\e[91;1m\]'
    fi

    # Single line
    # PS1='\[\e[38;5;248m\]('${user_color}'\u'${prompt_symbol}'\[\e[36;1m\]\h\[\e[0;38;5;248m\])─[\[\e[96m\]\w\[\e[38;5;248m\]]\[\e[0;1m\]\$\[\e[0m\] '
    # Multi-line
    PS1='\[\e[38;5;248m\]╭──('${user_color}'\u'${prompt_symbol}'\[\e[36;1m\]\h\[\e[0;38;5;248m\])─[\[\e[96m\]\w\[\e[38;5;248m\]]\n╰─\[\e[0;1m\]\$\[\e[0m\] '
else
    PS1='(\u@\h)─[\w]\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Add current directory to prompt for Tabby
export PS1="$PS1\[\e]1337;CurrentDir="'$(pwd)\a\]'

#######################################################
# Completion
#######################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#######################################################
# Aliases and Functions
#######################################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#######################################################
# Shell integrations
#######################################################

# Set up fzf key bindings and fuzzy completion
if [[ -x "$(command -v fzf)" ]]; then
  if fzf --bash &>/dev/null; then
    source <(fzf --bash)
  elif [ -d /usr/share/doc/fzf/examples ]; then
    # Load fzf manually for older versions
    source /usr/share/doc/fzf/examples/key-bindings.bash
    source /usr/share/doc/fzf/examples/completion.bash
  fi
elif [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

# Load nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Initialize phpenv
if [[ -x "$(command -v phpenv)" ]]; then
  eval "$(phpenv init -)"
fi
