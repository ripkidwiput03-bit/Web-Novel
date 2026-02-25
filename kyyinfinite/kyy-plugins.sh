#!/data/data/com.termux/files/usr/bin/bash

# ╔════════════════════════════════════════════════════════════════════════╗
# ║                                                                        ║
# ║    ██╗  ██╗██╗   ██╗██╗   ██╗    ╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗                  ║
# ║    █████╔╝  ╚████╔╝  ╚████╔╝     ║║║║╠╣ ║║║║║ ║ ║╣                   ║
# ║    ██║  ██╗   ██║      ██║       ╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝                 ║
# ║                                                                        ║
# ║    FILE 3/3 — PLUGIN SYSTEM, PKG MANAGER, BONUS MODULES               ║
# ║    Created by: KyyInfinite                                             ║
# ║                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════╝

# ─── Guard: must be sourced from core ────────────────
if [ -z "$VERSION" ]; then
    echo "[!] This file must be sourced from kyy-core.sh"
    echo "    Run: bash kyy-core.sh"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
#  MODULE 06: PACKAGE & PLUGIN MANAGER
# ═══════════════════════════════════════════════════════════════

package_plugin_menu() {
    sub_banner "📦 PACKAGE & PLUGIN MANAGER"

    local W=52
    draw_box $W "PKG & PLUGIN CENTER"
    draw_box_empty $W

    draw_box_line $W "  ${T_ACCENT}${BLD}── PACKAGE MANAGER ──${RST}"
    menu_item "01" "🔄" "Update & Upgrade All"         $W
    menu_item "02" "📥" "Install Package"               $W
    menu_item "03" "🗑️" " Uninstall Package"            $W
    menu_item "04" "🔍" "Search Package"                $W
    menu_item "05" "📋" "List Installed Packages"       $W
    menu_item "06" "⚡" "Install Power Bundle"          $W

    draw_box_empty $W
    draw_box_line $W "  ${T_ACCENT}${BLD}── PLUGIN SYSTEM ──${RST}"
    menu_item "07" "🧩" "Plugin Store (Install)"        $W
    menu_item "08" "📦" "View Installed Plugins"        $W
    menu_item "09" "🗑️" " Remove Plugin"                $W
    menu_item "10" "🔧" "Create Custom Plugin"          $W
    menu_item "11" "🌐" "Install from GitHub URL"       $W

    draw_box_empty $W
    draw_box_line $W "  ${T_ACCENT}${BLD}── AUTO INSTALLERS ──${RST}"
    menu_item "12" "🐍" "Python Dev Environment"        $W
    menu_item "13" "📗" "NodeJS Dev Environment"        $W
    menu_item "14" "💎" "Ruby Dev Environment"          $W
    menu_item "15" "🐘" "PHP Dev Environment"           $W
    menu_item "16" "☕" "Java Dev Environment"          $W
    menu_item "17" "🦀" "Rust Dev Environment"          $W
    menu_item "18" "🐹" "Go Dev Environment"            $W

    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"          $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1)  pkg_update_upgrade ;;
        02|2)  pkg_install ;;
        03|3)  pkg_uninstall ;;
        04|4)  pkg_search ;;
        05|5)  pkg_list ;;
        06|6)  pkg_power_bundle ;;
        07|7)  plugin_store ;;
        08|8)  plugin_list_installed ;;
        09|9)  plugin_remove ;;
        10)    plugin_create ;;
        11)    plugin_from_github ;;
        12)    env_python ;;
        13)    env_nodejs ;;
        14)    env_ruby ;;
        15)    env_php ;;
        16)    env_java ;;
        17)    env_rust ;;
        18)    env_go ;;
        00|0)  main_menu ;;
        *)     echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; package_plugin_menu ;;
    esac
}

# ─── PACKAGE FUNCTIONS ──────────────────────────────

pkg_update_upgrade() {
    sub_banner "🔄 UPDATE & UPGRADE"
    premium_bar "Updating package lists" 3
    apt update -y 2>&1 | tail -5 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
    echo ""
    premium_bar "Upgrading packages" 4
    apt upgrade -y 2>&1 | tail -5 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
    echo ""
    echo -e "    $(badge_ok) ${T_SUCCESS}${BLD}Update & Upgrade complete!${RST}"
    go_back package_plugin_menu
}

pkg_install() {
    sub_banner "📥 INSTALL PACKAGE"
    echo -ne "    ${T_WARNING}Package name(s) (space-separated): ${T_SUCCESS}"
    read pkg_names
    echo -e "${RST}"
    [ -z "$pkg_names" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; package_plugin_menu; return; }

    for pkg in $pkg_names; do
        spin "Installing ${pkg}..." 2 3
        apt install -y "$pkg" &>/dev/null && {
            echo -e "    $(badge_ok) ${WH}${pkg}${RST} installed"
        } || {
            echo -e "    $(badge_fail) ${WH}${pkg}${RST} failed"
        }
    done
    go_back package_plugin_menu
}

pkg_uninstall() {
    sub_banner "🗑️ UNINSTALL PACKAGE"
    echo -ne "    ${T_WARNING}Package name: ${T_SUCCESS}"
    read pkg_name
    echo -e "${RST}"
    [ -z "$pkg_name" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; package_plugin_menu; return; }

    echo -ne "    ${T_ERROR}Remove ${WH}${pkg_name}${T_ERROR}? [y/n]: ${T_SUCCESS}"
    read confirm
    echo -e "${RST}"
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        spin "Uninstalling ${pkg_name}..." 2 8
        apt remove -y "$pkg_name" &>/dev/null && echo -e "    $(badge_ok) Removed!" || echo -e "    $(badge_fail) Failed!"
    fi
    go_back package_plugin_menu
}

pkg_search() {
    sub_banner "🔍 SEARCH PACKAGE"
    echo -ne "    ${T_WARNING}Search keyword: ${T_SUCCESS}"
    read keyword
    echo -e "${RST}"
    [ -z "$keyword" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; package_plugin_menu; return; }

    spin "Searching..." 2 4
    echo ""

    local W=52
    draw_box $W "SEARCH RESULTS — $keyword"
    draw_box_empty $W

    apt search "$keyword" 2>/dev/null | head -30 | while IFS= read -r line; do
        if echo "$line" | grep -q "^[a-z]"; then
            local pkg=$(echo "$line" | cut -d/ -f1)
            local desc=$(echo "$line" | cut -d' ' -f2-)
            draw_box_line $W "  ${T_SUCCESS}● ${WH}${pkg}${RST}"
            draw_box_line $W "    ${T_MUTED}${desc:0:40}${RST}"
        fi
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back package_plugin_menu
}

pkg_list() {
    sub_banner "📋 INSTALLED PACKAGES"
    spin "Loading package list..." 1 2

    local total=$(dpkg -l 2>/dev/null | grep -c '^ii' || apt list --installed 2>/dev/null | wc -l)
    echo -e "    ${T_INFO}Total installed: ${WH}${total}${RST}"
    echo ""

    draw_line "━" 50 "${T_BORDER}"
    apt list --installed 2>/dev/null | tail -40 | while IFS= read -r line; do
        local pkg=$(echo "$line" | cut -d/ -f1)
        local ver=$(echo "$line" | awk '{print $2}')
        if [ -n "$pkg" ] && [ "$pkg" != "Listing..." ]; then
            echo -e "    ${T_SUCCESS}● ${WH}${pkg} ${T_MUTED}${ver}${RST}"
        fi
    done
    draw_line "━" 50 "${T_BORDER}"
    echo -e "    ${T_MUTED}(Showing last 40 packages)${RST}"

    go_back package_plugin_menu
}

pkg_power_bundle() {
    sub_banner "⚡ POWER BUNDLE INSTALLER"

    echo -e "    ${T_INFO}Select a bundle to install:${RST}"
    echo ""

    local W=52
    draw_box $W "POWER BUNDLES"
    draw_box_empty $W
    menu_item "1" "🔧" "Essential Tools"              $W
    menu_item "2" "🐍" "Python Full Stack"             $W
    menu_item "3" "🌐" "Web Development"               $W
    menu_item "4" "🔐" "Hacking & Security"            $W
    menu_item "5" "📱" "Termux Enhancement"            $W
    menu_item "6" "📊" "Data Science"                  $W
    menu_item "7" "🎮" "Fun & Games"                   $W
    menu_item "8" "💻" "Full Developer Kit"            $W
    menu_item "9" "🚀" "ALL BUNDLES (Everything)"      $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}Select bundle: ${T_SUCCESS}"
    read bundle
    echo -e "${RST}"

    local packages=()
    case $bundle in
        1) packages=("curl" "wget" "git" "nano" "vim" "htop" "tree" "zip" "unzip" "tar"
                      "bc" "jq" "openssl" "openssh" "net-tools" "man" "less" "grep" "sed"
                      "awk" "file" "findutils" "coreutils" "diffutils") ;;
        2) packages=("python" "python-pip" "python-numpy" "python-scipy" "clang"
                      "libffi" "libxml2" "libxslt" "libjpeg-turbo" "libpng"
                      "python-cryptography" "python-pillow") ;;
        3) packages=("nodejs" "php" "ruby" "python" "nginx" "apache2" "mariadb"
                      "sqlite" "redis" "git" "curl" "wget" "openssh") ;;
        4) packages=("nmap" "hydra" "sqlmap" "metasploit" "aircrack-ng" "john"
                      "hashcat" "wireshark-cli" "tcpdump" "whois" "traceroute"
                      "net-tools" "dnsutils" "tor" "proxychains-ng" "openssl") ;;
        5) packages=("termux-api" "termux-tools" "termux-services" "figlet" "toilet"
                      "neofetch" "cowsay" "fortune" "lolcat" "tmux" "screen" "zsh"
                      "fish" "starship" "exa" "bat" "fd" "ripgrep" "fzf") ;;
        6) packages=("python" "python-pip" "python-numpy" "python-scipy" "python-pandas"
                      "python-matplotlib" "r-base" "sqlite" "postgresql" "jq") ;;
        7) packages=("figlet" "toilet" "cowsay" "fortune" "sl" "cmatrix" "nyancat"
                      "lolcat" "espeak" "mpv" "ffmpeg" "imagemagick") ;;
        8) packages=("python" "nodejs" "ruby" "php" "clang" "golang" "rust"
                      "git" "cmake" "make" "gdb" "valgrind" "strace" "ltrace"
                      "sqlite" "mariadb" "redis" "nginx" "tmux" "neovim") ;;
        9) packages=("curl" "wget" "git" "nano" "vim" "htop" "tree" "zip" "unzip"
                      "python" "python-pip" "nodejs" "ruby" "php" "clang" "golang" "rust"
                      "nmap" "whois" "traceroute" "net-tools" "openssl" "openssh"
                      "figlet" "toilet" "neofetch" "cowsay" "fortune" "lolcat"
                      "tmux" "zsh" "fzf" "jq" "bc" "sqlite" "imagemagick" "ffmpeg"
                      "termux-api" "nginx" "mariadb" "redis") ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; package_plugin_menu; return ;;
    esac

    echo ""
    echo -e "    ${T_INFO}Packages to install: ${WH}${#packages[@]}${RST}"
    echo -e "    ${T_MUTED}$(echo "${packages[@]}" | fold -s -w 50)${RST}"
    echo ""
    echo -ne "    ${T_WARNING}Continue? [y/n]: ${T_SUCCESS}"
    read confirm
    echo -e "${RST}"

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        premium_bar "Updating package lists" 2
        apt update -y &>/dev/null

        local installed=0
        local failed=0
        local total=${#packages[@]}

        for pkg in "${packages[@]}"; do
            ((installed++))
            local percent=$((installed * 100 / total))
            echo -ne "\r    ${T_MUTED}[${percent}%] ${T_INFO}Installing: ${WH}${pkg}$(printf '%*s' $((25 - ${#pkg})) '')${RST}"
            if apt install -y "$pkg" &>/dev/null 2>&1; then
                echo -ne "\r    ${T_SUCCESS}✓ ${WH}${pkg}$(printf '%*s' $((30 - ${#pkg})) '')${RST}\n"
            else
                # Try pip for python packages
                pip install "$pkg" &>/dev/null 2>&1 && {
                    echo -ne "\r    ${T_SUCCESS}✓ ${WH}${pkg} (pip)$(printf '%*s' $((24 - ${#pkg})) '')${RST}\n"
                } || {
                    echo -ne "\r    ${T_ERROR}✗ ${T_MUTED}${pkg} (skipped)$(printf '%*s' $((20 - ${#pkg})) '')${RST}\n"
                    ((failed++))
                }
            fi
        done

        echo ""
        echo -e "    $(badge_ok) ${T_SUCCESS}Bundle installation complete!${RST}"
        echo -e "    ${T_INFO}Installed: ${WH}$((total - failed))${RST}  ${T_ERROR}Failed: ${WH}${failed}${RST}"
    fi

    go_back package_plugin_menu
}


