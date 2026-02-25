#!/data/data/com.termux/files/usr/bin/bash

# ╔════════════════════════════════════════════════════════════════════════╗
# ║                                                                        ║
# ║    ██╗  ██╗██╗   ██╗██╗   ██╗    ╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗                    ║
# ║    ██║ ██╔╝╚██╗ ██╔╝╚██╗ ██╔╝    ║║║║╠╣ ║║║║║ ║ ║╣                     ║
# ║    █████╔╝  ╚████╔╝  ╚████╔╝     ╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝                    ║
# ║    ██╔═██╗   ╚██╔╝    ╚██╔╝                                            ║
# ║    ██║  ██╗   ██║      ██║       ULTIMATE TERMUX FRAMEWORK v3.0        ║
# ║    ╚═╝  ╚═╝   ╚═╝      ╚═╝       Created by: KyyInfinite               ║
# ║                                                                        ║
# ║    FILE 1/3 — CORE ENGINE & VISUAL SYSTEM                              ║
# ║                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════╝
#
#  Dependencies : curl, figlet, toilet, bc, nmap, python, git, wget,
#                 whois, net-tools, openssl, jq, neofetch
#
#  Usage        : bash kyy-core.sh
#  Structure    : kyy-core.sh  → Core + Visual + Menu
#                 kyy-modules.sh → All hacking/utility modules
#                 kyy-plugins.sh → Plugin system + extras
#

# ══════════════════════════════════════════════════════════════
#  SECTION 1: GLOBAL VARIABLES & EXTENDED COLOR PALETTE
# ══════════════════════════════════════════════════════════════

VERSION="3.0"
AUTHOR="KyyInfinite"
CODENAME="PHANTOM"
BUILD_DATE="2025"
CONFIG_DIR="$HOME/.kyyinfinite"
CONFIG_FILE="$CONFIG_DIR/config.conf"
THEME_FILE="$CONFIG_DIR/theme.conf"
PROMPT_FILE="$CONFIG_DIR/prompt.conf"
LOG_FILE="$CONFIG_DIR/kyy.log"
PLUGIN_DIR="$CONFIG_DIR/plugins"
CACHE_DIR="$CONFIG_DIR/cache"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── BASIC COLORS ────────────────────────────────────
RST='\033[0m'
BLD='\033[1m'
DIM='\033[2m'
ITA='\033[3m'
UND='\033[4m'
BLK='\033[5m'
REV='\033[7m'
HID='\033[8m'
STR='\033[9m'

# ─── FOREGROUND ──────────────────────────────────────
BK='\033[30m';  R='\033[31m';   G='\033[32m';   Y='\033[33m'
B='\033[34m';   M='\033[35m';   C='\033[36m';   W='\033[37m'
BKB='\033[90m'; RB='\033[91m';  GB='\033[92m';  YB='\033[93m'
BB='\033[94m';  MB='\033[95m';  CB='\033[96m';  WB='\033[97m'

# ─── BACKGROUND ─────────────────────────────────────
BGK='\033[40m';  BGR='\033[41m';  BGG='\033[42m';  BGY='\033[43m'
BGB='\033[44m';  BGM='\033[45m';  BGC='\033[46m';  BGW='\033[47m'
BGKB='\033[100m'; BGRB='\033[101m'; BGGB='\033[102m'; BGYB='\033[103m'
BGBB='\033[104m'; BGMB='\033[105m'; BGCB='\033[106m'; BGWB='\033[107m'

# ─── 256 COLOR SHORTCUTS ────────────────────────────
c256() { echo -ne "\033[38;5;${1}m"; }
bg256() { echo -ne "\033[48;5;${1}m"; }

# ─── TRUE COLOR (24-BIT) ────────────────────────────
rgb() { echo -ne "\033[38;2;${1};${2};${3}m"; }
bgrgb() { echo -ne "\033[48;2;${1};${2};${3}m"; }

# ─── ACTIVE THEME COLORS (defaults — overridden by theme) ──
T_PRIMARY='\033[38;5;39m'      # Bright blue
T_SECONDARY='\033[38;5;208m'   # Orange
T_ACCENT='\033[38;5;198m'      # Pink
T_SUCCESS='\033[38;5;46m'      # Green
T_WARNING='\033[38;5;226m'     # Yellow
T_ERROR='\033[38;5;196m'       # Red
T_INFO='\033[38;5;87m'         # Cyan
T_MUTED='\033[38;5;245m'       # Gray
T_HIGHLIGHT='\033[38;5;213m'   # Light pink
T_BORDER='\033[38;5;240m'      # Dark gray
T_BG='\033[48;5;233m'          # Near black bg
T_HEADER_BG='\033[48;5;17m'    # Dark blue bg
T_MENU_BG='\033[48;5;234m'     # Slightly lighter
T_SELECT='\033[48;5;24m'       # Selection bg

CURRENT_THEME="phantom"

# ══════════════════════════════════════════════════════════════
#  SECTION 2: INITIALIZATION & CONFIGURATION
# ══════════════════════════════════════════════════════════════

init_dirs() {
    mkdir -p "$CONFIG_DIR" "$PLUGIN_DIR" "$CACHE_DIR" 2>/dev/null
    touch "$LOG_FILE" 2>/dev/null
}

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE" 2>/dev/null
}

save_config() {
    cat > "$CONFIG_FILE" << CONF
# KyyInfinite Toolkit Configuration
# Generated: $(date)
CURRENT_THEME="${CURRENT_THEME}"
CUSTOM_PROMPT="${CUSTOM_PROMPT}"
SHOW_BANNER="${SHOW_BANNER:-true}"
ANIMATION_SPEED="${ANIMATION_SPEED:-normal}"
STARTUP_SOUND="${STARTUP_SOUND:-false}"
LAST_LOGIN="$(date '+%Y-%m-%d %H:%M:%S')"
TOTAL_LAUNCHES="${TOTAL_LAUNCHES:-0}"
CONF
    log_msg "Config saved"
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE" 2>/dev/null
        TOTAL_LAUNCHES=$((TOTAL_LAUNCHES + 1))
    else
        CURRENT_THEME="phantom"
        CUSTOM_PROMPT=""
        SHOW_BANNER="true"
        ANIMATION_SPEED="normal"
        TOTAL_LAUNCHES=1
    fi
    save_config
}

# ══════════════════════════════════════════════════════════════
#  SECTION 3: ADVANCED VISUAL EFFECTS LIBRARY
# ══════════════════════════════════════════════════════════════

# ─── TERMINAL INFO ───────────────────────────────────
TERM_COLS=$(tput cols 2>/dev/null || echo 80)
TERM_ROWS=$(tput lines 2>/dev/null || echo 24)
refresh_term_size() {
    TERM_COLS=$(tput cols 2>/dev/null || echo 80)
    TERM_ROWS=$(tput lines 2>/dev/null || echo 24)
}

