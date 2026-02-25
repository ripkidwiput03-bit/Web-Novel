#!/data/data/com.termux/files/usr/bin/bash

# ═══════════════════════════════════════════════════════════
#  🔥 ULTIMATE TERMUX THEME INSTALLER 🔥
#  By: Custom Setup
# ═══════════════════════════════════════════════════════════

# Warna
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'
BG_B='\033[44m'
BG_M='\033[45m'
BG_G='\033[42m'

# ─── ANIMASI LOADING BAR ───
loading_bar() {
    local text="$1"
    local duration=${2:-30}
    local bar_length=40
    
    echo ""
    for ((i=0; i<=bar_length; i++)); do
        local percent=$((i * 100 / bar_length))
        local filled=$i
        local empty=$((bar_length - i))
        
        # Gradient warna
        if [ $percent -lt 33 ]; then
            color=$R
        elif [ $percent -lt 66 ]; then
            color=$Y
        else
            color=$G
        fi
        
        # Build bar
        bar=""
        for ((j=0; j<filled; j++)); do
            bar="${bar}█"
        done
        for ((j=0; j<empty; j++)); do
            bar="${bar}░"
        done
        
        # Spinner
        local spinners=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
        local spin=${spinners[$((i % ${#spinners[@]}))]}
        
        printf "\r  ${C}${spin}${N} ${text} ${color}[${bar}]${N} ${W}${percent}%%${N}"
        
        # Kecepatan variable
        if [ $percent -lt 20 ]; then
            sleep 0.05
        elif [ $percent -lt 80 ]; then
            sleep 0.03
        else
            sleep 0.06
        fi
    done
    printf "\r  ${G}✓${N} ${text} ${G}[████████████████████████████████████████]${N} ${G}100%%${N}\n"
}

# ─── ANIMASI MATRIX RAIN ───
matrix_rain() {
    local lines=15
    local cols=50
    local chars="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモ0123456789"
    
    for ((l=0; l<lines; l++)); do
        line=""
        for ((c=0; c<cols; c++)); do
            rand=$((RANDOM % ${#chars}))
            char="${chars:$rand:1}"
            brightness=$((RANDOM % 3))
            case $brightness in
                0) line="${line}\033[32m${char}";;
                1) line="${line}\033[1;32m${char}";;
                2) line="${line}\033[1;37m${char}";;
            esac
        done
        echo -e "${line}\033[0m"
        sleep 0.03
    done
}

# ─── ANIMASI INTRO EPIC ───
epic_intro() {
    clear
    sleep 0.3
    
    # Cyber border
    echo -e "${C}"
    echo "  ╔══════════════════════════════════════════════════╗"
    echo "  ║                                                  ║"
    sleep 0.1
    echo "  ║   ████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗ ║"
    sleep 0.1
    echo "  ║   ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║ ║"
    sleep 0.1
    echo "  ║      ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ║"
    sleep 0.1
    echo "  ║      ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ║"
    sleep 0.1
    echo "  ║      ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝ ║"
    sleep 0.1
    echo "  ║      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝  ║"
    sleep 0.1
    echo "  ║                                                  ║"
    echo -e "  ║        ${M}🔥 ULTIMATE THEME INSTALLER 🔥${C}          ║"
    echo "  ║                                                  ║"
    echo "  ╚══════════════════════════════════════════════════╝"
    echo -e "${N}"
    sleep 0.5
    
    # Matrix effect
    echo -e "  ${G}▸ Initializing Matrix Protocol...${N}"
    sleep 0.3
    matrix_rain
    sleep 0.5
    
    clear
    echo ""
    echo -e "  ${BG_M}${W}                                                ${N}"
    echo -e "  ${BG_M}${W}     🚀 STARTING INSTALLATION SEQUENCE 🚀      ${N}"
    echo -e "  ${BG_M}${W}                                                ${N}"
    echo ""
    sleep 0.5
}

# ─── ANIMASI DNA HELIX ───
dna_loading() {
    local text="$1"
    local frames=(
        "  ⠀⠀⣀⣤⣤⣀⠀⠀"
        "  ⠀⣴⣿⣿⣿⣿⣦⠀"
        "  ⣿⣿⣿⣿⣿⣿⣿⣿"
        "  ⠀⠻⣿⣿⣿⣿⠟⠀"
        "  ⠀⠀⠈⠛⠛⠁⠀⠀"
    )
    
    echo -e "  ${C}${text}${N}"
    for frame in "${frames[@]}"; do
        echo -e "  ${M}${frame}${N}"
        sleep 0.1
    done
}

# ─── PULSE ANIMATION ───
pulse_text() {
    local text="$1"
    local colors=($R $Y $G $C $B $M)
    
    for ((i=0; i<3; i++)); do
        for color in "${colors[@]}"; do
            printf "\r  ${color}⬤ ${text}${N}  "
            sleep 0.08
        done
    done
    printf "\r  ${G}⬤ ${text}${N}  \n"
}

# ═══════════════════════════════════════════════════════════
#  INSTALASI DIMULAI
# ═══════════════════════════════════════════════════════════

epic_intro

# ─── UPDATE PACKAGES ───
pulse_text "Updating Termux packages..."
loading_bar "Updating repositories" 
apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1
echo -e "  ${G}✓ Packages updated successfully${N}\n"

# ─── INSTALL DEPENDENCIES ───
pulse_text "Installing core dependencies..."

deps=(zsh git curl wget python ruby figlet toilet ncurses-utils bc cmatrix)
total=${#deps[@]}
for ((i=0; i<total; i++)); do
    pkg="${deps[$i]}"
    percent=$(( (i+1) * 100 / total ))
    loading_bar "Installing ${pkg}" 
    pkg install -y "$pkg" > /dev/null 2>&1
done

echo -e "\n  ${G}✓ All dependencies installed${N}\n"

# ─── INSTALL OH MY ZSH ───
pulse_text "Installing Oh My Zsh..."
loading_bar "Downloading Oh My Zsh framework"

if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
fi

git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" > /dev/null 2>&1
echo -e "  ${G}✓ Oh My Zsh installed${N}\n"

# ─── INSTALL POWERLEVEL10K ───
pulse_text "Installing Powerlevel10k theme..."
loading_bar "Cloning Powerlevel10k"

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    rm -rf "$P10K_DIR"
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR" > /dev/null 2>&1
echo -e "  ${G}✓ Powerlevel10k installed${N}\n"

# ─── INSTALL PLUGINS ───
pulse_text "Installing Zsh plugins..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
loading_bar "Plugin: zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" > /dev/null 2>&1

# zsh-syntax-highlighting
loading_bar "Plugin: zsh-syntax-highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" > /dev/null 2>&1

# zsh-completions
loading_bar "Plugin: zsh-completions"
git clone --depth=1 https://github.com/zsh-users/zsh-completions.git \
    "$ZSH_CUSTOM/plugins/zsh-completions" > /dev/null 2>&1

# you-should-use
loading_bar "Plugin: you-should-use"
git clone --depth=1 https://github.com/MichaelAqworker/zsh-you-should-use.git \
    "$ZSH_CUSTOM/plugins/you-should-use" > /dev/null 2>&1

echo -e "\n  ${G}✓ All plugins installed${N}\n"

# ─── SETUP TERMUX COLORS ───
pulse_text "Setting up Cyberpunk color scheme..."
loading_bar "Applying color scheme"

mkdir -p "$HOME/.termux"

cat > "$HOME/.termux/colors.properties" << 'COLORS'
# ══════ CYBERPUNK NEON THEME ══════
# Special
foreground=#c5c8c6
background=#0a0e14
cursor=#ff00ff

# Black/DarkGrey
color0=#0a0e14
color8=#4d5566

# Red/LightRed
color1=#ff3333
color9=#ff6666

# Green/LightGreen
color2=#00ff9f
color10=#33ffb2

# Yellow/LightYellow
color3=#ffcc00
color11=#ffd633

# Blue/LightBlue
color4=#00bfff
color12=#33ccff

# Magenta/LightMagenta
color5=#ff00ff
color13=#ff33ff

# Cyan/LightCyan
color6=#00ffff
color14=#33ffff

# LightGrey/White
color7=#c5c8c6
color15=#ffffff
COLORS

echo -e "  ${G}✓ Color scheme applied${N}\n"

# ─── SETUP TERMUX FONT ───
pulse_text "Installing Nerd Font..."
loading_bar "Downloading FiraCode Nerd Font"

curl -fsSL -o "$HOME/.termux/font.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf" > /dev/null 2>&1

echo -e "  ${G}✓ Nerd Font installed${N}\n"

# ─── SETUP TERMUX PROPERTIES ───
pulse_text "Configuring Termux properties..."
loading_bar "Writing configuration"

cat > "$HOME/.termux/termux.properties" << 'PROPS'
# Keyboard
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
# Bell
bell-character=ignore
# Fullscreen
fullscreen=false
# Volume keys as media
volume-keys=volume
PROPS

echo -e "  ${G}✓ Properties configured${N}\n"

# ─── CREATE EPIC .ZSHRC ───
pulse_text "Creating ultimate .zshrc configuration..."
loading_bar "Building configuration file"

cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
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
    echo -e "  ${C}║${N}      ${M}⚡ SYSTEM INFORMATION ⚡${N}       ${C}║${N}"
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

ZSHRC_EOF

echo -e "  ${G}✓ .zshrc configured${N}\n"

# ─── CREATE P10K CONFIG ───
pulse_text "Creating Powerlevel10k configuration..."
loading_bar "Building P10K config"

cat > "$HOME/.p10k.zsh" << 'P10K_EOF'
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
P10K_EOF

echo -e "  ${G}✓ P10K config created${N}\n"

# ─── SET ZSH AS DEFAULT ───
pulse_text "Setting Zsh as default shell..."
loading_bar "Switching shell"
chsh -s zsh > /dev/null 2>&1
echo -e "  ${G}✓ Zsh set as default shell${N}\n"

# ─── RELOAD TERMUX SETTINGS ───
termux-reload-settings > /dev/null 2>&1

# ═══════════════════════════════════════════════════════════
#  INSTALLATION COMPLETE
# ═══════════════════════════════════════════════════════════

clear

# Final animation
echo ""
echo -e "${G}"
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║                                                  ║"
echo "  ║   ██████╗ ██████╗ ███╗   ██╗███████╗██╗██╗      ║"
echo "  ║   ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║██║      ║"
echo "  ║   ██║  ██║██║  ██║██╔██╗ ██║█████╗  ██║██║      ║"
echo "  ║   ██║  ██║██║  ██║██║╚██╗██║██╔══╝  ╚═╝╚═╝      ║"
echo "  ║   ██████╔╝██████╔╝██║ ╚████║███████╗██╗██╗      ║"
echo "  ║   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝╚═╝      ║"
echo "  ║                                                  ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo -e "${N}"

echo -e "  ${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo ""
echo -e "  ${W}🎉 Installation Complete! 🎉${N}"
echo ""
echo -e "  ${Y}📋 What's Installed:${N}"
echo -e "  ${G}  ✓${N} Oh My Zsh"
echo -e "  ${G}  ✓${N} Powerlevel10k Theme"
echo -e "  ${G}  ✓${N} zsh-autosuggestions"
echo -e "  ${G}  ✓${N} zsh-syntax-highlighting"
echo -e "  ${G}  ✓${N} zsh-completions"
echo -e "  ${G}  ✓${N} Cyberpunk Color Scheme"
echo -e "  ${G}  ✓${N} FiraCode Nerd Font"
echo -e "  ${G}  ✓${N} Epic Startup Animation"
echo -e "  ${G}  ✓${N} Custom Aliases & Functions"
echo ""
echo -e "  ${Y}📋 Custom Commands:${N}"
echo -e "  ${C}  cls${N}       - Clear & show animation"
echo -e "  ${C}  sysinfo${N}   - System information panel"
echo -e "  ${C}  matrix${N}    - Matrix rain effect"
echo -e "  ${C}  colors${N}    - Show color palette"
echo -e "  ${C}  lf${N}        - Fancy directory listing"
echo -e "  ${C}  mkproject${N} - Create project structure"
echo -e "  ${C}  reload${N}    - Reload zsh config"
echo -e "  ${C}  edit${N}      - Edit zsh config"
echo ""
echo -e "  ${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo ""
echo -e "  ${M}⚡ Type ${W}exit${M} then open Termux again to see the magic! ⚡${N}"
echo ""
echo -e "  ${DIM}  Or run: ${W}zsh${N}${DIM} to start immediately${N}"
echo ""