# ═══════════════════════════════════════════════════════════════
#  PLUGIN SYSTEM ENGINE
# ═══════════════════════════════════════════════════════════════

# ─── Plugin Registry (Built-in plugins) ─────────────
declare -A PLUGIN_REGISTRY
PLUGIN_REGISTRY=(
    ["weather"]="Weather Forecast Tool|Get weather for any city|weather_plugin"
    ["calculator"]="Advanced Calculator|Scientific calculator with history|calculator_plugin"
    ["notes"]="Quick Notes Manager|Create, view, edit and delete notes|notes_plugin"
    ["bookmark"]="URL Bookmark Manager|Save and organize URLs|bookmark_plugin"
    ["timer"]="Timer & Stopwatch|Countdown timer and stopwatch|timer_plugin"
    ["sysmonitor"]="System Monitor Dashboard|Real-time system monitoring|sysmonitor_plugin"
    ["gittools"]="Git Toolkit|Git helper commands and shortcuts|git_plugin"
    ["servertools"]="Server Tools|Quick HTTP server, port forwarding|server_plugin"
    ["socialosint"]="Social Media OSINT|Advanced social media gathering|social_plugin"
    ["converter"]="Unit Converter|Convert units, currency, temperature|converter_plugin"
    ["todo"]="Todo List Manager|Manage your tasks with priorities|todo_plugin"
    ["qrcode"]="QR Code Generator|Generate QR codes from text/URLs|qrcode_plugin"
    ["ipmonitor"]="IP Change Monitor|Monitor for IP address changes|ipmonitor_plugin"
    ["colorpicker"]="Color Picker & Mixer|Pick and mix colors with previews|colorpicker_plugin"
    ["passmanager"]="Password Vault|Encrypted local password manager|passmanager_plugin"
)

plugin_store() {
    sub_banner "🧩 PLUGIN STORE"

    local W=52
    draw_box $W "AVAILABLE PLUGINS"
    draw_box_empty $W

    local i=1
    local plugin_keys=()
    for key in $(echo "${!PLUGIN_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        plugin_keys+=("$key")
        IFS='|' read -r name desc func <<< "${PLUGIN_REGISTRY[$key]}"

        local installed_mark=""
        [ -f "$PLUGIN_DIR/${key}.installed" ] && installed_mark=" ${T_SUCCESS}✓${RST}"

        local num=$(printf "%02d" $i)
        draw_box_line $W "  ${T_SUCCESS}[${WH}${BLD}${num}${RST}${T_SUCCESS}]${RST} ${T_INFO}${name}${RST}${installed_mark}"
        draw_box_line $W "       ${T_MUTED}${desc}${RST}"
        ((i++))
    done

    draw_box_empty $W
    draw_box_separator $W
    menu_item "99" "📦" "Install ALL Plugins" $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back" $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ Install plugin #: ${T_SUCCESS}"
    read pchoice
    echo -e "${RST}"

    if [ "$pchoice" = "99" ]; then
        for key in "${plugin_keys[@]}"; do
            touch "$PLUGIN_DIR/${key}.installed" 2>/dev/null
            spin "Installing plugin: ${key}..." 1 $((RANDOM % 8 + 1))
            echo -e "\r    ${T_SUCCESS}✓ ${WH}${key}${RST} installed                    "
        done
        echo ""
        echo -e "    $(badge_ok) All plugins installed!"
        sleep 1
    elif [ "$pchoice" = "00" ] || [ "$pchoice" = "0" ]; then
        package_plugin_menu
        return
    elif [[ "$pchoice" =~ ^[0-9]+$ ]] && [ "$pchoice" -ge 1 ] && [ "$pchoice" -le ${#plugin_keys[@]} ]; then
        local key="${plugin_keys[$((pchoice - 1))]}"
        touch "$PLUGIN_DIR/${key}.installed" 2>/dev/null
        spin "Installing plugin: ${key}..." 2 3
        IFS='|' read -r name desc func <<< "${PLUGIN_REGISTRY[$key]}"
        echo -e "    $(badge_ok) Plugin ${WH}${name}${RST} installed!"
        sleep 1
    fi

    plugin_store
}

plugin_list_installed() {
    sub_banner "📦 INSTALLED PLUGINS"

    local W=52
    draw_box $W "MY PLUGINS"
    draw_box_empty $W

    local installed_count=0
    local i=1

    for key in $(echo "${!PLUGIN_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        if [ -f "$PLUGIN_DIR/${key}.installed" ]; then
            IFS='|' read -r name desc func <<< "${PLUGIN_REGISTRY[$key]}"
            local num=$(printf "%02d" $i)
            menu_item "$num" "🧩" "$name" $W
            ((installed_count++))
            ((i++))
        fi
    done

    if [ $installed_count -eq 0 ]; then
        draw_box_line $W "  ${T_MUTED}No plugins installed yet.${RST}"
        draw_box_line $W "  ${T_INFO}Visit Plugin Store to install!${RST}"
    fi

    draw_box_separator $W
    draw_box_line $W "  ${T_INFO}Total: ${WH}${installed_count} plugins${RST}"
    draw_box_empty $W
    menu_item_red "00" "←" "Back" $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ Run plugin # (or 00 to go back): ${T_SUCCESS}"
    read rp
    echo -e "${RST}"

    if [ "$rp" = "00" ] || [ "$rp" = "0" ]; then
        package_plugin_menu
        return
    fi

    # Find and run the plugin
    local j=1
    for key in $(echo "${!PLUGIN_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        if [ -f "$PLUGIN_DIR/${key}.installed" ]; then
            if [ "$j" = "$rp" ]; then
                IFS='|' read -r name desc func <<< "${PLUGIN_REGISTRY[$key]}"
                if declare -f "$func" &>/dev/null; then
                    "$func"
                else
                    echo -e "    ${T_WARNING}[!] Running plugin: ${WH}${name}${RST}"
                    sleep 1
                    # Try to call the function
                    "${func}" 2>/dev/null || echo -e "    ${T_ERROR}Plugin function not found${RST}"
                fi
                go_back plugin_list_installed
                return
            fi
            ((j++))
        fi
    done

    echo -e "    ${T_ERROR}[✗] Invalid!${RST}"
    sleep 1
    plugin_list_installed
}

plugin_remove() {
    sub_banner "🗑️ REMOVE PLUGIN"

    local installed_keys=()
    local i=1

    echo -e "    ${T_INFO}Installed plugins:${RST}"
    echo ""

    for key in $(echo "${!PLUGIN_REGISTRY[@]}" | tr ' ' '\n' | sort); do
        if [ -f "$PLUGIN_DIR/${key}.installed" ]; then
            IFS='|' read -r name desc func <<< "${PLUGIN_REGISTRY[$key]}"
            echo -e "    ${T_SUCCESS}[${WH}${i}${T_SUCCESS}]${RST} ${T_INFO}${name}${RST} ${T_MUTED}(${key})${RST}"
            installed_keys+=("$key")
            ((i++))
        fi
    done

    if [ ${#installed_keys[@]} -eq 0 ]; then
        echo -e "    ${T_MUTED}No plugins installed.${RST}"
        go_back package_plugin_menu
        return
    fi

    echo ""
    echo -ne "    ${T_WARNING}Remove plugin #: ${T_SUCCESS}"
    read rnum
    echo -e "${RST}"

    if [[ "$rnum" =~ ^[0-9]+$ ]] && [ "$rnum" -ge 1 ] && [ "$rnum" -le ${#installed_keys[@]} ]; then
        local key="${installed_keys[$((rnum - 1))]}"
        rm -f "$PLUGIN_DIR/${key}.installed" 2>/dev/null
        echo -e "    $(badge_ok) Plugin ${WH}${key}${RST} removed!"
    fi

    sleep 1
    package_plugin_menu
}

plugin_create() {
    sub_banner "🔧 CREATE CUSTOM PLUGIN"

    echo -ne "    ${T_WARNING}Plugin name (no spaces): ${T_SUCCESS}"
    read pname
    echo -ne "    ${T_WARNING}Description: ${T_SUCCESS}"
    read pdesc
    echo -ne "    ${T_WARNING}Author: ${T_SUCCESS}"
    read pauthor
    echo -e "${RST}"

    [ -z "$pname" ] && { echo -e "    ${T_ERROR}[✗] Name required!${RST}"; sleep 1; package_plugin_menu; return; }

    local plugin_file="$PLUGIN_DIR/${pname}.sh"

    cat > "$plugin_file" << PLUGIN_TEMPLATE
#!/bin/bash
# ═══════════════════════════════════════════════
# Plugin: ${pname}
# Description: ${pdesc:-Custom Plugin}
# Author: ${pauthor:-KyyInfinite User}
# Created: $(date '+%Y-%m-%d %H:%M:%S')
# Framework: KyyInfinite v${VERSION}
# ═══════════════════════════════════════════════

${pname}_plugin() {
    sub_banner "🧩 ${pname^^} PLUGIN"
    
    echo -e "    \${T_INFO}Plugin: ${pname}\${RST}"
    echo -e "    \${T_MUTED}${pdesc}\${RST}"
    echo -e "    \${T_MUTED}Author: ${pauthor:-Unknown}\${RST}"
    echo ""
    
    # ─── YOUR CODE HERE ─────────────────────
    echo -e "    \${T_WARNING}Hello from ${pname} plugin!\${RST}"
    echo -e "    \${T_MUTED}Edit: ${plugin_file}\${RST}"
    # ────────────────────────────────────────

    go_back plugin_list_installed
}
PLUGIN_TEMPLATE

    chmod +x "$plugin_file" 2>/dev/null
    touch "$PLUGIN_DIR/${pname}.installed" 2>/dev/null

    # Register plugin
    PLUGIN_REGISTRY["$pname"]="${pname^} Plugin|${pdesc:-Custom Plugin}|${pname}_plugin"

    echo -e "    $(badge_ok) Plugin ${WH}${pname}${RST} created!"
    echo -e "    ${T_MUTED}File: ${T_INFO}${plugin_file}${RST}"
    echo -e "    ${T_MUTED}Edit the file to add your custom logic.${RST}"

    go_back package_plugin_menu
}

plugin_from_github() {
    sub_banner "🌐 INSTALL FROM GITHUB"

    echo -ne "    ${T_WARNING}GitHub URL (e.g. https://github.com/user/repo): ${T_SUCCESS}"
    read github_url
    echo -e "${RST}"

    [ -z "$github_url" ] && { echo -e "    ${T_ERROR}[✗] URL empty!${RST}"; sleep 1; package_plugin_menu; return; }

    local repo_name=$(basename "$github_url" .git)

    spin "Cloning repository..." 3 4

    local clone_dir="$PLUGIN_DIR/$repo_name"
    rm -rf "$clone_dir" 2>/dev/null
    git clone "$github_url" "$clone_dir" 2>&1 | tail -3 | while IFS= read -r l; do
        echo -e "    ${T_INFO}$l${RST}"
    done

    if [ -d "$clone_dir" ]; then
        touch "$PLUGIN_DIR/${repo_name}.installed" 2>/dev/null
        PLUGIN_REGISTRY["$repo_name"]="${repo_name} (GitHub)|Installed from GitHub|echo 'Run manually'"

        echo ""
        echo -e "    $(badge_ok) Repository cloned successfully!"
        echo -e "    ${T_MUTED}Location: ${T_INFO}${clone_dir}${RST}"
        echo ""

        # Auto-detect and show install instructions
        if [ -f "$clone_dir/install.sh" ]; then
            echo -e "    ${T_SUCCESS}Found install.sh — run it? [y/n]:${RST}"
            echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"
            read run_install
            echo -e "${RST}"
            [[ "$run_install" =~ ^[Yy]$ ]] && bash "$clone_dir/install.sh"
        elif [ -f "$clone_dir/setup.py" ]; then
            echo -e "    ${T_INFO}Found setup.py — Python project${RST}"
            echo -e "    ${T_MUTED}Run: cd ${clone_dir} && python setup.py install${RST}"
        elif [ -f "$clone_dir/requirements.txt" ]; then
            echo -e "    ${T_INFO}Found requirements.txt${RST}"
            echo -ne "    ${T_WARNING}Install requirements? [y/n]: ${T_SUCCESS}"
            read req_install
            echo -e "${RST}"
            [[ "$req_install" =~ ^[Yy]$ ]] && pip install -r "$clone_dir/requirements.txt" 2>/dev/null
        elif [ -f "$clone_dir/package.json" ]; then
            echo -e "    ${T_INFO}Found package.json — Node.js project${RST}"
            echo -e "    ${T_MUTED}Run: cd ${clone_dir} && npm install${RST}"
        elif [ -f "$clone_dir/Makefile" ]; then
            echo -e "    ${T_INFO}Found Makefile${RST}"
            echo -e "    ${T_MUTED}Run: cd ${clone_dir} && make${RST}"
        fi
    else
        echo -e "    $(badge_fail) Clone failed!"
    fi

    go_back package_plugin_menu
}


# ═══════════════════════════════════════════════════════════════
#  DEV ENVIRONMENT AUTO-INSTALLERS
# ═══════════════════════════════════════════════════════════════

env_install_helper() {
    local name="$1"
    shift
    local packages=("$@")

    sub_banner "🔧 ${name} ENVIRONMENT SETUP"

    echo -e "    ${T_INFO}Packages to install:${RST}"
    echo -e "    ${T_MUTED}${packages[*]}${RST}"
    echo ""
    echo -ne "    ${T_WARNING}Continue? [y/n]: ${T_SUCCESS}"
    read confirm
    echo -e "${RST}"

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        premium_bar "Updating" 1
        apt update -y &>/dev/null

        for pkg in "${packages[@]}"; do
            spin "Installing ${pkg}..." 1 $((RANDOM % 8 + 1))
            apt install -y "$pkg" &>/dev/null 2>&1 || pip install "$pkg" &>/dev/null 2>&1
            echo -e "\r    ${T_SUCCESS}✓ ${WH}${pkg}${RST}                         "
        done

        echo ""
        echo -e "    $(badge_ok) ${name} environment ready!"

        # Version check
        echo ""
        echo -e "    ${T_ACCENT}Versions:${RST}"
        case "$name" in
            *Python*) python3 --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
                      pip --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
            *Node*)   node --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}Node: $l${RST}"; done
                      npm --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}npm: $l${RST}"; done ;;
            *Ruby*)   ruby --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
            *PHP*)    php --version 2>/dev/null | head -1 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
            *Java*)   java -version 2>&1 | head -1 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
            *Rust*)   rustc --version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
            *Go*)     go version 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done ;;
        esac
    fi

    go_back package_plugin_menu
}