# ─── CENTER TEXT ─────────────────────────────────────
center_text() {
    local text="$1"
    local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local text_len=${#clean_text}
    local padding=$(( (TERM_COLS - text_len) / 2 ))
    [ $padding -lt 0 ] && padding=0
    printf "%*s" $padding ""
    echo -e "$text"
}

# ─── GRADIENT TEXT (HORIZONTAL) ──────────────────────
gradient_text() {
    local text="$1"
    local r1=${2:-255} g1=${3:-0} b1=${4:-100}    # Start color
    local r2=${5:-0} g2=${6:-200} b2=${7:-255}     # End color
    local len=${#text}
    
    for ((i=0; i<len; i++)); do
        local ratio_r=$(( r1 + (r2 - r1) * i / len ))
        local ratio_g=$(( g1 + (g2 - g1) * i / len ))
        local ratio_b=$(( b1 + (b2 - b1) * i / len ))
        # Clamp values
        [ $ratio_r -lt 0 ] && ratio_r=0; [ $ratio_r -gt 255 ] && ratio_r=255
        [ $ratio_g -lt 0 ] && ratio_g=0; [ $ratio_g -gt 255 ] && ratio_g=255
        [ $ratio_b -lt 0 ] && ratio_b=0; [ $ratio_b -gt 255 ] && ratio_b=255
        echo -ne "\033[38;2;${ratio_r};${ratio_g};${ratio_b}m${text:$i:1}"
    done
    echo -e "${RST}"
}

# ─── RAINBOW TEXT ────────────────────────────────────
rainbow_text() {
    local text="$1"
    local colors=(196 208 226 46 39 171 201)
    local len=${#text}
    for ((i=0; i<len; i++)); do
        local ci=$(( i % ${#colors[@]} ))
        echo -ne "\033[1;38;5;${colors[$ci]}m${text:$i:1}"
    done
    echo -e "${RST}"
}

# ─── NEON GLOW TEXT ──────────────────────────────────
neon_text() {
    local text="$1"
    local color="${2:-\033[38;5;39m}"
    local glow="\033[38;5;51m"
    echo -e "${BLD}${glow}░▒▓ ${color}${text} ${glow}▓▒░${RST}"
}

# ─── ANIMATED TYPING EFFECT ─────────────────────────
type_effect() {
    local text="$1"
    local color="${2:-${T_PRIMARY}}"
    local speed="${3:-0.02}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${color}${text:$i:1}${RST}"
        sleep "$speed"
    done
    echo ""
}

# ─── CYBER TYPING (WITH CURSOR) ─────────────────────
cyber_type() {
    local text="$1"
    local color="${2:-${T_PRIMARY}}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${color}${text:$i:1}${RST}"
        echo -ne "\033[38;5;46m█${RST}"
        sleep 0.03
        echo -ne "\b "
        echo -ne "\b"
    done
    echo ""
}

# ─── GLITCH TEXT EFFECT ──────────────────────────────
glitch_effect() {
    local text="$1"
    local iterations=${2:-5}
    local glitch_chars='!@#$%^&*<>?/\|{}[]~═║╗╔╚╝█▓▒░'
    
    for ((g=0; g<iterations; g++)); do
        local glitched=""
        for ((i=0; i<${#text}; i++)); do
            if [ $((RANDOM % 4)) -eq 0 ]; then
                local ri=$((RANDOM % ${#glitch_chars}))
                glitched+="${glitch_chars:$ri:1}"
            else
                glitched+="${text:$i:1}"
            fi
        done
        
        local colors=("${T_ERROR}" "${T_PRIMARY}" "${T_ACCENT}" "${T_WARNING}")
        local rc=${colors[$((RANDOM % ${#colors[@]}))]}
        
        echo -ne "\r    ${rc}${glitched}${RST}"
        sleep 0.08
    done
    echo -e "\r    ${T_SUCCESS}${text}${RST}                    "
}

# ─── PROGRESS BAR (PREMIUM STYLE) ───────────────────
premium_bar() {
    local text="$1"
    local duration=${2:-3}
    local width=40
    local filled_char="█"
    local empty_char="░"
    
    for ((i=0; i<=width; i++)); do
        local percent=$((i * 100 / width))
        local filled=$i
        local empty=$((width - i))
        
        echo -ne "\r    ${T_MUTED}${text} ${T_BORDER}▐"
        
        for ((j=0; j<filled; j++)); do
            # Color gradient from red to cyan
            if [ $j -lt $((width/4)) ]; then
                echo -ne "\033[38;5;196m${filled_char}"
            elif [ $j -lt $((width/2)) ]; then
                echo -ne "\033[38;5;208m${filled_char}"
            elif [ $j -lt $((width*3/4)) ]; then
                echo -ne "\033[38;5;226m${filled_char}"
            else
                echo -ne "\033[38;5;46m${filled_char}"
            fi
        done
        
        for ((j=0; j<empty; j++)); do
            echo -ne "\033[38;5;236m${empty_char}"
        done
        
        echo -ne "${T_BORDER}▌ "
        
        # Percentage with color
        if [ $percent -lt 30 ]; then
            echo -ne "\033[38;5;196m"
        elif [ $percent -lt 60 ]; then
            echo -ne "\033[38;5;208m"
        elif [ $percent -lt 90 ]; then
            echo -ne "\033[38;5;226m"
        else
            echo -ne "\033[38;5;46m"
        fi
        printf "%3d%%" $percent
        echo -ne "${RST}"
        
        local sleep_time; sleep_time=$(echo "scale=4; $duration / $width" | bc 2>/dev/null || echo "0.05"); sleep "$sleep_time" 2>/dev/null || sleep 0.05
    done
    echo -e " ${T_SUCCESS}✓${RST}"
}

# ─── SPINNER (MULTIPLE STYLES) ──────────────────────
spin() {
    local text="$1"
    local duration=${2:-2}
    # Sanitize: ensure integer for arithmetic
    case "$duration" in
        *.*) duration=$(printf "%.0f" "$duration" 2>/dev/null || echo 2) ;;
    esac
    [ "$duration" -lt 1 ] 2>/dev/null && duration=1
    # Sanitize: convert decimal to int
    case "$duration" in *.*) duration=$(printf "%.0f" "$duration" 2>/dev/null || echo 2) ;; esac
    [ "$duration" -lt 1 ] 2>/dev/null && duration=1
    local style=${3:-1}
    
    case $style in
        1) local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏') ;;
        2) local frames=('◐' '◓' '◑' '◒') ;;
        3) local frames=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷') ;;
        4) local frames=('▹▹▹▹▹' '▸▹▹▹▹' '▹▸▹▹▹' '▹▹▸▹▹' '▹▹▹▸▹' '▹▹▹▹▸') ;;
        5) local frames=('[    ]' '[=   ]' '[==  ]' '[=== ]' '[ ===]' '[  ==]' '[   =]' '[    ]') ;;
        6) local frames=('🌑' '🌒' '🌓' '🌔' '🌕' '🌖' '🌗' '🌘') ;;
        7) local frames=('←' '↖' '↑' '↗' '→' '↘' '↓' '↙') ;;
        8) local frames=('▏' '▎' '▍' '▌' '▋' '▊' '▉' '█' '▉' '▊' '▋' '▌' '▍' '▎') ;;
    esac
    
    local end_time=$((SECONDS + duration))
    local i=0
    while [ $SECONDS -lt $end_time ]; do
        echo -ne "\r    ${T_ACCENT}${frames[$i]} ${T_INFO}${text}${RST}  "
        i=$(( (i+1) % ${#frames[@]} ))
        sleep 0.1
    done
    echo -e "\r    ${T_SUCCESS}✓ ${WH}${text}${RST}                        "
}

# ─── MATRIX DIGITAL RAIN (ENHANCED) ─────────────────
matrix_rain() {
    local duration=${1:-5}
    local chars="アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEF"
    local end_time=$((SECONDS + duration))
    
    tput civis 2>/dev/null  # Hide cursor
    
    while [ $SECONDS -lt $end_time ]; do
        local line=""
        for ((c=0; c<TERM_COLS; c++)); do
            local r=$((RANDOM % 5))
            if [ $r -eq 0 ]; then
                local ri=$((RANDOM % ${#chars}))
                local char="${chars:$ri:1}"
                local shade=$((RANDOM % 4))
                case $shade in
                    0) line+="\033[38;5;46m${char}" ;;   # Bright green
                    1) line+="\033[38;5;34m${char}" ;;   # Medium green
                    2) line+="\033[38;5;22m${char}" ;;   # Dark green
                    3) line+="\033[1;38;5;255m${char}" ;; # White flash
                esac
            else
                line+=" "
            fi
        done
        echo -e "$line"
        sleep 0.04
    done
    
    tput cnorm 2>/dev/null  # Show cursor
}

# ─── CYBER PARTICLES ────────────────────────────────
particle_effect() {
    local duration=${1:-3}
    local particles='·∘°•◦◎◉⊙⊚★☆✦✧✶✷✸✹'
    local end_time=$((SECONDS + duration))
    
    tput civis 2>/dev/null
    while [ $SECONDS -lt $end_time ]; do
        local line=""
        for ((c=0; c<TERM_COLS; c++)); do
            if [ $((RANDOM % 8)) -eq 0 ]; then
                local ri=$((RANDOM % ${#particles}))
                local color=$((RANDOM % 6 + 1))
                line+="\033[1;3${color}m${particles:$ri:1}"
            else
                line+=" "
            fi
        done
        echo -e "${line}${RST}"
        sleep 0.06
    done
    tput cnorm 2>/dev/null
}

# ─── FIRE EFFECT TEXT ────────────────────────────────
fire_text() {
    local text="$1"
    local fire_colors=(232 52 88 124 160 196 202 208 214 220 226 228 230 255)
    
    for ((wave=0; wave<3; wave++)); do
        echo -ne "\r    "
        for ((i=0; i<${#text}; i++)); do
            local ci=$(( (i + wave * 3) % ${#fire_colors[@]} ))
            echo -ne "\033[38;5;${fire_colors[$ci]}m${text:$i:1}"
        done
        echo -ne "${RST}"
        sleep 0.15
    done
    echo ""
}

# ─── PREMIUM BOX DRAWING ────────────────────────────
draw_box() {
    local width=${1:-50}
    local title="$2"
    local color="${3:-${T_BORDER}}"
    local title_color="${4:-${T_PRIMARY}}"
    
    echo -ne "    ${color}╔"
    for ((i=0; i<width-2; i++)); do echo -ne "═"; done
    echo -e "╗${RST}"
    
    if [ -n "$title" ]; then
        local clean_title=$(echo -e "$title" | sed 's/\x1b\[[0-9;]*m//g')
        local title_len=${#clean_title}
        local padding=$(( (width - 2 - title_len) / 2 ))
        local padding_r=$(( width - 2 - title_len - padding ))
        
        echo -ne "    ${color}║${RST}"
        printf "%*s" $padding ""
        echo -ne "${title_color}${BLD}${title}${RST}"
        printf "%*s" $padding_r ""
        echo -e "${color}║${RST}"
        
        echo -ne "    ${color}╠"
        for ((i=0; i<width-2; i++)); do echo -ne "═"; done
        echo -e "╣${RST}"
    fi
}

draw_box_line() {
    local width=${1:-50}
    local text="$2"
    local color="${3:-${T_BORDER}}"
    
    local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local text_len=${#clean_text}
    local padding=$((width - 2 - text_len))
    [ $padding -lt 0 ] && padding=0
    
    echo -ne "    ${color}║${RST} ${text}"
    printf "%*s" $padding ""
    echo -e "${color}║${RST}"
}

draw_box_empty() {
    local width=${1:-50}
    local color="${2:-${T_BORDER}}"
    echo -ne "    ${color}║"
    printf "%*s" $((width-2)) ""
    echo -e "║${RST}"
}

draw_box_separator() {
    local width=${1:-50}
    local color="${2:-${T_BORDER}}"
    echo -ne "    ${color}╟"
    for ((i=0; i<width-2; i++)); do echo -ne "─"; done
    echo -e "╢${RST}"
}

draw_box_bottom() {
    local width=${1:-50}
    local color="${2:-${T_BORDER}}"
    echo -ne "    ${color}╚"
    for ((i=0; i<width-2; i++)); do echo -ne "═"; done
    echo -e "╝${RST}"
}

draw_line() {
    local char="${1:-─}"
    local width=${2:-$((TERM_COLS - 8))}
    local color="${3:-${T_BORDER}}"
    [ $width -gt 60 ] && width=60
    echo -ne "    ${color}"
    for ((i=0; i<width; i++)); do echo -ne "$char"; done
    echo -e "${RST}"
}

draw_double_line() {
    draw_line "═" "${1:-60}" "${2:-${T_PRIMARY}}"
}

# ─── MENU ITEM RENDERER ─────────────────────────────
menu_item() {
    local num="$1"
    local icon="$2"
    local text="$3"
    local width=${4:-52}
    local entry="${T_SUCCESS}[${WH}${BLD}${num}${RST}${T_SUCCESS}]${RST} ${icon} ${T_INFO}${text}${RST}"
    draw_box_line $width "$entry"
}

menu_item_red() {
    local num="$1"
    local icon="$2"
    local text="$3"
    local width=${4:-52}
    local entry="${T_ERROR}[${WH}${BLD}${num}${RST}${T_ERROR}]${RST} ${icon} ${T_ERROR}${text}${RST}"
    draw_box_line $width "$entry"
}

# ─── STATUS BADGES ──────────────────────────────────
badge_ok()   { echo -ne " ${BGG}${BK}${BLD} ✓ OK ${RST} "; }
badge_fail() { echo -ne " ${BGR}${WH}${BLD} ✗ FAIL ${RST} "; }
badge_warn() { echo -ne " ${BGY}${BK}${BLD} ! WARN ${RST} "; }
badge_info() { echo -ne " ${BGB}${WH}${BLD} ℹ INFO ${RST} "; }
badge_new()  { echo -ne " ${BGM}${WH}${BLD} ★ NEW ${RST} "; }

# ══════════════════════════════════════════════════════════════
#  SECTION 4: KYYINFINITE MEGA BANNER SYSTEM
# ══════════════════════════════════════════════════════════════

banner_style_1() {
    # ─── PHANTOM CYBER BANNER ────────────────────────
    echo ""
    echo -e "    \033[38;5;33m ▄█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█▄${RST}"
    echo -e "    \033[38;5;33m █                                                    █${RST}"
    gradient_text "      ██╗  ██╗██╗   ██╗██╗   ██╗" 255 60 180 60 180 255
    gradient_text "      ██║ ██╔╝╚██╗ ██╔╝╚██╗ ██╔╝" 255 80 160 80 160 255
    gradient_text "      █████╔╝  ╚████╔╝  ╚████╔╝ " 255 100 140 100 140 255
    gradient_text "      ██╔═██╗   ╚██╔╝    ╚██╔╝  " 200 120 120 120 120 255
    gradient_text "      ██║  ██╗   ██║      ██║    " 180 140 100 140 100 255
    gradient_text "      ╚═╝  ╚═╝   ╚═╝      ╚═╝    " 160 160 80 160 80 255
    echo ""
    gradient_text "       ╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗" 0 255 200 255 100 0
    gradient_text "       ║║║║╠╣ ║║║║║ ║ ║╣ " 50 255 150 255 50 50
    gradient_text "       ╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝" 100 255 100 255 0 100
    echo ""
    echo -e "    \033[38;5;33m █                                                    █${RST}"
    echo -e "    \033[38;5;33m ▀█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█▀${RST}"
}

banner_style_2() {
    # ─── NEON FLAME BANNER ───────────────────────────
    echo ""
    echo -e "    \033[38;5;196m    ▄▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄${RST}"
    echo -e "    \033[38;5;196m   █ ${RST}\033[38;5;208m░▒▓█${RST}\033[1;38;5;226m K Y Y ${RST}\033[38;5;208m█▓▒░${RST}                                   \033[38;5;196m█${RST}"
    echo -e "    \033[38;5;202m   █${RST}                                                  \033[38;5;202m█${RST}"
    echo -e "    \033[38;5;208m   █${RST}  \033[1;38;5;51m██╗  ██╗${RST} \033[1;38;5;87m██╗   ██╗${RST} \033[1;38;5;123m██╗   ██╗${RST}                  \033[38;5;208m█${RST}"
    echo -e "    \033[38;5;214m   █${RST}  \033[1;38;5;51m██║ ██╔╝${RST} \033[1;38;5;87m╚██╗ ██╔╝${RST} \033[1;38;5;123m╚██╗ ██╔╝${RST}                \033[38;5;214m█${RST}"
    echo -e "    \033[38;5;220m   █${RST}  \033[1;38;5;51m█████╔╝${RST}  \033[1;38;5;87m╚████╔╝${RST}  \033[1;38;5;123m╚████╔╝${RST}                 \033[38;5;220m█${RST}"
    echo -e "    \033[38;5;226m   █${RST}  \033[1;38;5;51m██╔═██╗${RST}  \033[1;38;5;87m ╚██╔╝${RST}   \033[1;38;5;123m ╚██╔╝${RST}                   \033[38;5;226m█${RST}"
    echo -e "    \033[38;5;190m   █${RST}  \033[1;38;5;51m██║  ██╗${RST} \033[1;38;5;87m  ██║${RST}    \033[1;38;5;123m  ██║${RST}                     \033[38;5;190m█${RST}"
    echo -e "    \033[38;5;154m   █${RST}  \033[1;38;5;51m╚═╝  ╚═╝${RST} \033[1;38;5;87m  ╚═╝${RST}    \033[1;38;5;123m  ╚═╝${RST}                     \033[38;5;154m█${RST}"
    echo -e "    \033[38;5;118m   █${RST}                                                  \033[38;5;118m█${RST}"
    echo -e "    \033[38;5;82m   █${RST}  \033[1;38;5;213m╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗${RST}  \033[38;5;245m● Ultimate Framework${RST}  \033[38;5;82m█${RST}"
    echo -e "    \033[38;5;46m   █${RST}  \033[1;38;5;213m║║║║╠╣ ║║║║║ ║ ║╣${RST}   \033[38;5;245m● Version ${VERSION}${RST}       \033[38;5;46m█${RST}"
    echo -e "    \033[38;5;47m   █${RST}  \033[1;38;5;213m╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝${RST}  \033[38;5;245m● Codename: ${CODENAME}${RST}   \033[38;5;47m█${RST}"
    echo -e "    \033[38;5;48m   █${RST}                                               \033[38;5;48m█${RST}"
    echo -e "    \033[38;5;49m    ▀▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▀${RST}"
}

banner_style_3() {
    # ─── MINIMAL ELEGANT BANNER ──────────────────────
    echo ""
    echo -e "    ${T_BORDER}┌────────────────────────────────────────────────────┐${RST}"
    echo -e "    ${T_BORDER}│${RST}                                                    ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  ${BLD}\033[38;5;39m╔═╗  ╔═╗${RST}                                       ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  ${BLD}\033[38;5;39m║ ╠╦╝ ║${RST}  \033[38;5;255m${BLD}K y y I n f i n i t e${RST}              ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  ${BLD}\033[38;5;39m╚═╝╚══╝${RST}  \033[38;5;245m${ITA}Phantom Framework v${VERSION}${RST}            ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}                                                    ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  \033[38;5;240m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}  ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}                                                    ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  \033[38;5;245m◉ Author  :${RST} \033[38;5;39m${AUTHOR}${RST}                        ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  \033[38;5;245m◉ Version :${RST} \033[38;5;46m${VERSION} (${CODENAME})${RST}                   ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  \033[38;5;245m◉ Build   :${RST} \033[38;5;208m${BUILD_DATE}${RST}                            ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}  \033[38;5;245m◉ Session :${RST} \033[38;5;213m#${TOTAL_LAUNCHES}${RST}                              ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST}                                                    ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}└────────────────────────────────────────────────────┘${RST}"
}

banner_style_4() {
    # ─── DRAGON/SKULL ASCII HACKER BANNER ────────────
    echo ""
    echo -e "    \033[38;5;196m         ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄${RST}"
    echo -e "    \033[38;5;196m       ▄█${RST}\033[38;5;208m░░░░░░░░░░░░░░░░░░░░░░░░░░░${RST}\033[38;5;196m█▄${RST}"
    echo -e "    \033[38;5;196m      █${RST}\033[38;5;208m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${RST}\033[38;5;196m█${RST}"
    echo -e "    \033[38;5;202m      █${RST}\033[38;5;214m░░░${RST}\033[1;38;5;255m▄▀▀▀▄${RST}\033[38;5;214m░░░░░░░░░░░░░${RST}\033[1;38;5;255m▄▀▀▀▄${RST}\033[38;5;214m░░░${RST}\033[38;5;202m█${RST}"
    echo -e "    \033[38;5;208m      █${RST}\033[38;5;220m░░░${RST}\033[1;38;5;255m█ ◉ █${RST}\033[38;5;220m░░░${RST}\033[1;38;5;196m▄▀▀▀▄${RST}\033[38;5;220m░░░${RST}\033[1;38;5;255m█ ◉ █${RST}\033[38;5;220m░░░${RST}\033[38;5;208m█${RST}"
    echo -e "    \033[38;5;214m      █${RST}\033[38;5;226m░░░${RST}\033[1;38;5;255m▀▄▄▄▀${RST}\033[38;5;226m░░░${RST}\033[1;38;5;196m▀▄▄▄▀${RST}\033[38;5;226m░░░${RST}\033[1;38;5;255m▀▄▄▄▀${RST}\033[38;5;226m░░░${RST}\033[38;5;214m█${RST}"
    echo -e "    \033[38;5;220m      █${RST}\033[38;5;228m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░${RST}\033[38;5;220m█${RST}"
    echo -e "    \033[38;5;226m      █${RST}\033[38;5;230m░░░░░░${RST}\033[1;38;5;196m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${RST}\033[38;5;230m░░░░░░${RST}\033[38;5;226m█${RST}"
    echo -e "    \033[38;5;228m       ▀█${RST}\033[38;5;230m░░░░░░░░░░░░░░░░░░░░░░░░░░░${RST}\033[38;5;228m█▀${RST}"
    echo -e "    \033[38;5;230m         ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀${RST}"
    echo ""
    center_text "${BLD}\033[38;5;39mK Y Y  ${RST}\033[38;5;213mI N F I N I T E${RST}"
    center_text "${DIM}\033[38;5;245mP H A N T O M   F R A M E W O R K   v${VERSION}${RST}"
}

banner_style_5() {
    # ─── HEXAGONAL TECH BANNER ───────────────────────
    echo ""
    echo -e "    \033[38;5;39m    ╱╲     ╱╲     ╱╲     ╱╲     ╱╲     ╱╲     ╱╲${RST}"
    echo -e "    \033[38;5;39m   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲${RST}"
    echo -e "    \033[38;5;33m  ╱ ${RST}\033[1;38;5;196mK${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;208mY${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;226mY${RST}\033[38;5;33m  ╲ ╱    ╲ ╱ ${RST}\033[1;38;5;46mI${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;51mN${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;213mF${RST}\033[38;5;33m  ╲${RST}"
    echo -e "    \033[38;5;33m  ╲    ╱ ╲    ╱ ╲    ╱ ╲ ${RST}\033[1;38;5;255m◆${RST}\033[38;5;33m  ╱ ╲    ╱ ╲    ╱ ╲    ╱${RST}"
    echo -e "    \033[38;5;27m   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱${RST}"
    echo -e "    \033[38;5;27m    ╲╱     ╲╱     ╲╱     ╲╱     ╲╱     ╲╱     ╲╱${RST}"
    echo ""
    echo -e "    \033[38;5;39m   ╱╲     ╱╲     ╱╲     ╱╲     ╱╲     ╱╲${RST}"
    echo -e "    \033[38;5;39m  ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲   ╱  ╲${RST}"
    echo -e "    \033[38;5;33m ╱ ${RST}\033[1;38;5;87mI${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;123mN${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;159mI${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;195mT${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;231mE${RST}\033[38;5;33m  ╲ ╱ ${RST}\033[1;38;5;255m!${RST}\033[38;5;33m  ╲${RST}"
    echo -e "    \033[38;5;33m ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲    ╱${RST}"
    echo -e "    \033[38;5;27m  ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲  ╱${RST}"
    echo -e "    \033[38;5;27m   ╲╱     ╲╱     ╲╱     ╲╱     ╲╱     ╲╱${RST}"
    echo ""
    center_text "\033[38;5;245m${DIM}━━━━━ PHANTOM FRAMEWORK v${VERSION} ━━━━━${RST}"
}

# ─── BANNER SELECTOR ────────────────────────────────
show_banner() {
    case "${CURRENT_THEME}" in
        phantom|default)  banner_style_1 ;;
        neon|flame)       banner_style_2 ;;
        minimal|elegant)  banner_style_3 ;;
        hacker|skull)     banner_style_4 ;;
        hex|tech)         banner_style_5 ;;
        *)                banner_style_2 ;;
    esac
}

# ══════════════════════════════════════════════════════════════
#  SECTION 5: THEME ENGINE (10+ THEMES)
# ══════════════════════════════════════════════════════════════

apply_theme() {
    local theme="$1"
    CURRENT_THEME="$theme"
    
    case "$theme" in
        phantom)
            T_PRIMARY='\033[38;5;39m'
            T_SECONDARY='\033[38;5;33m'
            T_ACCENT='\033[38;5;213m'
            T_SUCCESS='\033[38;5;46m'
            T_WARNING='\033[38;5;226m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;87m'
            T_MUTED='\033[38;5;245m'
            T_HIGHLIGHT='\033[38;5;51m'
            T_BORDER='\033[38;5;33m'
            ;;
        neon)
            T_PRIMARY='\033[38;5;201m'
            T_SECONDARY='\033[38;5;199m'
            T_ACCENT='\033[38;5;51m'
            T_SUCCESS='\033[38;5;118m'
            T_WARNING='\033[38;5;226m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;87m'
            T_MUTED='\033[38;5;244m'
            T_HIGHLIGHT='\033[38;5;213m'
            T_BORDER='\033[38;5;201m'
            ;;
        dracula)
            T_PRIMARY='\033[38;5;141m'
            T_SECONDARY='\033[38;5;212m'
            T_ACCENT='\033[38;5;84m'
            T_SUCCESS='\033[38;5;84m'
            T_WARNING='\033[38;5;228m'
            T_ERROR='\033[38;5;210m'
            T_INFO='\033[38;5;117m'
            T_MUTED='\033[38;5;61m'
            T_HIGHLIGHT='\033[38;5;212m'
            T_BORDER='\033[38;5;61m'
            ;;
        matrix)
            T_PRIMARY='\033[38;5;46m'
            T_SECONDARY='\033[38;5;34m'
            T_ACCENT='\033[38;5;82m'
            T_SUCCESS='\033[38;5;46m'
            T_WARNING='\033[38;5;154m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;118m'
            T_MUTED='\033[38;5;22m'
            T_HIGHLIGHT='\033[38;5;255m'
            T_BORDER='\033[38;5;34m'
            ;;
        ocean)
            T_PRIMARY='\033[38;5;39m'
            T_SECONDARY='\033[38;5;45m'
            T_ACCENT='\033[38;5;87m'
            T_SUCCESS='\033[38;5;49m'
            T_WARNING='\033[38;5;221m'
            T_ERROR='\033[38;5;203m'
            T_INFO='\033[38;5;123m'
            T_MUTED='\033[38;5;67m'
            T_HIGHLIGHT='\033[38;5;159m'
            T_BORDER='\033[38;5;24m'
            ;;
        sunset)
            T_PRIMARY='\033[38;5;208m'
            T_SECONDARY='\033[38;5;202m'
            T_ACCENT='\033[38;5;214m'
            T_SUCCESS='\033[38;5;226m'
            T_WARNING='\033[38;5;220m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;215m'
            T_MUTED='\033[38;5;130m'
            T_HIGHLIGHT='\033[38;5;228m'
            T_BORDER='\033[38;5;166m'
            ;;
        nord)
            T_PRIMARY='\033[38;5;110m'
            T_SECONDARY='\033[38;5;109m'
            T_ACCENT='\033[38;5;139m'
            T_SUCCESS='\033[38;5;108m'
            T_WARNING='\033[38;5;179m'
            T_ERROR='\033[38;5;174m'
            T_INFO='\033[38;5;110m'
            T_MUTED='\033[38;5;60m'
            T_HIGHLIGHT='\033[38;5;152m'
            T_BORDER='\033[38;5;60m'
            ;;
        blood)
            T_PRIMARY='\033[38;5;196m'
            T_SECONDARY='\033[38;5;124m'
            T_ACCENT='\033[38;5;160m'
            T_SUCCESS='\033[38;5;46m'
            T_WARNING='\033[38;5;208m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;203m'
            T_MUTED='\033[38;5;52m'
            T_HIGHLIGHT='\033[38;5;255m'
            T_BORDER='\033[38;5;88m'
            ;;
        sakura)
            T_PRIMARY='\033[38;5;213m'
            T_SECONDARY='\033[38;5;218m'
            T_ACCENT='\033[38;5;225m'
            T_SUCCESS='\033[38;5;157m'
            T_WARNING='\033[38;5;222m'
            T_ERROR='\033[38;5;203m'
            T_INFO='\033[38;5;219m'
            T_MUTED='\033[38;5;132m'
            T_HIGHLIGHT='\033[38;5;231m'
            T_BORDER='\033[38;5;175m'
            ;;
        gold)
            T_PRIMARY='\033[38;5;220m'
            T_SECONDARY='\033[38;5;178m'
            T_ACCENT='\033[38;5;214m'
            T_SUCCESS='\033[38;5;46m'
            T_WARNING='\033[38;5;226m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;228m'
            T_MUTED='\033[38;5;136m'
            T_HIGHLIGHT='\033[38;5;231m'
            T_BORDER='\033[38;5;136m'
            ;;
        cyberpunk)
            T_PRIMARY='\033[38;5;198m'
            T_SECONDARY='\033[38;5;51m'
            T_ACCENT='\033[38;5;226m'
            T_SUCCESS='\033[38;5;46m'
            T_WARNING='\033[38;5;208m'
            T_ERROR='\033[38;5;196m'
            T_INFO='\033[38;5;87m'
            T_MUTED='\033[38;5;240m'
            T_HIGHLIGHT='\033[38;5;255m'
            T_BORDER='\033[38;5;93m'
            ;;
        arctic)
            T_PRIMARY='\033[38;5;159m'
            T_SECONDARY='\033[38;5;153m'
            T_ACCENT='\033[38;5;195m'
            T_SUCCESS='\033[38;5;158m'
            T_WARNING='\033[38;5;229m'
            T_ERROR='\033[38;5;210m'
            T_INFO='\033[38;5;189m'
            T_MUTED='\033[38;5;103m'
            T_HIGHLIGHT='\033[38;5;231m'
            T_BORDER='\033[38;5;103m'
            ;;
    esac
    
    save_config
    log_msg "Theme changed to: $theme"
}

theme_preview() {
    local theme="$1"
    apply_theme "$theme"
    echo -e "    ${T_BORDER}┌──────────────────────────────┐${RST}"
    echo -e "    ${T_BORDER}│${RST} ${T_PRIMARY}■${RST} Primary  ${T_SECONDARY}■${RST} Secondary        ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST} ${T_ACCENT}■${RST} Accent   ${T_SUCCESS}■${RST} Success          ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST} ${T_WARNING}■${RST} Warning  ${T_ERROR}■${RST} Error            ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}│${RST} ${T_INFO}■${RST} Info     ${T_HIGHLIGHT}■${RST} Highlight        ${T_BORDER}│${RST}"
    echo -e "    ${T_BORDER}└──────────────────────────────┘${RST}"
}

theme_menu() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ 🎨 THEME MANAGER ━━━━━${RST}"
    echo ""
    
    local themes=("phantom" "neon" "dracula" "matrix" "ocean" "sunset" "nord" "blood" "sakura" "gold" "cyberpunk" "arctic")
    local icons=("👻" "💡" "🧛" "🟢" "🌊" "🌅" "❄️" "🩸" "🌸" "👑" "🤖" "🏔️")
    local descriptions=("Cyber Blue+Pink" "Hot Pink+Cyan" "Purple+Green" "Green Terminal" "Blue+Teal" "Orange+Red" "Cool Nordic" "Dark Red" "Soft Pink" "Royal Gold" "Neon Chaos" "Ice White")
    
    local W=52
    draw_box $W "SELECT THEME"
    draw_box_empty $W
    
    for ((i=0; i<${#themes[@]}; i++)); do
        local num=$(printf "%02d" $((i+1)))
        local active=""
        [ "${themes[$i]}" = "$CURRENT_THEME" ] && active=" ${T_SUCCESS}◄ ACTIVE${RST}"
        local entry="${T_SUCCESS}[${WH}${BLD}${num}${RST}${T_SUCCESS}]${RST} ${icons[$i]}  ${T_INFO}${themes[$i]^}${RST} ${T_MUTED}— ${descriptions[$i]}${RST}${active}"
        draw_box_line $W "$entry"
    done
    
    draw_box_empty $W
    draw_box_separator $W
    menu_item "13" "🖌️" "Custom RGB Theme" $W
    menu_item "14" "👁️" "Preview All Themes" $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu" $W
    draw_box_empty $W
    draw_box_bottom $W
    
    echo ""
    echo -ne "    ${T_WARNING}⮞  Select theme ${WH}[${T_SUCCESS}01-14${WH}/${T_ERROR}00${WH}]${T_WARNING}: ${T_SUCCESS}"
    read choice
    echo -e "${RST}"
    
    case $choice in
        01|1)  apply_theme "phantom"; echo -e "    $(badge_ok) Theme: Phantom applied!"; sleep 1; theme_menu ;;
        02|2)  apply_theme "neon"; echo -e "    $(badge_ok) Theme: Neon applied!"; sleep 1; theme_menu ;;
        03|3)  apply_theme "dracula"; echo -e "    $(badge_ok) Theme: Dracula applied!"; sleep 1; theme_menu ;;
        04|4)  apply_theme "matrix"; echo -e "    $(badge_ok) Theme: Matrix applied!"; sleep 1; theme_menu ;;
        05|5)  apply_theme "ocean"; echo -e "    $(badge_ok) Theme: Ocean applied!"; sleep 1; theme_menu ;;
        06|6)  apply_theme "sunset"; echo -e "    $(badge_ok) Theme: Sunset applied!"; sleep 1; theme_menu ;;
        07|7)  apply_theme "nord"; echo -e "    $(badge_ok) Theme: Nord applied!"; sleep 1; theme_menu ;;
        08|8)  apply_theme "blood"; echo -e "    $(badge_ok) Theme: Blood applied!"; sleep 1; theme_menu ;;
        09|9)  apply_theme "sakura"; echo -e "    $(badge_ok) Theme: Sakura applied!"; sleep 1; theme_menu ;;
        10)    apply_theme "gold"; echo -e "    $(badge_ok) Theme: Gold applied!"; sleep 1; theme_menu ;;
        11)    apply_theme "cyberpunk"; echo -e "    $(badge_ok) Theme: Cyberpunk applied!"; sleep 1; theme_menu ;;
        12)    apply_theme "arctic"; echo -e "    $(badge_ok) Theme: Arctic applied!"; sleep 1; theme_menu ;;
        13)    custom_rgb_theme ;;
        14)    preview_all_themes ;;
        00|0)  main_menu ;;
        *)     echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; theme_menu ;;
    esac
}

