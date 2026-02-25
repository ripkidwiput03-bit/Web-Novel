# ═══════════════════════════════════════════════════════════
# 🔥 ULTIMATE TERMUX ZSH CONFIG 🔥
# ═══════════════════════════════════════════════════════════

# ─── OH MY ZSH CONFIG ───
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    command-not-found
    colored-man-pages
    extract
)

source $ZSH/oh-my-zsh.sh

# ─── POWERLEVEL10K INSTANT PROMPT ───
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ═══════════════════════════════════════════════════════════
#  🎨 STARTUP ANIMATION SYSTEM
# ═══════════════════════════════════════════════════════════

cyber_startup() {
    local R='\033[1;31m'
    local G='\033[1;32m'
    local Y='\033[1;33m'
    local B='\033[1;34m'
    local M='\033[1;35m'
    local C='\033[1;36m'
    local W='\033[1;37m'
    local N='\033[0m'
    local DIM='\033[2m'
    
    clear
    
    # ─── GLITCH EFFECT ───
    local glitch_frames=(
        "  ██████╗██╗   ██╗██████╗ ███████╗██████╗ "
        "  █╔════╝╚██╗ ██╔╝██╔══█╗██╔════╝██╔══█╗"
        "  █║      ╚███╔╝ █████╔╝█████╗  █████╔╝ "
        "  █║       ╚█╔╝  ██╔══█╗██╔══╝  ██╔══█╗ "
        "  ╚██████╗  █║   ██████╔╝███████╗██║  █║ "
        "   ╚═════╝  ╚╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝"
    )
    
    # Glitch entrance
    for ((g=0; g<3; g++)); do
        # Glitched version
        for line in "${glitch_frames[@]}"; do
            local glitched=""
            for ((c=0; c<${#line}; c++)); do
                if [ $((RANDOM % 5)) -eq 0 ]; then
                    local glitch_chars="@#$%&!?░▒▓"
                    glitched="${glitched}${glitch_chars:$((RANDOM % ${#glitch_chars})):1}"
                else
                    glitched="${glitched}${line:$c:1}"
                fi
            done
            echo -e "${R}${glitched}${N}"
        done
        sleep 0.08
        
        # Move cursor up
        printf "\033[6A"
    done
    
    # Clean version with color gradient
    local colors=($R $M $B $C $G $Y)
    for ((i=0; i<${#glitch_frames[@]}; i++)); do
        echo -e "  ${colors[$i]}${glitch_frames[$i]}${N}"
    done
    
    echo ""
    
    # ─── SCANNING ANIMATION ───
    local scan_width=45
    echo -e "  ${DIM}${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    
    # System scan lines with typing effect
    local scan_items=(
        "${G}▸${N} ${W}System${N}     ${DIM}::${N} ${C}Termux $(uname -m)${N}"
        "${G}▸${N} ${W}Shell${N}      ${DIM}::${N} ${C}Zsh + Oh My Zsh${N}"
        "${G}▸${N} ${W}Theme${N}      ${DIM}::${N} ${M}Powerlevel10k${N}"
        "${G}▸${N} ${W}User${N}       ${DIM}::${N} ${Y}$(whoami)${N}"
        "${G}▸${N} ${W}Packages${N}   ${DIM}::${N} ${B}$(pkg list-installed 2>/dev/null | wc -l) installed${N}"
        "${G}▸${N} ${W}Storage${N}    ${DIM}::${N} ${R}$(df -h /data 2>/dev/null | tail -1 | awk '{print $4}') free${N}"
    )
    
    for item in "${scan_items[@]}"; do
        # Typing effect
        sleep 0.08
        echo -e "  ${item}"
    done
    
    echo -e "  ${DIM}${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    echo ""
    
    # ─── PROGRESS INITIALIZATION ───
    local init_items=("Neural Link" "Firewall" "Encryption" "Interface" "Protocol")
    
    for item in "${init_items[@]}"; do
        printf "  ${C}⟨${N} "
        
        # Mini progress bar
        for ((p=0; p<20; p++)); do
            local pcolors=('\033[38;5;196m' '\033[38;5;202m' '\033[38;5;208m' '\033[38;5;214m' '\033[38;5;220m' '\033[38;5;226m' '\033[38;5;190m' '\033[38;5;154m' '\033[38;5;118m' '\033[38;5;82m' '\033[38;5;46m')
            local ci=$((p * ${#pcolors[@]} / 20))
            printf "${pcolors[$ci]}▰${N}"
            sleep 0.015
        done
        
        printf " ${C}⟩${N} ${G}✓${N} ${W}${item}${N}\n"
    done
    
    echo ""
    
    # ─── WELCOME MESSAGE ───
    local hour=$(date +%H)
    local greeting=""
    if [ $hour -lt 6 ]; then
        greeting="🌙 Good Night"
    elif [ $hour -lt 12 ]; then
        greeting="🌅 Good Morning"
    elif [ $hour -lt 17 ]; then
        greeting="☀️  Good Afternoon"
    elif [ $hour -lt 21 ]; then
        greeting="🌆 Good Evening"
    else
        greeting="🌙 Good Night"
    fi
    
    # Animated welcome box
    echo -e "  ${M}┌──────────────────────────────────────────┐${N}"
    echo -e "  ${M}│${N}                                          ${M}│${N}"
    echo -e "  ${M}│${N}   ${W}${greeting}, ${C}$(whoami)${W}!${N}"
    echo -e "  ${M}│${N}   ${DIM}${W}$(date '+%A, %d %B %Y • %H:%M:%S')${N}"
    echo -e "  ${M}│${N}                                          ${M}│${N}"
    echo -e "  ${M}│${N}   ${Y}\"The system is yours. Hack the planet.\"${N}"
    echo -e "  ${M}│${N}                                          ${M}│${N}"
    echo -e "  ${M}└──────────────────────────────────────────┘${N}"
    echo ""
    
    # ─── RANDOM CYBER QUOTE ───
    local quotes=(
        "Access Granted. Welcome to the Grid."
        "System Online. All protocols active."
        "Neural interface synchronized."
        "Quantum encryption enabled."
        "Stealth mode activated."
        "Digital fortress online."
    )
    local quote=${quotes[$((RANDOM % ${#quotes[@]}))]}
    echo -e "  ${DIM}${G}⚡ ${quote}${N}"
    echo ""
}

# Run startup animation
cyber_startup

# ═══════════════════════════════════════════════════════════
#  🎯 ALIASES & FUNCTIONS
# ═══════════════════════════════════════════════════════════

# ─── Navigation ───
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias cls='clear && cyber_startup'

# ─── Git shortcuts ───
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'

# ─── System ───
alias update='pkg update && pkg upgrade -y'
alias install='pkg install'
alias search='pkg search'
alias myip='curl -s ifconfig.me && echo'
alias weather='curl -s wttr.in/?format=3'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python'

# ─── Fun ───
alias matrix='cmatrix -b -C cyan'
alias reload='source ~/.zshrc'
alias edit='nano ~/.zshrc'

# ─── CUSTOM FUNCTIONS ───

# Fancy directory listing
lf() {
    echo -e "\033[1;36m📂 Contents of: \033[1;33m$(pwd)\033[0m"
    echo -e "\033[2;36m$(printf '─%.0s' {1..50})\033[0m"
    ls -la --color=auto "$@"
    echo -e "\033[2;36m$(printf '─%.0s' {1..50})\033[0m"
    local count=$(ls -1 "$@" 2>/dev/null | wc -l)
    echo -e "\033[2m  📊 Total: ${count} items\033[0m"
}

# Extract any archive
ex() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# System info
sysinfo() {
    local C='\033[1;36m'
    local M='\033[1;35m'
    local Y='\033[1;33m'
    local G='\033[1;32m'
    local W='\033[1;37m'
    local N='\033[0m'
    local DIM='\033[2m'
    
    echo ""
    echo -e "  ${C}╔══════════════════════════════════════╗${N}"
    echo -e "  ${C}║${N}     ${M}⚡ SYSTEM INFORMATION ⚡${N}       ${C}║${N}"
    echo -e "  ${C}╠══════════════════════════════════════╣${N}"
    echo -e "  ${C}║${N} ${W}OS${N}      ${DIM}:${N} ${G}$(uname -o)${N}"
    echo -e "  ${C}║${N} ${W}Kernel${N}  ${DIM}:${N} ${G}$(uname -r)${N}"
    echo -e "  ${C}║${N} ${W}Arch${N}    ${DIM}:${N} ${G}$(uname -m)${N}"
    echo -e "  ${C}║${N} ${W}Shell${N}   ${DIM}:${N} ${G}$SHELL${N}"
    echo -e "  ${C}║${N} ${W}User${N}    ${DIM}:${N} ${Y}$(whoami)${N}"
    echo -e "  ${C}║${N} ${W}Home${N}    ${DIM}:${N} ${Y}$HOME${N}"
    echo -e "  ${C}║${N} ${W}Uptime${N}  ${DIM}:${N} ${Y}$(uptime -p 2>/dev/null || uptime)${N}"
    echo -e "  ${C}║${N} ${W}Pkgs${N}    ${DIM}:${N} ${Y}$(pkg list-installed 2>/dev/null | wc -l)${N}"
    echo -e "  ${C}╚══════════════════════════════════════╝${N}"
    echo ""
}

# Create project directory
mkproject() {
    if [ -z "$1" ]; then
        echo "Usage: mkproject <project-name>"
        return 1
    fi
    mkdir -p "$1"/{src,docs,tests,assets}
    touch "$1"/README.md
    touch "$1"/src/main.py
    echo "# $1" > "$1"/README.md
    echo -e "\033[1;32m✓ Project '$1' created with structure:\033[0m"
    find "$1" -type f -o -type d | head -20 | sed 's/^/  /'
    cd "$1"
}

# Color palette display
colors() {
    echo ""
    echo -e "  \033[1;37m═══ COLOR PALETTE ═══\033[0m"
    echo ""
    for i in {0..255}; do
        printf "\033[48;5;%sm  %3s  \033[0m" "$i" "$i"
        if [ $(( (i + 1) % 8 )) -eq 0 ]; then
            echo ""
        fi
    done
    echo ""
}

# ─── SYNTAX HIGHLIGHTING STYLES ───
ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'

# ─── AUTOSUGGESTION COLOR ───
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ─── HISTORY CONFIG ───
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# ─── POWERLEVEL10K CONFIG ───
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ═══════════════════════════════════════════════════════════
#  ⚡ EXTRA SHORTCUT BOOST (SAFE ADDITION ONLY)
# ═══════════════════════════════════════════════════════════

# ─── Quick Navigation ───
alias home='cd ~'
alias root='cd /'
alias dl='cd ~/downloads'
alias dtop='cd ~/storage/shared'

# ─── Fast Editing ───
alias zshconfig='nano ~/.zshrc'
alias p10kconfig='nano ~/.p10k.zsh'
alias aliases='grep "alias" ~/.zshrc'

# ─── Super Fast Git ───
alias gpull='git pull origin $(git branch --show-current)'
alias gacp='git add . && git commit -m "quick update" && git push'
alias gundo='git reset --soft HEAD~1'

# ─── Python / Dev ───
alias venv='python -m venv venv && source venv/bin/activate'
alias activate='source venv/bin/activate'
alias serve='python3 -m http.server 8000'
alias json='python -m json.tool'

# ─── Networking ───
alias ports='netstat -tulnp'
alias pingg='ping -c 5 google.com'
alias iplocal='ip a | grep inet'

# ─── File Utilities ───
alias size='du -sh * | sort -h'
alias biggest='du -ah . | sort -rh | head -20'
alias cleanup='rm -rf ~/.cache/*'

# ─── Safety ───
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ─── One-Key Power Commands ───
alias h='history'
alias j='jobs -l'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%T"'
alias today='date +"%A, %d %B %Y"'

# ─── Quick Project Jump (auto detect git root) ───
proj() {
    cd "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "Not inside a git project"
}

# ─── Quick Backup Current Folder ───
backup() {
    tar -czf "$(basename "$PWD")_backup_$(date +%Y%m%d_%H%M%S).tar.gz" .
    echo "Backup created successfully."
}
alias test123="echo WORKING"
