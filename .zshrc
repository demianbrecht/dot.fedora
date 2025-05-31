# Zsh Configuration for Fedora Workstation
# Developer/Hacker theme with productivity features

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration - Powerlevel10k for sleek appearance
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zsh plugins for enhanced functionality
plugins=(
    git                    # Git aliases and shortcuts
    zsh-autosuggestions   # Fish-like autosuggestions
    zsh-syntax-highlighting # Syntax highlighting
    history-substring-search # Better history search
    docker                # Docker completions
    kubectl               # Kubernetes completions
    npm                   # NPM completions
    pip                   # Python pip completions
    sudo                  # Double ESC to add sudo
    web-search           # Search web from terminal
    copyfile             # Copy file content to clipboard
    extract              # Universal extraction command
    z                    # Jump to frequently used directories
    colored-man-pages    # Colorized man pages
    command-not-found    # Suggest packages for missing commands
    systemd              # systemctl completions
    dnf                  # DNF package manager completions
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Default editor (vim for consistency with theme)
export EDITOR='vim'
export VISUAL='vim'

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# GPG TTY for commit signing
export GPG_TTY=$(tty)

# Development environment
export BROWSER='firefox'

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# ============================================================================
# ZSH OPTIONS
# ============================================================================

# History options
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry
setopt SHARE_HISTORY             # Share history between all sessions

# Directory options
setopt AUTO_CD                   # Auto change to a directory without typing cd
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd

# Completion options
setopt COMPLETE_ALIASES          # Complete aliases
setopt GLOB_COMPLETE             # Generate matches for a glob
setopt HASH_LIST_ALL             # Hash everything before completion
setopt MENU_COMPLETE             # Autoselect the first completion entry

# Other useful options
setopt CORRECT                   # Spelling correction
setopt EXTENDED_GLOB             # Extended globbing
setopt NO_BEEP                   # No beeping
setopt PROMPT_SUBST              # Enable prompt substitution

# ============================================================================
# ALIASES - Developer/Productivity focused
# ============================================================================

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# ls replacements and enhancements
if command -v exa &> /dev/null; then
    alias ls='exa --color=always --group-directories-first'
    alias ll='exa -l --color=always --group-directories-first --git'
    alias la='exa -la --color=always --group-directories-first --git'
    alias lt='exa --tree --color=always --group-directories-first'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lhF --color=auto --group-directories-first'
    alias la='ls -lahF --color=auto --group-directories-first'
fi

# Git shortcuts (hacker productivity)
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gs='git status'
alias gst='git stash'
alias glog='git log --oneline --decorate --graph'
alias glogg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# System monitoring (hacker tools)
alias htop='htop -C'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Network tools
alias myip='curl -s ipinfo.io/ip'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias ports='netstat -tulanp'

# Package management (Fedora)
alias dnfu='sudo dnf update'
alias dnfi='sudo dnf install'
alias dnfs='dnf search'
alias dnfr='sudo dnf remove'
alias dnfinfo='dnf info'

# Docker shortcuts
alias dk='docker'
alias dkc='docker-compose'
alias dki='docker images'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkrm='docker rm'
alias dkrmi='docker rmi'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'
alias venv='python3 -m venv'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'
alias mkdir='mkdir -pv'

# Text processing (hacker tools)
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cat='cat -n'

# Quick edits
alias zshrc='vim ~/.zshrc'
alias vimrc='vim ~/.vimrc'
alias hosts='sudo vim /etc/hosts'

# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

# Extract function for various archive types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
killp() {
    ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs sudo kill -9
}

# Quick backup of a file
backup() {
    cp "$1"{,.bak}
}

# Weather function
weather() {
    local city="${1:-}"
    if [ -n "$city" ]; then
        curl -s "wttr.in/$city"
    else
        curl -s "wttr.in"
    fi
}

# Git commit with automatic staging
gac() {
    git add -A && git commit -m "$1"
}

# Quick Python virtual environment activation
activate() {
    if [ -f "./venv/bin/activate" ]; then
        source ./venv/bin/activate
    elif [ -f "./env/bin/activate" ]; then
        source ./env/bin/activate
    elif [ -f "./.venv/bin/activate" ]; then
        source ./.venv/bin/activate
    else
        echo "No virtual environment found in current directory"
    fi
}

# Quick server for current directory
server() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Generate random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 "$length" | cut -c1-"$length"
}

# ============================================================================
# KEY BINDINGS
# ============================================================================

# Vi mode for command line editing (matches vim theme)
bindkey -v

# Better history search
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

# Edit command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^E" edit-command-line

# Quick navigation
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^U" kill-whole-line
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char

# ============================================================================
# COMPLETION SYSTEM
# ============================================================================

# Initialize completion system
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# Cache completions
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# ============================================================================
# POWERLEVEL10K CONFIGURATION
# ============================================================================

# Load Powerlevel10k configuration if available
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# ADDITIONAL TOOL INTEGRATIONS
# ============================================================================

# Load fzf if available (fuzzy finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load nvm if available (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load pyenv if available (Python Version Manager)
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

# Load rbenv if available (Ruby Version Manager)
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

# Load cargo environment if available (Rust)
[ -f ~/.cargo/env ] && source ~/.cargo/env

# ============================================================================
# STARTUP MESSAGE
# ============================================================================

# Show system info on new terminal (can be disabled by commenting out)
if [[ -o interactive ]]; then
    echo ""
    echo "💻 Welcome to your developer environment"
    echo "🚀 Zsh with Powerlevel10k theme"
    echo "⚡ $(zsh --version)"
    echo ""
fi 