custom_rgb_theme() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ 🖌️ CUSTOM RGB THEME ━━━━━${RST}"
    echo ""
    echo -e "    ${T_INFO}Enter RGB values (0-255) for primary color:${RST}"
    echo -ne "    ${T_WARNING}Red   : ${T_SUCCESS}"; read cr
    echo -ne "    ${T_WARNING}Green : ${T_SUCCESS}"; read cg
    echo -ne "    ${T_WARNING}Blue  : ${T_SUCCESS}"; read cb
    echo -e "${RST}"
    
    cr=${cr:-0}; cg=${cg:-200}; cb=${cb:-255}
    
    T_PRIMARY="\033[38;2;${cr};${cg};${cb}m"
    T_BORDER="\033[38;2;$((cr/2));$((cg/2));$((cb/2))m"
    CURRENT_THEME="custom"
    
    echo -e "    ${T_PRIMARY}██████████████████████████████${RST}"
    echo -e "    ${T_PRIMARY}█  Your custom theme color!  █${RST}"
    echo -e "    ${T_PRIMARY}██████████████████████████████${RST}"
    echo ""
    echo -e "    $(badge_ok) Custom theme applied!"
    
    save_config
    sleep 2
    theme_menu
}

preview_all_themes() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ 👁️ THEME PREVIEWS ━━━━━${RST}"
    echo ""
    
    local themes=("phantom" "neon" "dracula" "matrix" "ocean" "sunset" "nord" "blood" "sakura" "gold" "cyberpunk" "arctic")
    local saved_theme="$CURRENT_THEME"
    
    for theme in "${themes[@]}"; do
        echo -e "    ${BLD}${WH}▸ ${theme^}:${RST}"
        theme_preview "$theme"
        echo ""
    done
    
    apply_theme "$saved_theme"
    
    echo -ne "    ${T_WARNING}Press [ENTER] to go back...${RST}"
    read
    theme_menu
}