env_python() { env_install_helper "🐍 Python" python python-pip clang libffi openssl-tool python-cryptography python-numpy; }
env_nodejs() { env_install_helper "📗 NodeJS" nodejs yarn; }
env_ruby()   { env_install_helper "💎 Ruby" ruby ruby-ri; }
env_php()    { env_install_helper "🐘 PHP" php php-fpm composer; }
env_java()   { env_install_helper "☕ Java" openjdk-17; }
env_rust()   { env_install_helper "🦀 Rust" rust; }
env_go()     { env_install_helper "🐹 Go" golang; }


# ═══════════════════════════════════════════════════════════════
#  BUILT-IN PLUGINS (All 15 Plugins)
# ═══════════════════════════════════════════════════════════════

# ─── PLUGIN 1: WEATHER ──────────────────────────────

weather_plugin() {
    sub_banner "🌤️ WEATHER FORECAST"

    echo -ne "    ${T_WARNING}City name (e.g. Jakarta): ${T_SUCCESS}"
    read city
    echo -e "${RST}"
    [ -z "$city" ] && city="Jakarta"

    spin "Fetching weather for $city..." 2 6

    # wttr.in compact format
    local weather=$(curl -s --max-time 8 "wttr.in/${city}?format=%l:+%c+%t+%h+%w+%p+%P" 2>/dev/null)
    local weather_art=$(curl -s --max-time 8 "wttr.in/${city}?0QnT" 2>/dev/null)

    local W=52
    draw_box $W "WEATHER — ${city^}"
    draw_box_empty $W

    if [ -n "$weather_art" ]; then
        echo "$weather_art" | head -15 | while IFS= read -r line; do
            echo -e "    ${T_BORDER}║${RST}  ${T_INFO}${line}${RST}"
        done
    elif [ -n "$weather" ]; then
        draw_box_line $W "  ${T_SUCCESS}${weather}${RST}"
    else
        draw_box_line $W "  ${T_ERROR}Could not fetch weather data${RST}"
        draw_box_line $W "  ${T_MUTED}Check internet connection${RST}"
    fi

    draw_box_empty $W

    # 3-day forecast link
    draw_box_separator $W
    draw_box_line $W "  ${T_MUTED}Full forecast:${RST}"
    draw_box_line $W "  ${T_INFO}curl wttr.in/${city}${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back plugin_list_installed
}

# ─── PLUGIN 2: CALCULATOR ───────────────────────────

