# Powerlevel10k Configuration
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
    autoload -Uz is-at-least && is-at-least 5.1 || return

    # Prompt segments
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        os_icon
        dir
        vcs
        prompt_char
    )

    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status
        command_execution_time
        background_jobs
        ram
        time
        battery
    )

    # Basic settings
    typeset -g POWERLEVEL9K_MODE=nerdfont-complete
    typeset -g POWERLEVEL9K_ICON_PADDING=moderate
    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{014}╭─'
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{014}╰─%F{cyan}❯%F{magenta}❯%F{green}❯ %f'
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

    # OS Icon
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='🐧'

    # Directory
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
    typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=cyan
    typeset -g POWERLEVEL9K_DIR_ETC_FOREGROUND=yellow

    # VCS (Git)
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=yellow
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '

    # Prompt char
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='⚡'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='⚡'

    # Command execution time
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow

    # Status
    typeset -g POWERLEVEL9K_STATUS_OK=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red

    # Time
    typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
    typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='⏰'

    # RAM
    typeset -g POWERLEVEL9K_RAM_FOREGROUND=green

    # Battery
    typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
    typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=red
    typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=green
    typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=yellow

    # Background jobs
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=magenta

    # Transient prompt
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

    # Instant prompt
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

    # Hot reload
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    (( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
    'builtin' 'unset' 'p10k_config_opts'
}