# ══════════════════════════════════════════════════════════════
#  SECTION 6: CUSTOM PROMPT SYSTEM
# ══════════════════════════════════════════════════════════════

prompt_menu() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ ⚡ PROMPT CUSTOMIZER ━━━━━${RST}"
    echo ""
    
    local W=52
    draw_box $W "CUSTOM PROMPT"
    draw_box_empty $W
    
    local prompts=(
        "┌──[\u@\h]─[\w]\n└──╼ \$ "
        "╭─[\033[38;5;39m\u\033[0m@\033[38;5;208m\h\033[0m]─[\033[38;5;46m\w\033[0m]\n╰─➤ "
        "\033[38;5;196m⚡\033[0m \033[38;5;39m\u\033[0m:\033[38;5;46m\w\033[0m \033[38;5;213m❯❯❯\033[0m "
        "\033[38;5;51m[\033[38;5;213m★\033[38;5;51m]\033[0m─\033[38;5;51m[\033[38;5;46m\w\033[38;5;51m]\033[0m\n \033[38;5;213m↪\033[0m "
        "\033[48;5;234m \033[38;5;39m\u \033[48;5;24m\033[38;5;234m\033[38;5;255m \w \033[0m\033[38;5;24m\033[0m "
        "\033[38;5;208m╔═══\033[38;5;226m[\033[38;5;46mKyy\033[38;5;226m@\033[38;5;39m\h\033[38;5;226m]\033[38;5;208m═══\033[38;5;226m[\033[38;5;213m\w\033[38;5;226m]\n\033[38;5;208m╚═══\033[38;5;196m❯\033[38;5;226m❯\033[38;5;46m❯\033[0m "
        "\033[38;5;240m┃ \033[38;5;39m\w \033[38;5;240m┃\n\033[38;5;240m┗━\033[38;5;46m➜\033[0m  "
        "\033[38;5;196m[\033[38;5;255m\T\033[38;5;196m] \033[38;5;39m\u\033[38;5;245m@\033[38;5;213m\w \033[38;5;46m\$\033[0m "
        "\033[38;5;33m⌬ \033[38;5;255m\u \033[38;5;245min \033[38;5;87m\w\n\033[38;5;33m⌊ \033[38;5;46m➤\033[0m "
        "\033[38;5;198m░▒▓ \033[38;5;255mKyyInfinite \033[38;5;198m▓▒░ \033[38;5;245m[\033[38;5;87m\w\033[38;5;245m]\n\033[38;5;198m  ➜\033[0m "
    )
    
    local names=(
        "Classic Hacker"
        "Rounded Cyber"
        "Lightning Bolt"
        "Star Navigator"
        "Powerline Style"
        "KyyInfinite Special"
        "Minimal Box"
        "Timestamp Pro"
        "Diamond Shell"
        "Neon Signature"
    )
    
    for ((i=0; i<${#names[@]}; i++)); do
        local num=$(printf "%02d" $((i+1)))
        menu_item "$num" "◆" "${names[$i]}" $W
    done
    
    draw_box_empty $W
    draw_box_separator $W
    menu_item "11" "✏️" "Write Custom Prompt" $W
    menu_item "12" "🔄" "Reset to Default" $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu" $W
    draw_box_empty $W
    draw_box_bottom $W
    
    echo ""
    echo -ne "    ${T_WARNING}⮞  Select prompt: ${T_SUCCESS}"
    read choice
    echo -e "${RST}"
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le 10 ]; then
        local idx=$((choice - 1))
        local selected="${prompts[$idx]}"
        
        echo ""
        echo -e "    ${T_INFO}Preview:${RST}"
        echo -e "    ${selected}ls -la${RST}"
        echo ""
        echo -ne "    ${T_WARNING}Apply this prompt? [y/n]: ${T_SUCCESS}"
        read confirm
        echo -e "${RST}"
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            # Write to .bashrc
            local bashrc="$HOME/.bashrc"
            
            # Remove old custom prompt
            sed -i '/# KyyInfinite Custom Prompt/,/# End KyyInfinite Prompt/d' "$bashrc" 2>/dev/null
            
            # Add new prompt
            cat >> "$bashrc" << PROMPT_END
# KyyInfinite Custom Prompt
export PS1="${selected}"
# End KyyInfinite Prompt
PROMPT_END
            
            export PS1="${selected}"
            CUSTOM_PROMPT="${names[$idx]}"
            save_config
            
            echo -e "    $(badge_ok) Prompt '${names[$idx]}' applied!"
            echo -e "    ${T_MUTED}Restart terminal or run: source ~/.bashrc${RST}"
        fi
    elif [ "$choice" = "11" ]; then
        echo -ne "    ${T_WARNING}Enter custom PS1: ${T_SUCCESS}"
        read custom_ps1
        echo -e "${RST}"
        if [ -n "$custom_ps1" ]; then
            local bashrc="$HOME/.bashrc"
            sed -i '/# KyyInfinite Custom Prompt/,/# End KyyInfinite Prompt/d' "$bashrc" 2>/dev/null
            echo -e "\n# KyyInfinite Custom Prompt\nexport PS1=\"${custom_ps1}\"\n# End KyyInfinite Prompt" >> "$bashrc"
            export PS1="${custom_ps1}"
            echo -e "    $(badge_ok) Custom prompt applied!"
        fi
    elif [ "$choice" = "12" ]; then
        local bashrc="$HOME/.bashrc"
        sed -i '/# KyyInfinite Custom Prompt/,/# End KyyInfinite Prompt/d' "$bashrc" 2>/dev/null
        unset PS1
        source "$bashrc" 2>/dev/null
        echo -e "    $(badge_ok) Prompt reset to default!"
    elif [ "$choice" = "00" ] || [ "$choice" = "0" ]; then
        main_menu
        return
    fi
    
    sleep 2
    prompt_menu
}

# ══════════════════════════════════════════════════════════════
#  SECTION 7: TERMUX BANNER / MOTD CUSTOMIZER
# ══════════════════════════════════════════════════════════════

termux_banner_menu() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ 🖼️ TERMUX BANNER MANAGER ━━━━━${RST}"
    echo ""
    
    local W=52
    draw_box $W "BANNER / MOTD STYLES"
    draw_box_empty $W
    menu_item "01" "👻" "Phantom Skull Banner" $W
    menu_item "02" "🐉" "Dragon Banner" $W
    menu_item "03" "⚔️" "Sword & Shield Banner" $W
    menu_item "04" "🌌" "Galaxy Banner" $W
    menu_item "05" "💀" "Hacker Anonymous Banner" $W
    menu_item "06" "🔥" "Fire Logo Banner" $W
    menu_item "07" "🎮" "Retro Game Banner" $W
    menu_item "08" "🌊" "Wave Banner" $W
    menu_item "09" "🤖" "Robot/Android Banner" $W
    menu_item "10" "✨" "KyyInfinite Signature" $W
    draw_box_empty $W
    draw_box_separator $W
    menu_item "11" "✏️" "Custom Text Banner (figlet)" $W
    menu_item "12" "🗑️" "Remove Banner / Reset" $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu" $W
    draw_box_empty $W
    draw_box_bottom $W
    
    echo ""
    echo -ne "    ${T_WARNING}⮞  Select: ${T_SUCCESS}"
    read choice
    echo -e "${RST}"
    
    local motd_file="$PREFIX/etc/motd"
    local bashrc="$HOME/.bashrc"
    
    case $choice in
        01|1) install_banner_skull ;;
        02|2) install_banner_dragon ;;
        03|3) install_banner_sword ;;
        04|4) install_banner_galaxy ;;
        05|5) install_banner_anon ;;
        06|6) install_banner_fire ;;
        07|7) install_banner_retro ;;
        08|8) install_banner_wave ;;
        09|9) install_banner_robot ;;
        10)   install_banner_kyy ;;
        11)   install_banner_custom ;;
        12)
            echo "" > "$motd_file" 2>/dev/null
            sed -i '/# KyyInfinite MOTD/,/# End KyyInfinite MOTD/d' "$bashrc" 2>/dev/null
            echo -e "    $(badge_ok) Banner removed!"
            sleep 1
            termux_banner_menu
            ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; termux_banner_menu ;;
    esac
}