calculator_plugin() {
    sub_banner "🧮 ADVANCED CALCULATOR"

    local history_file="$CONFIG_DIR/calc_history.txt"
    touch "$history_file" 2>/dev/null

    local W=52
    draw_box $W "CALCULATOR"
    draw_box_empty $W
    draw_box_line $W "  ${T_INFO}Enter math expressions. Type 'q' to quit.${RST}"
    draw_box_line $W "  ${T_MUTED}Supports: +, -, *, /, ^, sqrt(), sin()...${RST}"
    draw_box_line $W "  ${T_MUTED}Type 'history' to see past calculations${RST}"
    draw_box_line $W "  ${T_MUTED}Type 'clear' to clear history${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    echo ""

    while true; do
        echo -ne "    ${T_PRIMARY}calc${T_MUTED}> ${T_SUCCESS}"
        read expr
        echo -e "${RST}"

        [ -z "$expr" ] && continue
        [ "$expr" = "q" ] || [ "$expr" = "quit" ] || [ "$expr" = "exit" ] && break

        if [ "$expr" = "history" ]; then
            echo -e "    ${T_ACCENT}Calculation History:${RST}"
            if [ -s "$history_file" ]; then
                tail -20 "$history_file" | while IFS= read -r h; do
                    echo -e "    ${T_MUTED}$h${RST}"
                done
            else
                echo -e "    ${T_MUTED}No history yet${RST}"
            fi
            echo ""
            continue
        fi

        if [ "$expr" = "clear" ]; then
            > "$history_file"
            echo -e "    ${T_SUCCESS}History cleared${RST}"
            echo ""
            continue
        fi

        # Constants replacement
        local calc_expr="$expr"
        calc_expr=$(echo "$calc_expr" | sed 's/pi/3.14159265358979/g')
        calc_expr=$(echo "$calc_expr" | sed 's/e\b/2.71828182845904/g')
        calc_expr=$(echo "$calc_expr" | sed 's/\^/**/g')

        # Try bc first, then python
        local result=$(echo "scale=10; $calc_expr" | bc -l 2>/dev/null)

        if [ -z "$result" ] || [ "$result" = "" ]; then
            result=$(python3 -c "
import math
try:
    r = eval('$calc_expr')
    print(f'{r:.10g}')
except Exception as e:
    print(f'Error: {e}')
" 2>/dev/null)
        fi

        if [ -n "$result" ]; then
            echo -e "    ${T_SUCCESS}= ${WH}${BLD}${result}${RST}"
            echo "$(date +%H:%M:%S) | $expr = $result" >> "$history_file"
        else
            echo -e "    ${T_ERROR}Error: Invalid expression${RST}"
        fi
        echo ""
    done

    plugin_list_installed
}

# ─── PLUGIN 3: NOTES MANAGER ────────────────────────

notes_plugin() {
    sub_banner "📝 QUICK NOTES"

    local notes_dir="$CONFIG_DIR/notes"
    mkdir -p "$notes_dir" 2>/dev/null

    local W=52
    draw_box $W "NOTES MANAGER"
    draw_box_empty $W
    menu_item "1" "📝" "Create New Note"         $W
    menu_item "2" "📋" "List All Notes"           $W
    menu_item "3" "👁️" " View Note"               $W
    menu_item "4" "✏️" " Edit Note"               $W
    menu_item "5" "🗑️" " Delete Note"             $W
    menu_item "6" "🔍" "Search Notes"            $W
    menu_item "7" "📦" "Export All Notes"         $W
    draw_box_empty $W
    menu_item_red "0" "←" "Back"                 $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"
    read nchoice
    echo -e "${RST}"

    case $nchoice in
        1)
            echo -ne "    ${T_WARNING}Note title: ${T_SUCCESS}"; read title
            echo -e "${RST}"
            [ -z "$title" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; notes_plugin; return; }
            local filename=$(echo "$title" | tr ' ' '_' | tr -cd 'a-zA-Z0-9_').txt
            echo -e "    ${T_INFO}Type your note. End with empty line:${RST}"
            local content=""
            while IFS= read -r line; do
                [ -z "$line" ] && break
                content+="$line"$'\n'
            done
            echo "Title: $title" > "$notes_dir/$filename"
            echo "Date: $(date)" >> "$notes_dir/$filename"
            echo "---" >> "$notes_dir/$filename"
            echo "$content" >> "$notes_dir/$filename"
            echo -e "    $(badge_ok) Note saved: ${WH}$filename${RST}"
            ;;
        2)
            echo -e "    ${T_ACCENT}Your Notes:${RST}"
            echo ""
            local count=0
            for f in "$notes_dir"/*.txt; do
                [ -f "$f" ] || continue
                ((count++))
                local name=$(basename "$f" .txt)
                local date_line=$(grep "^Date:" "$f" | head -1 | cut -d: -f2- | xargs)
                echo -e "    ${T_SUCCESS}[${WH}${count}${T_SUCCESS}]${RST} ${T_INFO}${name}${RST} ${T_MUTED}— ${date_line}${RST}"
            done
            [ $count -eq 0 ] && echo -e "    ${T_MUTED}No notes yet.${RST}"
            ;;
        3)
            echo -ne "    ${T_WARNING}Note name (without .txt): ${T_SUCCESS}"; read vname; echo -e "${RST}"
            local vfile="$notes_dir/${vname}.txt"
            if [ -f "$vfile" ]; then
                draw_line "━" 50 "${T_BORDER}"
                cat "$vfile" | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
                draw_line "━" 50 "${T_BORDER}"
            else
                echo -e "    ${T_ERROR}Note not found!${RST}"
            fi
            ;;
        4)
            echo -ne "    ${T_WARNING}Note name (without .txt): ${T_SUCCESS}"; read ename; echo -e "${RST}"
            local efile="$notes_dir/${ename}.txt"
            [ -f "$efile" ] && nano "$efile" 2>/dev/null || vi "$efile" 2>/dev/null || echo -e "    ${T_ERROR}Note not found!${RST}"
            ;;
        5)
            echo -ne "    ${T_WARNING}Note name (without .txt): ${T_SUCCESS}"; read dname; echo -e "${RST}"
            local dfile="$notes_dir/${dname}.txt"
            if [ -f "$dfile" ]; then
                rm -f "$dfile"
                echo -e "    $(badge_ok) Note deleted!"
            else
                echo -e "    ${T_ERROR}Not found!${RST}"
            fi
            ;;
        6)
            echo -ne "    ${T_WARNING}Search keyword: ${T_SUCCESS}"; read skey; echo -e "${RST}"
            grep -rl "$skey" "$notes_dir/" 2>/dev/null | while IFS= read -r f; do
                echo -e "    ${T_SUCCESS}📄 ${WH}$(basename "$f")${RST}"
                grep --color=always -n "$skey" "$f" | head -3 | while IFS= read -r l; do
                    echo -e "      ${T_MUTED}$l${RST}"
                done
            done
            ;;
        7)
            local export_file="$HOME/notes_export_$(date +%Y%m%d).txt"
            echo "═══ KyyInfinite Notes Export — $(date) ═══" > "$export_file"
            for f in "$notes_dir"/*.txt; do
                [ -f "$f" ] || continue
                echo "" >> "$export_file"
                echo "═══ $(basename "$f") ═══" >> "$export_file"
                cat "$f" >> "$export_file"
            done
            echo -e "    $(badge_ok) Exported to: ${WH}${export_file}${RST}"
            ;;
        0) plugin_list_installed; return ;;
    esac

    echo ""
    echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    notes_plugin
}

# ─── PLUGIN 4: BOOKMARK MANAGER ─────────────────────

bookmark_plugin() {
    sub_banner "🔖 BOOKMARK MANAGER"

    local bm_file="$CONFIG_DIR/bookmarks.txt"
    touch "$bm_file" 2>/dev/null

    local W=52
    draw_box $W "BOOKMARKS"
    draw_box_empty $W
    menu_item "1" "➕" "Add Bookmark"     $W
    menu_item "2" "📋" "List Bookmarks"   $W
    menu_item "3" "🗑️" " Delete Bookmark"  $W
    menu_item "4" "🔍" "Search Bookmarks" $W
    draw_box_empty $W
    menu_item_red "0" "←" "Back"          $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"
    read bchoice
    echo -e "${RST}"

    case $bchoice in
        1)
            echo -ne "    ${T_WARNING}URL: ${T_SUCCESS}"; read burl
            echo -ne "    ${T_WARNING}Name/Description: ${T_SUCCESS}"; read bname
            echo -e "${RST}"
            [ -n "$burl" ] && {
                echo "$(date +%Y-%m-%d)|${bname:-Untitled}|${burl}" >> "$bm_file"
                echo -e "    $(badge_ok) Bookmark saved!"
            }
            ;;
        2)
            echo -e "    ${T_ACCENT}Your Bookmarks:${RST}"
            echo ""
            local i=1
            while IFS='|' read -r date name url; do
                echo -e "    ${T_SUCCESS}[${WH}${i}${T_SUCCESS}]${RST} ${T_INFO}${name}${RST}"
                echo -e "        ${T_MUTED}${url}${RST}  ${T_MUTED}(${date})${RST}"
                ((i++))
            done < "$bm_file"
            [ $i -eq 1 ] && echo -e "    ${T_MUTED}No bookmarks yet.${RST}"
            ;;
        3)
            echo -ne "    ${T_WARNING}Bookmark # to delete: ${T_SUCCESS}"; read dnum; echo -e "${RST}"
            if [ -n "$dnum" ]; then
                sed -i "${dnum}d" "$bm_file" 2>/dev/null
                echo -e "    $(badge_ok) Deleted!"
            fi
            ;;
        4)
            echo -ne "    ${T_WARNING}Search: ${T_SUCCESS}"; read skey; echo -e "${RST}"
            grep -i "$skey" "$bm_file" | while IFS='|' read -r date name url; do
                echo -e "    ${T_SUCCESS}● ${WH}${name}${RST} — ${T_INFO}${url}${RST}"
            done
            ;;
        0) plugin_list_installed; return ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    bookmark_plugin
}

# ─── PLUGIN 5: TIMER & STOPWATCH ────────────────────

timer_plugin() {
    sub_banner "⏱️ TIMER & STOPWATCH"

    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Countdown Timer${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}Stopwatch${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Pomodoro Timer (25/5 min)${RST}"
    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read tchoice; echo -e "${RST}"

    case $tchoice in
        1)
            echo -ne "    ${T_WARNING}Seconds: ${T_SUCCESS}"; read secs; echo -e "${RST}"
            secs=${secs:-60}
            echo ""
            for ((remaining=secs; remaining>0; remaining--)); do
                local mins=$((remaining / 60))
                local s=$((remaining % 60))
                local bar_w=30
                local elapsed=$((secs - remaining))
                local filled=$((elapsed * bar_w / secs))

                echo -ne "\r    ${T_PRIMARY}⏱️  $(printf '%02d:%02d' $mins $s) ${T_BORDER}["
                for ((b=0; b<filled; b++)); do echo -ne "${T_SUCCESS}█"; done
                for ((b=filled; b<bar_w; b++)); do echo -ne "${T_MUTED}░"; done
                echo -ne "${T_BORDER}] ${T_MUTED}$((elapsed * 100 / secs))%${RST}"

                sleep 1
            done
            echo ""
            echo ""
            echo -e "    ${T_SUCCESS}${BLD}⏰ TIME'S UP! 🔔${RST}"

            # Try to play sound
            termux-notification -t "Timer Complete" -c "Your countdown has finished!" 2>/dev/null
            termux-vibrate -d 500 2>/dev/null
            ;;
        2)
            echo -e "    ${T_INFO}Stopwatch running... Press Ctrl+C to stop${RST}"
            echo ""
            local start_ts=$(date +%s)
            local lap=0
            trap 'echo ""; echo -e "    ${T_SUCCESS}${BLD}Stopped!${RST}"; break' INT
            while true; do
                local now=$(date +%s)
                local elapsed=$((now - start_ts))
                local h=$((elapsed / 3600))
                local m=$(( (elapsed % 3600) / 60 ))
                local s=$((elapsed % 60))
                echo -ne "\r    ${T_PRIMARY}⏱️  $(printf '%02d:%02d:%02d' $h $m $s)${RST}  ${T_MUTED}(Press Ctrl+C to stop)${RST}  "
                sleep 1
            done
            trap trap_handler INT
            ;;
        3)
            echo -e "    ${T_INFO}🍅 Pomodoro: 25 min work → 5 min break${RST}"
            echo ""

            # Work phase
            echo -e "    ${T_SUCCESS}${BLD}WORK SESSION — 25 minutes${RST}"
            for ((remaining=1500; remaining>0; remaining--)); do
                local mins=$((remaining / 60))
                local s=$((remaining % 60))
                echo -ne "\r    ${T_PRIMARY}🍅 WORK $(printf '%02d:%02d' $mins $s)${RST}  "
                sleep 1
            done
            echo ""
            echo -e "    ${T_SUCCESS}${BLD}✓ Work session complete!${RST}"
            termux-vibrate -d 500 2>/dev/null
            termux-notification -t "Pomodoro" -c "Work session done! Take a break." 2>/dev/null

            # Break phase
            echo ""
            echo -e "    ${T_INFO}${BLD}BREAK — 5 minutes${RST}"
            for ((remaining=300; remaining>0; remaining--)); do
                local mins=$((remaining / 60))
                local s=$((remaining % 60))
                echo -ne "\r    ${T_ACCENT}☕ BREAK $(printf '%02d:%02d' $mins $s)${RST}  "
                sleep 1
            done
            echo ""
            echo -e "    ${T_SUCCESS}${BLD}✓ Break over! Back to work! 💪${RST}"
            termux-vibrate -d 500 2>/dev/null
            ;;
    esac

    go_back plugin_list_installed
}

# ─── PLUGIN 6: SYSTEM MONITOR ───────────────────────

sysmonitor_plugin() {
    sub_banner "📊 SYSTEM MONITOR DASHBOARD"
    echo -e "    ${T_INFO}Real-time monitoring (20 cycles, 3s interval)${RST}"
    echo -e "    ${T_MUTED}Press Ctrl+C to stop${RST}"
    sleep 1

    for ((cycle=1; cycle<=20; cycle++)); do
        clear
        echo ""
        echo -e "    ${T_ACCENT}${BLD}◆ KYYINFINITE SYSTEM MONITOR ◆${RST}  ${T_MUTED}Cycle: ${cycle}/20${RST}"
        draw_line "═" 50 "${T_ACCENT}"

        # Time & Uptime
        echo -e "    ${T_WARNING}⏰ Time    ${T_MUTED}: ${T_SUCCESS}$(date '+%H:%M:%S')${RST}  ${T_WARNING}Up ${T_MUTED}: ${T_INFO}$(uptime -p 2>/dev/null | sed 's/up //')${RST}"

        # CPU Load
        local load=$(cat /proc/loadavg 2>/dev/null | awk '{print $1, $2, $3}')
        echo -e "    ${T_WARNING}⚡ Load   ${T_MUTED}: ${T_INFO}${load:-N/A}${RST}"

        # Memory
        local mem_info=$(free -h 2>/dev/null | awk '/Mem:/{printf "Used: %s / %s (Free: %s)", $3, $2, $4}')
        echo -e "    ${T_WARNING}💾 Memory ${T_MUTED}: ${T_INFO}${mem_info}${RST}"

        # Memory bar
        local mem_pct=$(free 2>/dev/null | awk '/Mem:/{printf "%.0f", $3/$2*100}')
        if [ -n "$mem_pct" ]; then
            local bar_w=30
            local bar_filled=$((mem_pct * bar_w / 100))
            local mc="${T_SUCCESS}"; [ "$mem_pct" -gt 60 ] && mc="${T_WARNING}"; [ "$mem_pct" -gt 85 ] && mc="${T_ERROR}"
            echo -ne "    ${T_MUTED}          ["
            for ((b=0; b<bar_filled; b++)); do echo -ne "${mc}█"; done
            for ((b=bar_filled; b<bar_w; b++)); do echo -ne "${T_MUTED}░"; done
            echo -e "${T_MUTED}] ${mc}${mem_pct}%${RST}"
        fi

        # Disk
        local disk_info=$(df -h / 2>/dev/null | awk 'NR==2{printf "Used: %s / %s (%s)", $3, $2, $5}')
        echo -e "    ${T_WARNING}💽 Disk   ${T_MUTED}: ${T_INFO}${disk_info}${RST}"

        # Network
        local rx_bytes=$(cat /proc/net/dev 2>/dev/null | grep wlan0 | awk '{print $2}')
        local tx_bytes=$(cat /proc/net/dev 2>/dev/null | grep wlan0 | awk '{print $10}')
        if [ -n "$rx_bytes" ]; then
            local rx_mb=$(echo "scale=1; $rx_bytes / 1048576" | bc 2>/dev/null || echo "?")
            local tx_mb=$(echo "scale=1; $tx_bytes / 1048576" | bc 2>/dev/null || echo "?")
            echo -e "    ${T_WARNING}📡 Net    ${T_MUTED}: ${T_SUCCESS}↓${rx_mb}MB ${T_ERROR}↑${tx_mb}MB${RST}"
        fi

        # Processes
        local proc_count=$(ps aux 2>/dev/null | wc -l)
        echo -e "    ${T_WARNING}🔄 Procs  ${T_MUTED}: ${T_INFO}${proc_count}${RST}"

        # Battery
        local bat=$(termux-battery-status 2>/dev/null)
        local bat_pct=$(echo "$bat" | grep -o '"percentage":[0-9]*' | cut -d: -f2)
        local bat_st=$(echo "$bat" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$bat_pct" ]; then
            local bc="${T_SUCCESS}"; [ "$bat_pct" -lt 30 ] && bc="${T_WARNING}"; [ "$bat_pct" -lt 15 ] && bc="${T_ERROR}"
            echo -e "    ${T_WARNING}🔋 Battery${T_MUTED}: ${bc}${bat_pct}% ${T_MUTED}(${bat_st})${RST}"
        fi

        draw_line "─" 50 "${T_MUTED}"

        # Top processes
        echo -e "    ${T_ACCENT}Top Processes (by memory):${RST}"
        ps aux --sort=-%mem 2>/dev/null | head -6 | tail -5 | while IFS= read -r p; do
            echo -e "    ${T_MUTED}$(echo "$p" | awk '{printf "%-8s %5s%% %5s%%  %s", $1, $3, $4, $11}')${RST}"
        done

        sleep 3
    done

    go_back plugin_list_installed
}

# ─── PLUGIN 7: GIT TOOLKIT ──────────────────────────

git_plugin() {
    sub_banner "🔧 GIT TOOLKIT"

    local W=52
    draw_box $W "GIT TOOLS"
    draw_box_empty $W
    menu_item "1" "📊" "Git Status"                $W
    menu_item "2" "📋" "Git Log (Pretty)"          $W
    menu_item "3" "🌿" "Branch Manager"            $W
    menu_item "4" "💾" "Quick Commit & Push"       $W
    menu_item "5" "📥" "Clone Repository"          $W
    menu_item "6" "⚙️" " Git Config"               $W
    menu_item "7" "📈" "Repo Statistics"           $W
    draw_box_empty $W
    menu_item_red "0" "←" "Back"                   $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read gchoice; echo -e "${RST}"

    case $gchoice in
        1)
            echo -e "    ${T_ACCENT}Git Status:${RST}"
            git status 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done || echo -e "    ${T_ERROR}Not a git repo${RST}"
            ;;
        2)
            echo -e "    ${T_ACCENT}Git Log:${RST}"
            git log --oneline --graph --decorate -20 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done || echo -e "    ${T_ERROR}Not a git repo${RST}"
            ;;
        3)
            echo -e "    ${T_ACCENT}Branches:${RST}"
            git branch -a 2>/dev/null | while IFS= read -r l; do
                if echo "$l" | grep -q "^\*"; then
                    echo -e "    ${T_SUCCESS}$l${RST}"
                else
                    echo -e "    ${T_INFO}$l${RST}"
                fi
            done
            echo ""
            echo -ne "    ${T_WARNING}Switch to branch: ${T_SUCCESS}"; read bname; echo -e "${RST}"
            [ -n "$bname" ] && git checkout "$bname" 2>/dev/null
            ;;
        4)
            echo -ne "    ${T_WARNING}Commit message: ${T_SUCCESS}"; read cmsg; echo -e "${RST}"
            cmsg=${cmsg:-"Auto commit by KyyInfinite"}
            git add -A 2>/dev/null
            git commit -m "$cmsg" 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
            echo -ne "    ${T_WARNING}Push? [y/n]: ${T_SUCCESS}"; read push_confirm; echo -e "${RST}"
            [[ "$push_confirm" =~ ^[Yy]$ ]] && git push 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
            ;;
        5)
            echo -ne "    ${T_WARNING}Repository URL: ${T_SUCCESS}"; read repo_url; echo -e "${RST}"
            [ -n "$repo_url" ] && {
                spin "Cloning..." 3 4
                git clone "$repo_url" 2>&1 | tail -3 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
            }
            ;;
        6)
            echo -e "    ${T_ACCENT}Current Config:${RST}"
            echo -e "    ${T_WARNING}Name : ${T_SUCCESS}$(git config user.name 2>/dev/null || echo 'Not set')${RST}"
            echo -e "    ${T_WARNING}Email: ${T_SUCCESS}$(git config user.email 2>/dev/null || echo 'Not set')${RST}"
            echo ""
            echo -ne "    ${T_WARNING}Set name? (leave empty to skip): ${T_SUCCESS}"; read gname; echo -e "${RST}"
            [ -n "$gname" ] && git config --global user.name "$gname"
            echo -ne "    ${T_WARNING}Set email? (leave empty to skip): ${T_SUCCESS}"; read gemail; echo -e "${RST}"
            [ -n "$gemail" ] && git config --global user.email "$gemail"
            ;;
        7)
            echo -e "    ${T_ACCENT}Repository Stats:${RST}"
            local total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
            local total_branches=$(git branch -a 2>/dev/null | wc -l)
            local total_tags=$(git tag 2>/dev/null | wc -l)
            local first_commit=$(git log --reverse --format="%ai" 2>/dev/null | head -1)
            local last_commit=$(git log -1 --format="%ai" 2>/dev/null)
            local contributors=$(git shortlog -s -n 2>/dev/null | wc -l)
            local repo_size=$(du -sh .git 2>/dev/null | cut -f1)

            local W=42
            draw_box $W "REPO STATS"
            draw_box_empty $W
            draw_box_line $W "  ${T_WARNING}Commits      ${T_MUTED}: ${T_SUCCESS}${total_commits}${RST}"
            draw_box_line $W "  ${T_WARNING}Branches     ${T_MUTED}: ${T_SUCCESS}${total_branches}${RST}"
            draw_box_line $W "  ${T_WARNING}Tags         ${T_MUTED}: ${T_SUCCESS}${total_tags}${RST}"
            draw_box_line $W "  ${T_WARNING}Contributors ${T_MUTED}: ${T_SUCCESS}${contributors}${RST}"
            draw_box_line $W "  ${T_WARNING}.git Size    ${T_MUTED}: ${T_SUCCESS}${repo_size}${RST}"
            draw_box_line $W "  ${T_WARNING}First Commit ${T_MUTED}: ${T_INFO}${first_commit:0:19}${RST}"
            draw_box_line $W "  ${T_WARNING}Last Commit  ${T_MUTED}: ${T_INFO}${last_commit:0:19}${RST}"
            draw_box_empty $W
            draw_box_bottom $W
            ;;
        0) plugin_list_installed; return ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    git_plugin
}

# ─── PLUGIN 8: SERVER TOOLS ─────────────────────────

server_plugin() {
    sub_banner "🖥️ SERVER TOOLS"

    local W=52
    draw_box $W "SERVER UTILITIES"
    draw_box_empty $W
    menu_item "1" "🌐" "Quick HTTP Server"         $W
    menu_item "2" "📡" "PHP Development Server"    $W
    menu_item "3" "🐍" "Python HTTP Server"        $W
    menu_item "4" "📂" "File Sharing Server"       $W
    menu_item "5" "🔑" "SSH Server Setup"          $W
    menu_item "6" "📊" "Port Listener"             $W
    draw_box_empty $W
    menu_item_red "0" "←" "Back"                   $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read schoice; echo -e "${RST}"

    case $schoice in
        1)
            echo -ne "    ${T_WARNING}Port (default 8080): ${T_SUCCESS}"; read port; echo -e "${RST}"
            port=${port:-8080}
            echo -ne "    ${T_WARNING}Directory (default .): ${T_SUCCESS}"; read sdir; echo -e "${RST}"
            sdir=${sdir:-.}
            local ip=$(ip addr show 2>/dev/null | grep "inet " | grep -v 127 | awk '{print $2}' | cut -d/ -f1 | head -1)
            echo ""
            echo -e "    ${T_SUCCESS}${BLD}HTTP Server Started!${RST}"
            echo -e "    ${T_INFO}Local  : ${WH}http://localhost:${port}${RST}"
            [ -n "$ip" ] && echo -e "    ${T_INFO}Network: ${WH}http://${ip}:${port}${RST}"
            echo -e "    ${T_MUTED}Press Ctrl+C to stop${RST}"
            echo ""
            if command -v python3 &>/dev/null; then
                cd "$sdir" && python3 -m http.server "$port"
            elif command -v busybox &>/dev/null; then
                cd "$sdir" && busybox httpd -f -p "$port"
            else
                echo -e "    ${T_ERROR}No HTTP server available${RST}"
            fi
            ;;
        2)
            echo -ne "    ${T_WARNING}Port (default 8000): ${T_SUCCESS}"; read port; echo -e "${RST}"
            port=${port:-8000}
            echo -e "    ${T_SUCCESS}PHP Server on port ${port}${RST}"
            echo -e "    ${T_MUTED}Ctrl+C to stop${RST}"
            php -S 0.0.0.0:"$port" 2>/dev/null || echo -e "    ${T_ERROR}PHP not installed!${RST}"
            ;;
        3)
            echo -ne "    ${T_WARNING}Port (default 9000): ${T_SUCCESS}"; read port; echo -e "${RST}"
            port=${port:-9000}
            echo -e "    ${T_SUCCESS}Python Server on port ${port}${RST}"
            python3 -m http.server "$port" 2>/dev/null
            ;;
        4)
            local share_dir="$HOME/shared"
            mkdir -p "$share_dir"
            echo -ne "    ${T_WARNING}Port (default 7777): ${T_SUCCESS}"; read port; echo -e "${RST}"
            port=${port:-7777}
            echo -e "    ${T_SUCCESS}Sharing directory: ${WH}${share_dir}${RST}"
            echo -e "    ${T_MUTED}Place files in ${share_dir} to share${RST}"
            cd "$share_dir" && python3 -m http.server "$port" 2>/dev/null
            ;;
        5)
            echo -e "    ${T_INFO}Setting up SSH Server...${RST}"
            if command -v sshd &>/dev/null; then
                echo -ne "    ${T_WARNING}Set password: ${T_SUCCESS}"; read -s ssh_pass; echo ""; echo -e "${RST}"
                [ -n "$ssh_pass" ] && echo "$ssh_pass" | passwd &>/dev/null 2>&1
                sshd 2>/dev/null
                local ssh_port=$(grep "^Port" "$PREFIX/etc/ssh/sshd_config" 2>/dev/null | awk '{print $2}')
                ssh_port=${ssh_port:-8022}
                local ip=$(ip addr show 2>/dev/null | grep "inet " | grep -v 127 | awk '{print $2}' | cut -d/ -f1 | head -1)
                echo -e "    ${T_SUCCESS}${BLD}SSH Server Running!${RST}"
                echo -e "    ${T_INFO}Connect: ${WH}ssh $(whoami)@${ip:-localhost} -p ${ssh_port}${RST}"
            else
                echo -e "    ${T_WARNING}Installing openssh...${RST}"
                apt install -y openssh &>/dev/null
                echo -e "    $(badge_ok) OpenSSH installed! Run again."
            fi
            ;;
        6)
            echo -ne "    ${T_WARNING}Port to listen on: ${T_SUCCESS}"; read lport; echo -e "${RST}"
            [ -n "$lport" ] && {
                echo -e "    ${T_INFO}Listening on port ${lport}... Ctrl+C to stop${RST}"
                nc -lvp "$lport" 2>/dev/null || echo -e "    ${T_ERROR}nc not found. Install: pkg install nmap${RST}"
            }
            ;;
        0) plugin_list_installed; return ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    server_plugin
}

# ─── PLUGIN 9: SOCIAL MEDIA OSINT ───────────────────

social_plugin() {
    sub_banner "📱 SOCIAL MEDIA OSINT"

    local W=52
    draw_box $W "SOCIAL OSINT"
    draw_box_empty $W
    menu_item "1" "👤" "Multi-Platform Username Search"  $W
    menu_item "2" "📸" "Instagram Profile Info"          $W
    menu_item "3" "🐦" "Twitter/X Profile Info"          $W
    menu_item "4" "📱" "TikTok Profile Info"             $W
    menu_item "5" "💼" "LinkedIn Profile Search"         $W
    menu_item "6" "🎮" "Discord User Lookup"             $W
    draw_box_empty $W
    menu_item_red "0" "←" "Back"                         $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read sochoice; echo -e "${RST}"

    case $sochoice in
        1)
            echo -ne "    ${T_WARNING}Username: ${T_SUCCESS}"; read uname; echo -e "${RST}"
            [ -z "$uname" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; social_plugin; return; }

            premium_bar "Searching across platforms" 3

            declare -A platforms
            platforms=(
                ["GitHub"]="https://api.github.com/users/${uname}"
                ["Instagram"]="https://www.instagram.com/${uname}/"
                ["Twitter"]="https://x.com/${uname}"
                ["TikTok"]="https://www.tiktok.com/@${uname}"
                ["Reddit"]="https://www.reddit.com/user/${uname}/about.json"
                ["YouTube"]="https://www.youtube.com/@${uname}"
                ["Twitch"]="https://www.twitch.tv/${uname}"
                ["Medium"]="https://medium.com/@${uname}"
                ["Pinterest"]="https://www.pinterest.com/${uname}/"
                ["LinkedIn"]="https://www.linkedin.com/in/${uname}/"
                ["GitLab"]="https://gitlab.com/${uname}"
                ["Telegram"]="https://t.me/${uname}"
                ["Spotify"]="https://open.spotify.com/user/${uname}"
                ["Steam"]="https://steamcommunity.com/id/${uname}"
                ["Patreon"]="https://www.patreon.com/${uname}"
                ["DeviantArt"]="https://www.deviantart.com/${uname}"
            )

            local W=52
            draw_box $W "USERNAME — @${uname}"
            draw_box_empty $W

            for platform in $(echo "${!platforms[@]}" | tr ' ' '\n' | sort); do
                local url="${platforms[$platform]}"
                local code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null)

                if [ "$code" = "200" ]; then
                    draw_box_line $W "  ${T_SUCCESS}✓ ${WH}${platform}${RST}"
                    draw_box_line $W "    ${T_MUTED}${url:0:44}${RST}"
                elif [ "$code" = "404" ]; then
                    draw_box_line $W "  ${T_ERROR}✗ ${T_MUTED}${platform} — Not found${RST}"
                else
                    draw_box_line $W "  ${T_WARNING}? ${T_MUTED}${platform} — HTTP ${code}${RST}"
                fi
            done

            draw_box_empty $W
            draw_box_bottom $W
            ;;
        2|3|4|5|6)
            echo -ne "    ${T_WARNING}Username/Profile: ${T_SUCCESS}"; read profile; echo -e "${RST}"
            echo -e "    ${T_INFO}Opening browser for profile lookup...${RST}"
            echo -e "    ${T_MUTED}Manual OSINT recommended for detailed info${RST}"
            echo ""

            case $sochoice in
                2) echo -e "    ${T_INFO}https://www.instagram.com/${profile}/${RST}" ;;
                3) echo -e "    ${T_INFO}https://x.com/${profile}${RST}" ;;
                4) echo -e "    ${T_INFO}https://www.tiktok.com/@${profile}${RST}" ;;
                5) echo -e "    ${T_INFO}https://www.linkedin.com/in/${profile}/${RST}" ;;
                6) echo -e "    ${T_INFO}Discord: Lookup requires bot API access${RST}" ;;
            esac

            termux-open-url "https://www.instagram.com/${profile}/" 2>/dev/null
            ;;
        0) plugin_list_installed; return ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    social_plugin
}

# ─── PLUGIN 10: UNIT CONVERTER ──────────────────────

converter_plugin() {
    sub_banner "🔀 UNIT CONVERTER"

    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Temperature${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}Length/Distance${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Weight/Mass${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Data Storage${RST}"
    echo -e "    ${T_SUCCESS}[${WH}5${T_SUCCESS}]${RST} ${T_INFO}Time${RST}"
    echo -e "    ${T_SUCCESS}[${WH}6${T_SUCCESS}]${RST} ${T_INFO}Currency (USD base)${RST}"
    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read cchoice; echo -e "${RST}"

    case $cchoice in
        1)
            echo -ne "    ${T_WARNING}Temperature: ${T_SUCCESS}"; read temp
            echo -ne "    ${T_WARNING}From [C/F/K]: ${T_SUCCESS}"; read from_unit; echo -e "${RST}"
            from_unit=${from_unit^^}
            case $from_unit in
                C)
                    local f=$(echo "scale=2; $temp * 9/5 + 32" | bc 2>/dev/null)
                    local k=$(echo "scale=2; $temp + 273.15" | bc 2>/dev/null)
                    echo -e "    ${T_SUCCESS}${temp}°C = ${f}°F = ${k}K${RST}"
                    ;;
                F)
                    local c=$(echo "scale=2; ($temp - 32) * 5/9" | bc 2>/dev/null)
                    local k=$(echo "scale=2; ($temp - 32) * 5/9 + 273.15" | bc 2>/dev/null)
                    echo -e "    ${T_SUCCESS}${temp}°F = ${c}°C = ${k}K${RST}"
                    ;;
                K)
                    local c=$(echo "scale=2; $temp - 273.15" | bc 2>/dev/null)
                    local f=$(echo "scale=2; ($temp - 273.15) * 9/5 + 32" | bc 2>/dev/null)
                    echo -e "    ${T_SUCCESS}${temp}K = ${c}°C = ${f}°F${RST}"
                    ;;
            esac
            ;;
        2)
            echo -ne "    ${T_WARNING}Value: ${T_SUCCESS}"; read val
            echo -ne "    ${T_WARNING}From [km/mi/m/ft/cm/in]: ${T_SUCCESS}"; read from; echo -e "${RST}"
            local meters
            case ${from,,} in
                km) meters=$(echo "$val * 1000" | bc 2>/dev/null) ;;
                mi) meters=$(echo "$val * 1609.344" | bc 2>/dev/null) ;;
                m)  meters=$val ;;
                ft) meters=$(echo "$val * 0.3048" | bc 2>/dev/null) ;;
                cm) meters=$(echo "scale=4; $val / 100" | bc 2>/dev/null) ;;
                in) meters=$(echo "scale=4; $val * 0.0254" | bc 2>/dev/null) ;;
            esac
            [ -n "$meters" ] && {
                echo -e "    ${T_SUCCESS}= $(echo "scale=4; $meters / 1000" | bc)km${RST}"
                echo -e "    ${T_SUCCESS}= ${meters}m${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=2; $meters * 3.28084" | bc)ft${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=4; $meters / 1609.344" | bc)mi${RST}"
            }
            ;;
        3)
            echo -ne "    ${T_WARNING}Value: ${T_SUCCESS}"; read val
            echo -ne "    ${T_WARNING}From [kg/lb/g/oz]: ${T_SUCCESS}"; read from; echo -e "${RST}"
            local grams
            case ${from,,} in
                kg) grams=$(echo "$val * 1000" | bc 2>/dev/null) ;;
                lb) grams=$(echo "$val * 453.592" | bc 2>/dev/null) ;;
                g)  grams=$val ;;
                oz) grams=$(echo "$val * 28.3495" | bc 2>/dev/null) ;;
            esac
            [ -n "$grams" ] && {
                echo -e "    ${T_SUCCESS}= $(echo "scale=3; $grams / 1000" | bc)kg${RST}"
                echo -e "    ${T_SUCCESS}= ${grams}g${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=3; $grams / 453.592" | bc)lb${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=2; $grams / 28.3495" | bc)oz${RST}"
            }
            ;;
        4)
            echo -ne "    ${T_WARNING}Value: ${T_SUCCESS}"; read val
            echo -ne "    ${T_WARNING}From [B/KB/MB/GB/TB]: ${T_SUCCESS}"; read from; echo -e "${RST}"
            local bytes
            case ${from^^} in
                B)  bytes=$val ;;
                KB) bytes=$(echo "$val * 1024" | bc 2>/dev/null) ;;
                MB) bytes=$(echo "$val * 1048576" | bc 2>/dev/null) ;;
                GB) bytes=$(echo "$val * 1073741824" | bc 2>/dev/null) ;;
                TB) bytes=$(echo "$val * 1099511627776" | bc 2>/dev/null) ;;
            esac
            [ -n "$bytes" ] && {
                echo -e "    ${T_SUCCESS}= ${bytes} B${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=2; $bytes / 1024" | bc) KB${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=2; $bytes / 1048576" | bc) MB${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=4; $bytes / 1073741824" | bc) GB${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=6; $bytes / 1099511627776" | bc) TB${RST}"
            }
            ;;
        5)
            echo -ne "    ${T_WARNING}Value: ${T_SUCCESS}"; read val
            echo -ne "    ${T_WARNING}From [s/m/h/d]: ${T_SUCCESS}"; read from; echo -e "${RST}"
            local secs
            case ${from,,} in
                s) secs=$val ;;
                m) secs=$(echo "$val * 60" | bc 2>/dev/null) ;;
                h) secs=$(echo "$val * 3600" | bc 2>/dev/null) ;;
                d) secs=$(echo "$val * 86400" | bc 2>/dev/null) ;;
            esac
            [ -n "$secs" ] && {
                echo -e "    ${T_SUCCESS}= ${secs} seconds${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=2; $secs / 60" | bc) minutes${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=4; $secs / 3600" | bc) hours${RST}"
                echo -e "    ${T_SUCCESS}= $(echo "scale=4; $secs / 86400" | bc) days${RST}"
            }
            ;;
        6)
            echo -ne "    ${T_WARNING}Amount in USD: ${T_SUCCESS}"; read amount; echo -e "${RST}"
            amount=${amount:-1}
            spin "Fetching exchange rates..." 2 6
            local rates=$(curl -s --max-time 5 "https://open.er-api.com/v6/latest/USD" 2>/dev/null)
            if [ -n "$rates" ]; then
                local currencies=("IDR" "EUR" "GBP" "JPY" "KRW" "CNY" "MYR" "SGD" "AUD" "THB")
                echo ""
                echo -e "    ${T_ACCENT}$amount USD ==${RST}"
                for cur in "${currencies[@]}"; do
                    local rate=$(echo "$rates" | grep -o "\"${cur}\":[0-9.]*" | cut -d: -f2)
                    if [ -n "$rate" ]; then
                        local converted=$(echo "scale=2; $amount * $rate" | bc 2>/dev/null)
                        echo -e "    ${T_SUCCESS}  ${cur}: ${WH}${converted}${RST}"
                    fi
                done
            else
                echo -e "    ${T_ERROR}Failed to fetch rates${RST}"
            fi
            ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    converter_plugin
}

# ─── PLUGIN 11: TODO LIST ───────────────────────────

todo_plugin() {
    sub_banner "✅ TODO LIST"

    local todo_file="$CONFIG_DIR/todo.txt"
    touch "$todo_file" 2>/dev/null

    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Add Task${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}List Tasks${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Complete Task${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Delete Task${RST}"
    echo -e "    ${T_SUCCESS}[${WH}5${T_SUCCESS}]${RST} ${T_INFO}Clear Completed${RST}"
    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read tchoice; echo -e "${RST}"

    case $tchoice in
        1)
            echo -ne "    ${T_WARNING}Task: ${T_SUCCESS}"; read task
            echo -ne "    ${T_WARNING}Priority [H/M/L] (default M): ${T_SUCCESS}"; read pri; echo -e "${RST}"
            pri=${pri:-M}
            [ -n "$task" ] && {
                echo "[ ] [${pri^^}] ${task} | $(date +%Y-%m-%d)" >> "$todo_file"
                echo -e "    $(badge_ok) Task added!"
            }
            ;;
        2)
            echo ""
            echo -e "    ${T_ACCENT}Your Tasks:${RST}"
            echo ""
            local i=1
            while IFS= read -r line; do
                if echo "$line" | grep -q "^\[x\]"; then
                    echo -e "    ${T_MUTED}${i}. ${STR}${line}${RST}"
                elif echo "$line" | grep -q "\[H\]"; then
                    echo -e "    ${T_ERROR}${i}. ${WH}${line}${RST}"
                elif echo "$line" | grep -q "\[L\]"; then
                    echo -e "    ${T_INFO}${i}. ${WH}${line}${RST}"
                else
                    echo -e "    ${T_WARNING}${i}. ${WH}${line}${RST}"
                fi
                ((i++))
            done < "$todo_file"
            [ $i -eq 1 ] && echo -e "    ${T_MUTED}No tasks yet!${RST}"
            ;;
        3)
            echo -ne "    ${T_WARNING}Task # to complete: ${T_SUCCESS}"; read tnum; echo -e "${RST}"
            [ -n "$tnum" ] && {
                sed -i "${tnum}s/\[ \]/[x]/" "$todo_file" 2>/dev/null
                echo -e "    $(badge_ok) Task completed! ✓"
            }
            ;;
        4)
            echo -ne "    ${T_WARNING}Task # to delete: ${T_SUCCESS}"; read tnum; echo -e "${RST}"
            [ -n "$tnum" ] && {
                sed -i "${tnum}d" "$todo_file" 2>/dev/null
                echo -e "    $(badge_ok) Task deleted!"
            }
            ;;
        5)
            sed -i '/^\[x\]/d' "$todo_file" 2>/dev/null
            echo -e "    $(badge_ok) Completed tasks cleared!"
            ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    todo_plugin
}

# ─── PLUGIN 12: QR CODE GENERATOR ───────────────────

qrcode_plugin() {
    sub_banner "📱 QR CODE GENERATOR"

    echo -ne "    ${T_WARNING}Text or URL: ${T_SUCCESS}"; read qr_text; echo -e "${RST}"
    [ -z "$qr_text" ] && { echo -e "    ${T_ERROR}[✗] Empty!${RST}"; sleep 1; plugin_list_installed; return; }

    spin "Generating QR code..." 2 6

    # Method 1: curl qrenco.de
    local qr=$(curl -s --max-time 5 "qrenco.de/${qr_text}" 2>/dev/null)
    if [ -n "$qr" ]; then
        echo -e "    ${T_ACCENT}QR Code for: ${WH}${qr_text}${RST}"
        echo ""
        echo "$qr" | while IFS= read -r l; do echo -e "    ${T_SUCCESS}$l${RST}"; done
    else
        # Method 2: Python qrcode
        python3 -c "
import sys
try:
    import qrcode
    qr = qrcode.QRCode(box_size=1, border=1)
    qr.add_data('$qr_text')
    qr.print_ascii(out=sys.stdout)
except ImportError:
    print('Install: pip install qrcode')
except Exception as e:
    print(f'Error: {e}')
" 2>/dev/null | while IFS= read -r l; do echo -e "    $l"; done
    fi

    go_back plugin_list_installed
}

# ─── PLUGIN 13: IP CHANGE MONITOR ───────────────────

ipmonitor_plugin() {
    sub_banner "🌐 IP CHANGE MONITOR"

    local ip_log="$CONFIG_DIR/ip_log.txt"
    touch "$ip_log" 2>/dev/null

    echo -e "    ${T_INFO}Monitoring IP changes... (30 checks, 10s interval)${RST}"
    echo -e "    ${T_MUTED}Press Ctrl+C to stop${RST}"
    echo ""

    local last_ip=""

    for ((check=1; check<=30; check++)); do
        local current_ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
        local timestamp=$(date '+%H:%M:%S')

        if [ "$current_ip" != "$last_ip" ] && [ -n "$current_ip" ]; then
            if [ -n "$last_ip" ]; then
                echo -e "    ${T_ERROR}⚠️  [${timestamp}] IP CHANGED: ${last_ip} → ${current_ip}${RST}"
                echo "[${timestamp}] CHANGED: ${last_ip} → ${current_ip}" >> "$ip_log"
                termux-notification -t "IP Changed!" -c "New IP: ${current_ip}" 2>/dev/null
                termux-vibrate -d 300 2>/dev/null
            else
                echo -e "    ${T_SUCCESS}✓  [${timestamp}] Current IP: ${current_ip}${RST}"
                echo "[${timestamp}] START: ${current_ip}" >> "$ip_log"
            fi
            last_ip="$current_ip"
        else
            echo -e "    ${T_MUTED}○  [${timestamp}] Check #${check}: ${current_ip:-timeout} (no change)${RST}"
        fi

        sleep 10
    done

    echo ""
    echo -e "    ${T_INFO}Monitoring complete. Log: ${WH}${ip_log}${RST}"

    go_back plugin_list_installed
}

# ─── PLUGIN 14: COLOR PICKER ────────────────────────

colorpicker_plugin() {
    sub_banner "🎨 COLOR PICKER & MIXER"

    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Pick from 256 palette${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}Enter RGB values${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Enter HEX color${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Random color generator${RST}"
    echo -e "    ${T_SUCCESS}[${WH}5${T_SUCCESS}]${RST} ${T_INFO}Color gradient preview${RST}"
    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read cchoice; echo -e "${RST}"

    case $cchoice in
        1)
            echo -ne "    ${T_WARNING}Color number (0-255): ${T_SUCCESS}"; read cnum; echo -e "${RST}"
            cnum=${cnum:-39}
            echo -e "    Color $cnum:"
            echo -e "    \033[38;5;${cnum}m████████████████████ (foreground)${RST}"
            echo -e "    \033[48;5;${cnum}m                    ${RST} (background)"
            echo -e "    ${T_MUTED}ANSI: \\033[38;5;${cnum}m${RST}"
            ;;
        2)
            echo -ne "    ${T_WARNING}Red (0-255): ${T_SUCCESS}"; read cr
            echo -ne "    ${T_WARNING}Green (0-255): ${T_SUCCESS}"; read cg
            echo -ne "    ${T_WARNING}Blue (0-255): ${T_SUCCESS}"; read cb; echo -e "${RST}"
            cr=${cr:-0}; cg=${cg:-150}; cb=${cb:-255}
            echo -e "    RGB($cr, $cg, $cb):"
            echo -e "    \033[38;2;${cr};${cg};${cb}m████████████████████ (foreground)${RST}"
            echo -e "    \033[48;2;${cr};${cg};${cb}m                    ${RST} (background)"
            printf "    ${T_MUTED}HEX: #%02x%02x%02x${RST}\n" "$cr" "$cg" "$cb"
            echo -e "    ${T_MUTED}ANSI: \\033[38;2;${cr};${cg};${cb}m${RST}"
            ;;
        3)
            echo -ne "    ${T_WARNING}HEX color (e.g. #FF5733): ${T_SUCCESS}"; read hex; echo -e "${RST}"
            hex=$(echo "$hex" | tr -d '#')
            local cr=$((16#${hex:0:2})) cg=$((16#${hex:2:2})) cb=$((16#${hex:4:2}))
            echo -e "    #${hex}:"
            echo -e "    \033[38;2;${cr};${cg};${cb}m████████████████████ (foreground)${RST}"
            echo -e "    \033[48;2;${cr};${cg};${cb}m                    ${RST} (background)"
            echo -e "    ${T_MUTED}RGB: (${cr}, ${cg}, ${cb})${RST}"
            ;;
        4)
            echo -e "    ${T_ACCENT}Random Colors:${RST}"
            for ((i=0; i<8; i++)); do
                local rr=$((RANDOM % 256)) rg=$((RANDOM % 256)) rb=$((RANDOM % 256))
                printf "    \033[48;2;${rr};${rg};${rb}m    ${RST} RGB(${rr},${rg},${rb})  #%02x%02x%02x\n" "$rr" "$rg" "$rb"
            done
            ;;
        5)
            echo -e "    ${T_ACCENT}Gradient Preview:${RST}"
            echo -n "    "
            for ((i=0; i<50; i++)); do
                local gr=$((255 - i * 5))
                local gg=$((i * 5))
                echo -ne "\033[48;2;${gr};${gg};128m "
            done
            echo -e "${RST}"
            echo -n "    "
            for ((i=0; i<50; i++)); do
                local gb=$((i * 5))
                echo -ne "\033[48;2;0;${gb};255m "
            done
            echo -e "${RST}"
            echo -n "    "
            for ((i=0; i<50; i++)); do
                local gr=$((i * 5)) gg=$((255 - i * 3)) gb=$((i * 3))
                echo -ne "\033[48;2;${gr};${gg};${gb}m "
            done
            echo -e "${RST}"
            ;;
    esac

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    colorpicker_plugin
}

# ─── PLUGIN 15: PASSWORD VAULT ──────────────────────

passmanager_plugin() {
    sub_banner "🔒 PASSWORD VAULT"

    local vault_file="$CONFIG_DIR/vault.enc"
    local vault_tmp="$CONFIG_DIR/.vault_tmp"

    echo -e "    ${T_WARNING}${BLD}⚠️  All passwords are AES-256 encrypted${RST}"
    echo ""

    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Add Password Entry${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}View All Entries${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Search Entry${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Delete Entry${RST}"
    echo -e "    ${T_SUCCESS}[${WH}5${T_SUCCESS}]${RST} ${T_INFO}Generate & Save Password${RST}"
    echo -e "    ${T_SUCCESS}[${WH}6${T_SUCCESS}]${RST} ${T_INFO}Change Master Password${RST}"
    echo -e "    ${T_SUCCESS}[${WH}7${T_SUCCESS}]${RST} ${T_INFO}Export Vault (Encrypted)${RST}"
    echo ""
    echo -ne "    ${T_WARNING}⮞ ${T_SUCCESS}"; read vchoice; echo -e "${RST}"

    # Master password
    echo -ne "    ${T_WARNING}🔐 Master Password: ${T_SUCCESS}"
    read -s master_pass
    echo ""
    echo -e "${RST}"

    [ -z "$master_pass" ] && { echo -e "    ${T_ERROR}[✗] Password required!${RST}"; sleep 1; plugin_list_installed; return; }

    # Decrypt vault
    local vault_content=""
    if [ -f "$vault_file" ]; then
        vault_content=$(openssl enc -d -aes-256-cbc -pbkdf2 -in "$vault_file" -pass pass:"$master_pass" 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo -e "    ${T_ERROR}[✗] Wrong master password!${RST}"
            sleep 2
            plugin_list_installed
            return
        fi
    fi

    case $vchoice in
        1)
            echo -ne "    ${T_WARNING}Service/Website: ${T_SUCCESS}"; read service
            echo -ne "    ${T_WARNING}Username/Email: ${T_SUCCESS}"; read username
            echo -ne "    ${T_WARNING}Password: ${T_SUCCESS}"; read -s password; echo ""
            echo -ne "    ${T_WARNING}Notes (optional): ${T_SUCCESS}"; read notes
            echo -e "${RST}"

            vault_content+="[$(date +%Y-%m-%d)] ${service} | ${username} | ${password} | ${notes}"$'\n'

            echo "$vault_content" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$vault_file" -pass pass:"$master_pass" 2>/dev/null
            echo -e "    $(badge_ok) Entry saved securely!"
            ;;
        2)
            echo ""
            echo -e "    ${T_ACCENT}Vault Entries:${RST}"
            draw_line "━" 50 "${T_BORDER}"

            if [ -n "$vault_content" ]; then
                local i=1
                while IFS= read -r line; do
                    [ -z "$line" ] && continue
                    local date_part=$(echo "$line" | grep -o '^\[[^]]*\]')
                    local rest=$(echo "$line" | sed 's/^\[[^]]*\] //')
                    local service=$(echo "$rest" | cut -d'|' -f1 | xargs)
                    local user=$(echo "$rest" | cut -d'|' -f2 | xargs)
                    local pass=$(echo "$rest" | cut -d'|' -f3 | xargs)

                    echo -e "    ${T_SUCCESS}[${WH}${i}${T_SUCCESS}]${RST} ${T_PRIMARY}${BLD}${service}${RST}"
                    echo -e "        ${T_MUTED}User: ${T_INFO}${user}${RST}"
                    echo -e "        ${T_MUTED}Pass: ${T_WARNING}${pass}${RST}"
                    echo -e "        ${T_MUTED}Date: ${date_part}${RST}"
                    echo ""
                    ((i++))
                done <<< "$vault_content"
            else
                echo -e "    ${T_MUTED}Vault is empty.${RST}"
            fi
            draw_line "━" 50 "${T_BORDER}"
            ;;
        3)
            echo -ne "    ${T_WARNING}Search: ${T_SUCCESS}"; read skey; echo -e "${RST}"
            echo ""
            echo "$vault_content" | grep -i "$skey" | while IFS= read -r line; do
                [ -z "$line" ] && continue
                echo -e "    ${T_SUCCESS}● ${WH}${line}${RST}"
            done
            ;;
        4)
            echo -e "    ${T_INFO}Current entries:${RST}"
            local i=1
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                echo -e "    ${i}. ${T_MUTED}$(echo "$line" | cut -d'|' -f1)${RST}"
                ((i++))
            done <<< "$vault_content"

            echo -ne "    ${T_WARNING}Entry # to delete: ${T_SUCCESS}"; read dnum; echo -e "${RST}"
            if [ -n "$dnum" ]; then
                vault_content=$(echo "$vault_content" | sed "${dnum}d")
                echo "$vault_content" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$vault_file" -pass pass:"$master_pass" 2>/dev/null
                echo -e "    $(badge_ok) Entry deleted!"
            fi
            ;;
        5)
            echo -ne "    ${T_WARNING}Service/Website: ${T_SUCCESS}"; read service
            echo -ne "    ${T_WARNING}Username: ${T_SUCCESS}"; read username
            echo -ne "    ${T_WARNING}Password length (default 20): ${T_SUCCESS}"; read plen; echo -e "${RST}"
            plen=${plen:-20}

            local gen_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*' | head -c "$plen")

            vault_content+="[$(date +%Y-%m-%d)] ${service} | ${username} | ${gen_pass} | Auto-generated"$'\n'
            echo "$vault_content" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$vault_file" -pass pass:"$master_pass" 2>/dev/null

            echo -e "    $(badge_ok) Generated & saved!"
            echo -e "    ${T_WARNING}🔑 Password: ${T_SUCCESS}${gen_pass}${RST}"
            ;;
        6)
            echo -ne "    ${T_WARNING}New Master Password: ${T_SUCCESS}"; read -s new_pass; echo ""
            echo -ne "    ${T_WARNING}Confirm: ${T_SUCCESS}"; read -s confirm_pass; echo ""; echo -e "${RST}"
            if [ "$new_pass" = "$confirm_pass" ]; then
                echo "$vault_content" | openssl enc -aes-256-cbc -salt -pbkdf2 -out "$vault_file" -pass pass:"$new_pass" 2>/dev/null
                echo -e "    $(badge_ok) Master password changed!"
            else
                echo -e "    ${T_ERROR}Passwords don't match!${RST}"
            fi
            ;;
        7)
            local export_path="$HOME/vault_backup_$(date +%Y%m%d).enc"
            cp "$vault_file" "$export_path" 2>/dev/null
            echo -e "    $(badge_ok) Vault exported to: ${WH}${export_path}${RST}"
            ;;
    esac

    # Clean up
    rm -f "$vault_tmp" 2>/dev/null

    echo ""; echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"; read
    passmanager_plugin
}


# ═══════════════════════════════════════════════════════════════
#  AUTO-LOAD CUSTOM PLUGINS FROM PLUGIN DIR
# ═══════════════════════════════════════════════════════════════

load_custom_plugins() {
    if [ -d "$PLUGIN_DIR" ]; then
        for plugin_file in "$PLUGIN_DIR"/*.sh; do
            [ -f "$plugin_file" ] && source "$plugin_file" 2>/dev/null
        done
    fi
}

# Load custom plugins silently
load_custom_plugins


# ═══════════════════════════════════════════════════════════════
#  FILE LOADED CONFIRMATION
# ═══════════════════════════════════════════════════════════════

log_msg "kyy-plugins.sh loaded successfully — ${#PLUGIN_REGISTRY[@]} plugins registered"
