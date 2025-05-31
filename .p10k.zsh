# Powerlevel10k Configuration - Minimal Clean Style
# No icons, simple and clean

# Temporarily change options
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Simple left prompt: directory + git + prompt character
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    virtualenv              # Python virtual environment
    dir                     # Current directory
    vcs                     # Git status  
    prompt_char             # Prompt character
  )

  # Right prompt: just time and execution time when needed
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # Exit code (only on error)
    command_execution_time  # Duration of last command (if > 3s)
    time                    # Current time
  )

  # Use ASCII mode (no special fonts needed)
  typeset -g POWERLEVEL9K_MODE=ascii

  # Clean styling
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

  # Add empty line before prompt for breathing room
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Simple prompt character: > in green for success, red for error
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=red
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='<'

  # Directory colors
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  
  # Smart directory shortening
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  
  # Git configuration - clean and simple
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=grey
  
  # Simple git indicators (no fancy icons)
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='<'
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='>'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='*'
  typeset -g POWERLEVEL9K_VCS_TAG_ICON='#'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
  typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'

  # Status segment (only show on error)
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✗'

  # Command execution time (only show if > 3 seconds)
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow

  # Time format
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=white
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  # Virtual environment styling - clean and minimal
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER=''
  typeset -g POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER=''

  # Transient prompt - clean up old prompts
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # Instant prompt
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  # Disable hot reload for performance
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Reload if already loaded
  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts' 