write_banner_to_bashrc() {
    local banner_content="$1"
    local bashrc="$HOME/.bashrc"
    
    # Remove old banner
    sed -i '/# KyyInfinite MOTD/,/# End KyyInfinite MOTD/d' "$bashrc" 2>/dev/null
    
    # Add new banner
    cat >> "$bashrc" << 'BANNER_START'
# KyyInfinite MOTD
BANNER_START
    echo "$banner_content" >> "$bashrc"
    cat >> "$bashrc" << 'BANNER_END'
# End KyyInfinite MOTD
BANNER_END
    
    echo "" > "$PREFIX/etc/motd" 2>/dev/null
    
    echo ""
    echo -e "    $(badge_ok) Banner installed!"
    echo -e "    ${T_MUTED}Restart Termux to see the banner${RST}"
    echo ""
    echo -e "    ${T_INFO}Preview:${RST}"
    echo ""
    eval "$banner_content"
    echo ""
    echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"
    read
    termux_banner_menu
}

install_banner_skull() {
    local banner='
echo -e "\033[38;5;196m"
echo "          ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄          "
echo "       ▄██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██▄       "
echo "      ██▀                     ▀██      "
echo "     ██   ▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄   ██     "
echo "     ██   ██▀▀▀██   ██▀▀▀██   ██     "
echo "     ██   ██   ██   ██   ██   ██     "
echo "     ██   ▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀   ██     "
echo -e "\033[38;5;208m"
echo "     ██         ▄▄▄▄▄         ██     "
echo "     ▀██       ██▀▀▀██       ██▀     "
echo "      ▀██     ▀▀▀▀▀▀▀▀▀    ██▀      "
echo "       ▀██   ▀▄▀ ▀▄▀ ▀▄▀  ██▀       "
echo "        ▀▀██▄▄▄▄▄▄▄▄▄▄▄██▀▀        "
echo -e "\033[38;5;39m"
echo " ╔═══════════════════════════════════╗"
echo " ║     KyyInfinite Framework v3.0    ║"
echo " ║   Welcome back, $(whoami)!    ║"
echo " ╚═══════════════════════════════════╝"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_dragon() {
    local banner='
echo -e "\033[38;5;46m"
echo "                 ______________        "
echo "               .~  ~.  |           \   "
echo "              /  KYY  \.|  INFINITE  \  "
echo "             |  ◉   ◉  |_____________/ "
echo "             \    <>   /                "
echo "              \  ===  /                 "
echo "           ___/\____/\___              "
echo "          /    \      /    \             "
echo "         /  /\  \    /  /\  \            "
echo -e "\033[38;5;39m"
echo "   ╔══════════════════════════════════╗ "
echo "   ║  🐉  KyyInfinite Dragon Shell   ║ "
echo "   ║  📅  $(date +%Y-%m-%d)   ⏰  $(date +%H:%M)        ║ "
echo "   ╚══════════════════════════════════╝ "
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_sword() {
    local banner='
echo -e "\033[38;5;214m"
echo "              ⚔️  KyyInfinite  ⚔️"
echo ""
echo "         ┌─────────────────────────┐"
echo "         │    /\       /\          │"
echo "         │   /  \     /  \         │"
echo "         │  / ◆  \   / ◆  \        │"
echo "         │ /______\ /______\       │"
echo "         │    ||       ||          │"
echo "         │    ||       ||          │"
echo "         │   ╔══╗     ╔══╗         │"
echo "         │   ╚══╝     ╚══╝         │"
echo "         └─────────────────────────┘"
echo -e "\033[38;5;255m"
echo "      Welcome, warrior $(whoami)!"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_galaxy() {
    local banner='
echo -e "\033[38;5;33m     .  ✦   .    ·    .  ★  .    · ✦  .  ${RST}"
echo -e "\033[38;5;39m  ·    .  ★   ·   ✦  .    .  ·  ★    ·   ${RST}"
echo -e "\033[38;5;45m    ✦    ·    .  ★   .  ✦  ·    .   ★  ·  ${RST}"
echo -e "\033[38;5;87m  ·  🌌  ╔══════════════════════╗  🌌  ·   ${RST}"
echo -e "\033[38;5;123m  ★     ║  K Y Y I N F I N I T E ║     ★   ${RST}"
echo -e "\033[38;5;159m  ·     ║  Galaxy Framework v3  ║     ·   ${RST}"
echo -e "\033[38;5;195m  ✦     ╚══════════════════════╝     ✦   ${RST}"
echo -e "\033[38;5;51m    ·  ★  .  ✦   ·  .  ★  ·  .  ✦  ·     ${RST}"
echo -e "\033[38;5;45m  .   ·  ✦  ·   ★  .   ·  ✦   .  ·  ★    ${RST}"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_anon() {
    local banner='
echo -e "\033[38;5;46m"
echo "         ██████████████████████████"
echo "         █─────────────────────────█"
echo "         █──██████─────██████──────█"
echo "         █──██████─────██████──────█"
echo "         █─────────────────────────█"
echo "         █───────███████───────────█"
echo "         █──────█████████──────────█"
echo "         █─────███─███─███─────────█"
echo "         █──────███████████────────█"
echo "         ██████████████████████████"
echo -e "\033[38;5;39m"
echo "    ╔════════════════════════════════╗"
echo "    ║   We are KyyInfinite           ║"
echo "    ║   Expect the unexpected        ║"
echo "    ╚════════════════════════════════╝"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_fire() {
    local banner='
echo -e "\033[38;5;196m         (  .      )         "
echo -e "\033[38;5;202m      )           (     (    "
echo -e "\033[38;5;208m            .  \x27   )    )   "
echo -e "\033[38;5;214m    (    . \x27  )    (   (     "
echo -e "\033[38;5;220m     )       )     )    )   "
echo -e "\033[38;5;226m   (   (    (     (    (     "
echo -e "\033[38;5;228m  ████████████████████████   "
echo -e "\033[38;5;255m  █ K Y Y  INFINITE v3.0█   "
echo -e "\033[38;5;228m  ████████████████████████   "
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_retro() {
    local banner='
echo -e "\033[38;5;39m"
echo "  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "  ┃  ╦╔═╦ ╦╦ ╦  ╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗    ┃"
echo "  ┃  ╠╩╗╚╦╝╚╦╝  ║║║║╠╣ ║║║║║ ║ ║╣     ┃"
echo "  ┃  ╩ ╩ ╩  ╩   ╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝    ┃"
echo "  ┃                                      ┃"
echo "  ┃  ▸ PLAYER: $(whoami)                  ┃"
echo "  ┃  ▸ LEVEL : ∞                        ┃"
echo "  ┃  ▸ HP    : ████████████ 100%        ┃"
echo "  ┃  ▸ DATE  : $(date +%Y-%m-%d)                  ┃"
echo "  ┃                                      ┃"
echo "  ┃  🎮 INSERT COIN TO CONTINUE...       ┃"
echo "  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_wave() {
    local banner='
echo -e "\033[38;5;39m    ∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿"
echo -e "\033[38;5;45m   ≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋"
echo -e "\033[38;5;51m  ∿∿∿∿  KyyInfinite Ocean  ∿∿∿∿∿∿∿"
echo -e "\033[38;5;87m   ≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋≋"
echo -e "\033[38;5;123m    ∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿∿"
echo -e "\033[38;5;159m  🌊 Ride the digital waves...  🌊"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_robot() {
    local banner='
echo -e "\033[38;5;46m"
echo "        ╔══════════════════╗"
echo "        ║  ┌──────────┐   ║"
echo "        ║  │  ◉    ◉  │   ║"
echo "        ║  │    ▄▄    │   ║"
echo "        ║  │  ╚════╝  │   ║"
echo "        ║  └──────────┘   ║"
echo "        ║    ┌──────┐     ║"
echo "        ║    │KYYBOT│     ║"
echo "        ║    └──────┘     ║"
echo "        ╚══════════════════╝"
echo -e "\033[38;5;39m"
echo "  🤖 KyyInfinite AI Terminal Ready"
echo "  📡 Connection: SECURED"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
}

install_banner_kyy() {
    local banner='
echo -e "\033[1;38;5;196m  ░█░█░█░█░█░█░▀░█▀█░█▀▀░▀░█▀█░▀░▀█▀░█▀▀"
echo -e "\033[1;38;5;208m  ░█▀▄░░█░░░█░░█░█░█░█▀▀░█░█░█░█░░█░░█▀▀"
echo -e "\033[1;38;5;226m  ░▀░▀░░▀░░░▀░░▀░▀░▀░▀░░░▀░▀░▀░▀░░▀░░▀▀▀"
echo -e "\033[38;5;245m  ─────────────────────────────────────────"
echo -e "\033[38;5;39m  ┃ Author  : KyyInfinite"
echo -e "\033[38;5;46m  ┃ Version : v3.0 PHANTOM"
echo -e "\033[38;5;213m  ┃ Date    : $(date "+%d %B %Y")"
echo -e "\033[38;5;208m  ┃ Time    : $(date +%H:%M:%S)"
echo -e "\033[38;5;87m  ┃ User    : $(whoami)"
echo -e "\033[38;5;245m  ─────────────────────────────────────────"
echo -e "\033[38;5;46m  ★ Type \x27kyy\x27 to launch the framework"
echo -e "\033[0m"'
    write_banner_to_bashrc "$banner"
    
    # Also create alias
    local bashrc="$HOME/.bashrc"
    if ! grep -q "alias kyy=" "$bashrc" 2>/dev/null; then
        echo "alias kyy='bash ${SCRIPT_DIR}/kyy-core.sh'" >> "$bashrc"
    fi
}

install_banner_custom() {
    echo -ne "    ${T_WARNING}Enter text for banner: ${T_SUCCESS}"
    read banner_text
    echo -e "${RST}"
    
    if [ -z "$banner_text" ]; then
        echo -e "    ${T_ERROR}[✗] Text cannot be empty!${RST}"
        sleep 1; termux_banner_menu; return
    fi
    
    local font="standard"
    echo -e "    ${T_INFO}Available fonts: standard, slant, banner, big, block${RST}"
    echo -ne "    ${T_WARNING}Font (default: standard): ${T_SUCCESS}"
    read font_choice
    echo -e "${RST}"
    font=${font_choice:-standard}
    
    local banner="figlet -f $font '$banner_text' 2>/dev/null || echo '$banner_text'
echo -e '\033[38;5;39m  ★ KyyInfinite Framework v${VERSION}\033[0m'
echo ''"
    
    write_banner_to_bashrc "$banner"
}

# ══════════════════════════════════════════════════════════════
#  SECTION 8: DEPENDENCY CHECKER & INSTALLER
# ══════════════════════════════════════════════════════════════

check_and_install_deps() {
    local essential_deps=("curl" "wget" "git" "python" "bc" "jq" "openssl" "nmap" "figlet" "toilet" "net-tools" "whois" "traceroute" "neofetch")
    local missing=()
    local installed=()
    
    echo ""
    echo -e "    ${T_INFO}${BLD}Checking dependencies...${RST}"
    echo ""
    
    for dep in "${essential_deps[@]}"; do
        echo -ne "    ${T_MUTED}Checking ${WH}${dep}${T_MUTED}..."
        if command -v "$dep" &>/dev/null; then
            echo -e "\r    ${T_SUCCESS}✓${RST} ${WH}${dep}${RST}$(printf '%*s' $((20 - ${#dep})) '')${T_MUTED}installed${RST}"
            installed+=("$dep")
        else
            echo -e "\r    ${T_ERROR}✗${RST} ${WH}${dep}${RST}$(printf '%*s' $((20 - ${#dep})) '')${T_WARNING}missing${RST}"
            missing+=("$dep")
        fi
        sleep 0.1
    done
    
    echo ""
    echo -e "    ${T_SUCCESS}Installed: ${WH}${#installed[@]}${RST}  ${T_ERROR}Missing: ${WH}${#missing[@]}${RST}"
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo ""
        echo -ne "    ${T_WARNING}Install missing packages? [y/n]: ${T_SUCCESS}"
        read confirm
        echo -e "${RST}"
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo ""
            apt update -y &>/dev/null
            for pkg in "${missing[@]}"; do
                spin "Installing ${pkg}..." 2 3
                pkg install -y "$pkg" &>/dev/null 2>&1 || pip install "$pkg" &>/dev/null 2>&1
            done
            echo ""
            echo -e "    $(badge_ok) All dependencies installed!"
        fi
    else
        echo -e "    $(badge_ok) All dependencies satisfied!"
    fi
    
    sleep 1
}

# ══════════════════════════════════════════════════════════════
#  SECTION 9: SYSTEM STATUS DASHBOARD
# ══════════════════════════════════════════════════════════════

dashboard_header() {
    local user=$(whoami 2>/dev/null || echo "user")
    local host=$(hostname 2>/dev/null || echo "termux")
    local time_now=$(date '+%H:%M:%S')
    local date_now=$(date '+%a %d %b %Y')
    local pub_ip=$(cat "$CACHE_DIR/pub_ip" 2>/dev/null || echo "fetching...")
    
    # Fetch IP in background
    (curl -s --max-time 3 ifconfig.me > "$CACHE_DIR/pub_ip" 2>/dev/null) &
    
    local uptime_info=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
    local mem_info=$(free -h 2>/dev/null | awk '/Mem:/{printf "%s/%s", $3, $2}' || echo "N/A")
    local disk_info=$(df -h / 2>/dev/null | awk 'NR==2{printf "%s/%s (%s)", $3, $2, $5}' || echo "N/A")
    local pkg_count=$(dpkg -l 2>/dev/null | grep -c '^ii' || echo "N/A")
    local kernel=$(uname -r 2>/dev/null | cut -d- -f1 || echo "N/A")
    
    echo ""
    echo -e "    ${T_BORDER}╔══════════════════════════════════════════════════╗${RST}"
    echo -e "    ${T_BORDER}║${RST} ${T_PRIMARY}${BLD}⚡ DASHBOARD${RST}            ${T_MUTED}${date_now} ${time_now}${RST} ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}╠══════════════════════════════════════════════════╣${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}👤 User    :${RST} ${T_SUCCESS}${user}${T_MUTED}@${T_INFO}${host}${RST}$(printf '%*s' $((30 - ${#user} - ${#host})) '')    ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}🌐 IP      :${RST} ${T_PRIMARY}${pub_ip}${RST}$(printf '%*s' $((33 - ${#pub_ip})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}⏱️  Uptime  :${RST} ${T_INFO}${uptime_info}${RST}$(printf '%*s' $((32 - ${#uptime_info})) ''  )   ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}💾 Memory  :${RST} ${T_WARNING}${mem_info}${RST}$(printf '%*s' $((33 - ${#mem_info})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}💽 Disk    :${RST} ${T_ACCENT}${disk_info}${RST}$(printf '%*s' $((33 - ${#disk_info})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}📦 Packages:${RST} ${T_SUCCESS}${pkg_count}${RST}$(printf '%*s' $((33 - ${#pkg_count})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}🎨 Theme   :${RST} ${T_HIGHLIGHT}${CURRENT_THEME^}${RST}$(printf '%*s' $((33 - ${#CURRENT_THEME})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_MUTED}📊 Session :${RST} ${T_INFO}#${TOTAL_LAUNCHES}${RST}$(printf '%*s' $((32 - ${#TOTAL_LAUNCHES})) '')  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}╚══════════════════════════════════════════════════╝${RST}"
}

# ══════════════════════════════════════════════════════════════
#  SECTION 10: MAIN MENU — THE ULTIMATE DASHBOARD
# ══════════════════════════════════════════════════════════════

main_menu() {
    clear
    refresh_term_size
    
    show_banner
    dashboard_header
    
    echo ""
    local W=52
    echo -e "    ${T_BORDER}╔══════════════════════════════════════════════════╗${RST}"
    echo -e "    ${T_BORDER}║${RST} ${T_PRIMARY}${BLD}⚡ MAIN ARSENAL — SELECT YOUR WEAPON${RST}             ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}╠══════════════════════════════════════════════════╣${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}01${RST}${T_SUCCESS}]${RST} 🌐 ${T_INFO}Network Scanner & WiFi Tools${RST}            ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}02${RST}${T_SUCCESS}]${RST} 🔍 ${T_INFO}Information Gathering (OSINT)${RST}           ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}03${RST}${T_SUCCESS}]${RST} 🛡️  ${T_INFO}Security & Exploit Tools${RST}                ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}04${RST}${T_SUCCESS}]${RST} 📡 ${T_INFO}WiFi Password Extractor${RST} $(badge_new)       ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}05${RST}${T_SUCCESS}]${RST} 📱 ${T_INFO}Device & System Dashboard${RST}               ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}06${RST}${T_SUCCESS}]${RST} 📦 ${T_INFO}Package & Plugin Manager${RST}                ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}07${RST}${T_SUCCESS}]${RST} 📝 ${T_INFO}Text / Encode / Crypto Tools${RST}            ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}08${RST}${T_SUCCESS}]${RST} 📁 ${T_INFO}File Manager & Downloader${RST}               ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}09${RST}${T_SUCCESS}]${RST} 🧹 ${T_INFO}Cleaner & Optimizer${RST}                     ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}10${RST}${T_SUCCESS}]${RST} 🎨 ${T_INFO}Fun & Visual Effects Lab${RST}                ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}11${RST}${T_SUCCESS}]${RST} 🐍 ${T_INFO}Python Advanced Tools${RST} $(badge_new)         ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_SUCCESS}[${WH}${BLD}12${RST}${T_SUCCESS}]${RST} ☠️  ${T_INFO}Hacker Module (Pentesting)${RST} $(badge_new)    ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}╟──────────────────────────────────────────────────╢${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}T${RST}${T_ACCENT}]${RST}  🎨 ${T_HIGHLIGHT}Theme Manager${RST}                           ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}P${RST}${T_ACCENT}]${RST}  ⚡ ${T_HIGHLIGHT}Prompt Customizer${RST}                       ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}B${RST}${T_ACCENT}]${RST}  🖼️  ${T_HIGHLIGHT}Termux Banner Manager${RST}                   ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}D${RST}${T_ACCENT}]${RST}  📋 ${T_HIGHLIGHT}Dependencies Checker${RST}                    ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}S${RST}${T_ACCENT}]${RST}  ⚙️  ${T_HIGHLIGHT}Settings${RST}                                ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ACCENT}[${WH}${BLD}A${RST}${T_ACCENT}]${RST}  ℹ️  ${T_HIGHLIGHT}About KyyInfinite${RST}                       ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}  ${T_ERROR}[${WH}${BLD}00${RST}${T_ERROR}]${RST} ❌ ${T_ERROR}Exit Framework${RST}                          ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}║${RST}                                                  ${T_BORDER}║${RST}"
    echo -e "    ${T_BORDER}╚══════════════════════════════════════════════════╝${RST}"
    echo ""
    echo -ne "    ${T_PRIMARY}╭─[${T_SUCCESS}${AUTHOR}${T_PRIMARY}]─[${T_ACCENT}${CURRENT_THEME^}${T_PRIMARY}]${RST}"
    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${RST}${BLD}Select${RST} ${T_MUTED}[${T_SUCCESS}01-12${T_MUTED}/${T_ACCENT}T/P/B/D/S/A${T_MUTED}/${T_ERROR}00${T_MUTED}]${T_WARNING}: ${T_SUCCESS}"
    read main_choice
    echo -e "${RST}"
    
    case $main_choice in
        01|1)  source_and_run "network_menu" ;;
        02|2)  source_and_run "info_gathering_menu" ;;
        03|3)  source_and_run "security_menu" ;;
        04|4)  source_and_run "wifi_menu" ;;
        05|5)  source_and_run "device_info" ;;
        06|6)  source_and_run "package_plugin_menu" ;;
        07|7)  source_and_run "text_tools_menu" ;;
        08|8)  source_and_run "file_manager_menu" ;;
        09|9)  source_and_run "cleaner_menu" ;;
        10)    source_and_run "fun_menu" ;;
        11)    source_and_run "python_tools_menu" ;;
        12)    source_and_run "hacker_menu" ;;
        [Tt])  theme_menu ;;
        [Pp])  prompt_menu ;;
        [Bb])  termux_banner_menu ;;
        [Dd])  check_and_install_deps; echo -ne "\n    ${T_WARNING}Press [ENTER]...${RST}"; read; main_menu ;;
        [Ss])  settings_menu ;;
        [Aa])  about_screen ;;
        00|0)  exit_animation ;;
        *)
            echo -e "    ${T_ERROR}[✗] Invalid choice!${RST}"
            sleep 1
            main_menu
            ;;
    esac
}

# ─── SOURCE AND RUN MODULE ──────────────────────────
source_and_run() {
    local func_name="$1"
    local modules_file="${SCRIPT_DIR}/kyy-modules.sh"
    local plugins_file="${SCRIPT_DIR}/kyy-plugins.sh"
    
    if [ -f "$modules_file" ]; then
        source "$modules_file"
    fi
    if [ -f "$plugins_file" ]; then
        source "$plugins_file"
    fi
    local pymodules_file="${SCRIPT_DIR}/kyy-pymodules.sh"
    if [ -f "$pymodules_file" ]; then
        source "$pymodules_file"
    fi
    local hackmod_file="${SCRIPT_DIR}/kyy-hackmod.sh"
    if [ -f "$hackmod_file" ]; then
        source "$hackmod_file"
    fi
    
    if declare -f "$func_name" &>/dev/null; then
        "$func_name"
    else
        clear
        echo ""
        echo -e "    ${T_BORDER}╔══════════════════════════════════════════════╗${RST}"
        echo -e "    ${T_BORDER}║${RST}                                              ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_WARNING}${BLD}⚠️  MODULE NOT FOUND${RST}                       ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}                                              ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_INFO}Function: ${WH}${func_name}${RST}                    ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}                                              ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_MUTED}Make sure these files exist:${RST}               ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_ERROR}• ${WH}kyy-modules.sh${RST}                         ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_ERROR}• ${WH}kyy-plugins.sh${RST}                         ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}                                              ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}   ${T_MUTED}Place them in: ${T_INFO}${SCRIPT_DIR}/${RST}  ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}║${RST}                                              ${T_BORDER}║${RST}"
        echo -e "    ${T_BORDER}╚══════════════════════════════════════════════╝${RST}"
        echo ""
        echo -ne "    ${T_WARNING}Press [ENTER] to go back...${RST}"
        read
        main_menu
    fi
}

# ─── GO BACK HELPER ─────────────────────────────────
go_back() {
    local target=${1:-main_menu}
    echo ""
    draw_line "─" 50 "${T_BORDER}"
    echo -ne "    ${T_WARNING}⮞ Press ${WH}[ENTER]${T_WARNING} to continue...${RST}"
    read
    "$target"
}

# ══════════════════════════════════════════════════════════════
#  SECTION 11: SETTINGS
# ══════════════════════════════════════════════════════════════

settings_menu() {
    clear
    echo ""
    center_text "${BLD}${T_PRIMARY}━━━━━ ⚙️ SETTINGS ━━━━━${RST}"
    echo ""
    
    local W=52
    draw_box $W "CONFIGURATION"
    draw_box_empty $W
    
    draw_box_line $W "${T_MUTED}Current Settings:${RST}"
    draw_box_line $W "  ${T_WARNING}Theme     : ${T_SUCCESS}${CURRENT_THEME^}${RST}"
    draw_box_line $W "  ${T_WARNING}Prompt    : ${T_SUCCESS}${CUSTOM_PROMPT:-Default}${RST}"
    draw_box_line $W "  ${T_WARNING}Banner    : ${T_SUCCESS}${SHOW_BANNER}${RST}"
    draw_box_line $W "  ${T_WARNING}Animation : ${T_SUCCESS}${ANIMATION_SPEED}${RST}"
    draw_box_line $W "  ${T_WARNING}Launches  : ${T_SUCCESS}#${TOTAL_LAUNCHES}${RST}"
    draw_box_line $W "  ${T_WARNING}Last Login: ${T_SUCCESS}${LAST_LOGIN:-N/A}${RST}"
    
    draw_box_empty $W
    draw_box_separator $W
    draw_box_empty $W
    
    menu_item "1" "🎨" "Change Theme" $W
    menu_item "2" "⚡" "Change Prompt" $W
    menu_item "3" "🖼️" "Change Banner" $W
    menu_item "4" "🔄" "Reset All Settings" $W
    menu_item "5" "📋" "View Log File" $W
    menu_item "6" "🗑️" "Clear Log File" $W
    menu_item "7" "💾" "Export Config" $W
    
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu" $W
    draw_box_empty $W
    draw_box_bottom $W
    
    echo ""
    echo -ne "    ${T_WARNING}⮞  Select: ${T_SUCCESS}"
    read choice
    echo -e "${RST}"
    
    case $choice in
        1) theme_menu ;;
        2) prompt_menu ;;
        3) termux_banner_menu ;;
        4)
            echo -ne "    ${T_ERROR}Reset ALL settings? [y/n]: ${T_SUCCESS}"
            read confirm
            echo -e "${RST}"
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                rm -rf "$CONFIG_DIR" 2>/dev/null
                init_dirs
                CURRENT_THEME="phantom"
                apply_theme "phantom"
                TOTAL_LAUNCHES=1
                save_config
                
                # Reset bashrc
                local bashrc="$HOME/.bashrc"
                sed -i '/# KyyInfinite/,/# End KyyInfinite/d' "$bashrc" 2>/dev/null
                
                echo -e "    $(badge_ok) All settings reset to default!"
            fi
            sleep 2
            settings_menu
            ;;
        5)
            clear
            echo ""
            echo -e "    ${T_PRIMARY}${BLD}📋 LOG FILE${RST}"
            draw_line "─" 50
            if [ -f "$LOG_FILE" ]; then
                tail -30 "$LOG_FILE" | while read line; do
                    echo -e "    ${T_MUTED}$line${RST}"
                done
            else
                echo -e "    ${T_WARNING}No log file found.${RST}"
            fi
            echo ""
            echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"
            read
            settings_menu
            ;;
        6)
            > "$LOG_FILE" 2>/dev/null
            echo -e "    $(badge_ok) Log file cleared!"
            sleep 1
            settings_menu
            ;;
        7)
            local export_file="$HOME/kyyinfinite_config_backup.conf"
            cp "$CONFIG_FILE" "$export_file" 2>/dev/null
            echo -e "    $(badge_ok) Config exported to: ${WH}$export_file${RST}"
            sleep 2
            settings_menu
            ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; settings_menu ;;
    esac
}

# ══════════════════════════════════════════════════════════════
#  SECTION 12: ABOUT SCREEN
# ══════════════════════════════════════════════════════════════

about_screen() {
    clear
    echo ""
    
    # Animated KyyInfinite logo
    gradient_text "    ██╗  ██╗██╗   ██╗██╗   ██╗" 255 0 100 0 200 255
    gradient_text "    ██║ ██╔╝╚██╗ ██╔╝╚██╗ ██╔╝" 255 50 80 50 180 255
    gradient_text "    █████╔╝  ╚████╔╝  ╚████╔╝ " 255 100 60 100 160 255
    gradient_text "    ██╔═██╗   ╚██╔╝    ╚██╔╝  " 200 150 40 150 140 255
    gradient_text "    ██║  ██╗   ██║      ██║    " 180 200 20 200 120 255
    gradient_text "    ╚═╝  ╚═╝   ╚═╝      ╚═╝    " 160 255 0 255 100 255
    
    echo ""
    center_text "${BLD}${T_PRIMARY}I N F I N I T E${RST}"
    center_text "${T_MUTED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RST}"
    echo ""
    
    local W=52
    draw_box $W "ABOUT THIS FRAMEWORK"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Name        ${T_MUTED}: ${T_SUCCESS}KyyInfinite Phantom Framework${RST}"
    draw_box_line $W "  ${T_WARNING}Version     ${T_MUTED}: ${T_SUCCESS}${VERSION} (${CODENAME})${RST}"
    draw_box_line $W "  ${T_WARNING}Author      ${T_MUTED}: ${T_PRIMARY}${AUTHOR}${RST}"
    draw_box_line $W "  ${T_WARNING}Build       ${T_MUTED}: ${T_SUCCESS}${BUILD_DATE}${RST}"
    draw_box_line $W "  ${T_WARNING}License     ${T_MUTED}: ${T_SUCCESS}MIT${RST}"
    draw_box_line $W "  ${T_WARNING}Platform    ${T_MUTED}: ${T_SUCCESS}Termux (Android)${RST}"
    draw_box_line $W "  ${T_WARNING}Language    ${T_MUTED}: ${T_SUCCESS}Bash${RST}"
    draw_box_empty $W
    draw_box_separator $W
    draw_box_empty $W
    draw_box_line $W "  ${T_ACCENT}${ITA}\"Code is poetry, hacking is art\"${RST}"
    draw_box_line $W "  ${T_MUTED}${ITA}                    — KyyInfinite${RST}"
    draw_box_empty $W
    draw_box_separator $W
    draw_box_empty $W
    draw_box_line $W "  ${T_INFO}Features:${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}12+ Theme Engine with Custom RGB${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}10+ Custom Prompt Styles${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}10+ Termux Banner/MOTD Art${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Network & WiFi Password Tools${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}OSINT & Information Gathering${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Security & Exploit Framework${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Plugin System (Extensible)${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Premium Visual Effects${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Full System Dashboard${RST}"
    draw_box_line $W "  ${T_MUTED}• ${WH}Persistent Configuration${RST}"
    draw_box_empty $W
    draw_box_bottom $W
    
    echo ""
    rainbow_text "    ★ Thank you for using KyyInfinite Framework! ★"
    echo ""
    echo -ne "    ${T_WARNING}Press [ENTER] to go back...${RST}"
    read
    main_menu
}

# ══════════════════════════════════════════════════════════════
#  SECTION 13: EXIT ANIMATION
# ══════════════════════════════════════════════════════════════

exit_animation() {
    clear
    echo ""
    echo ""
    echo ""
    
    # Shrinking box animation
    local messages=(
        "Saving configuration..."
        "Cleaning up temporary files..."
        "Closing connections..."
        "Goodbye!"
    )
    
    for msg in "${messages[@]}"; do
        spin "$msg" 1 $((RANDOM % 8 + 1))
    done
    
    echo ""
    echo ""
    
    gradient_text "    ╔═══════════════════════════════════════════╗" 100 100 255 255 100 100
    gradient_text "    ║                                           ║" 120 100 240 240 100 120
    gradient_text "    ║    Thank you for using KyyInfinite!       ║" 140 100 220 220 100 140
    gradient_text "    ║                                           ║" 160 100 200 200 100 160
    gradient_text "    ║          ★ Stay Infinite ★                ║" 180 100 180 180 100 180
    gradient_text "    ║          ★ Stay Creative ★                ║" 200 100 160 160 100 200
    gradient_text "    ║          ★ Stay Unstoppable ★             ║" 220 100 140 140 100 220
    gradient_text "    ║                                           ║" 240 100 120 120 100 240
    gradient_text "    ╚═══════════════════════════════════════════╝" 255 100 100 100 100 255
    
    echo ""
    
    local farewell="    See you in the digital realm, warrior... 👋"
    type_effect "$farewell" "${T_PRIMARY}" 0.03
    
    echo ""
    echo ""
    
    save_config
    log_msg "Framework closed gracefully"
    
    sleep 1
    clear
    exit 0
}

# ══════════════════════════════════════════════════════════════
#  SECTION 14: STARTUP SEQUENCE
# ══════════════════════════════════════════════════════════════

startup_sequence() {
    clear
    tput civis 2>/dev/null  # Hide cursor
    
    # Phase 1: Initialization dots
    echo ""
    echo ""
    echo ""
    echo ""
    
    center_text "${T_MUTED}Initializing KyyInfinite Framework...${RST}"
    echo ""
    
    local init_steps=(
        "Loading core engine"
        "Initializing color system"
        "Loading theme: ${CURRENT_THEME^}"
        "Scanning modules"
        "Checking plugins"
        "Building dashboard"
        "Establishing connections"
        "Framework ready"
    )
    
    for step in "${init_steps[@]}"; do
        spin "$step" 1 $((RANDOM % 8 + 1))
    done
    
    echo ""
    
    # Phase 2: Loading bar
    premium_bar "Loading KyyInfinite" 2
    
    echo ""
    
    # Phase 3: Glitch reveal
    glitch_effect "K Y Y I N F I N I T E   v${VERSION}"
    
    sleep 0.5
    
    # Phase 4: Quick matrix flash
    echo ""
    center_text "${T_MUTED}Entering the matrix...${RST}"
    sleep 0.3
    matrix_rain 2
    
    tput cnorm 2>/dev/null  # Show cursor
    sleep 0.3
}

# ══════════════════════════════════════════════════════════════
#  SECTION 15: CTRL+C HANDLER & ENTRY POINT
# ══════════════════════════════════════════════════════════════

# ─── TRAP CTRL+C ────────────────────────────────────
trap_handler() {
    echo ""
    echo -e "\n    ${T_WARNING}[!] Interrupted! Returning to main menu...${RST}"
    tput cnorm 2>/dev/null
    sleep 0.5
    main_menu
}

trap trap_handler INT

# ═══════════════════════════════════════════════
#  🚀 MAIN ENTRY POINT
# ═══════════════════════════════════════════════

main() {
    # Initialize directories
    init_dirs
    
    # Load config
    load_config
    
    # Apply saved theme
    apply_theme "${CURRENT_THEME:-phantom}"
    
    # Run startup sequence
    startup_sequence
    
    # Enter main menu
    main_menu
}

# ─── LAUNCH ──────────────────────────────────────────
main "$@"
