#!/data/data/com.termux/files/usr/bin/bash

# ╔════════════════════════════════════════════════════════════════════════╗
# ║                                                                        ║
# ║    ██╗  ██╗██╗   ██╗██╗   ██╗    ╦╔╗╔╔═╗╦╔╗╔╦╔╦╗╔═╗                  ║
# ║    █████╔╝  ╚████╔╝  ╚████╔╝     ║║║║╠╣ ║║║║║ ║ ║╣                   ║
# ║    ██║  ██╗   ██║      ██║       ╩╝╚╝╚  ╩╝╚╝╩ ╩ ╚═╝                 ║
# ║                                                                        ║
# ║    FILE 2/3 — ALL MODULES (Network, WiFi, OSINT, Security, etc.)       ║
# ║    Created by: KyyInfinite                                             ║
# ║                                                                        ║
# ╚════════════════════════════════════════════════════════════════════════╝

# ─── Pastikan core sudah di-source ───────────────────
if [ -z "$VERSION" ]; then
    echo "[!] This file must be sourced from kyy-core.sh"
    echo "    Run: bash kyy-core.sh"
    exit 1
fi

# ─── SUB BANNER HELPER ──────────────────────────────
sub_banner() {
    local title="$1"
    clear
    echo ""
    draw_double_line 56 "${T_ACCENT}"
    center_text "${T_HEADER_BG}${WH}${BLD}  ◆ ${title} ◆  ${RST}"
    draw_double_line 56 "${T_ACCENT}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
#  MODULE 01: NETWORK SCANNER & WIFI TOOLS
# ═══════════════════════════════════════════════════════════════

network_menu() {
    sub_banner "🌐 NETWORK SCANNER & TOOLS"

    local W=52
    draw_box $W "NETWORK ARSENAL"
    draw_box_empty $W
    menu_item "01" "🌍" "My IP & Geolocation"       $W
    menu_item "02" "📡" "Ping Host / Website"        $W
    menu_item "03" "🔌" "Advanced Port Scanner"      $W
    menu_item "04" "🔎" "DNS Lookup"                 $W
    menu_item "05" "📋" "WHOIS Lookup"               $W
    menu_item "06" "🗺️" " Traceroute"                $W
    menu_item "07" "📨" "HTTP Header Grabber"        $W
    menu_item "08" "📶" "Network Interface Info"     $W
    menu_item "09" "🔗" "Subnet Calculator"          $W
    menu_item "10" "📊" "Bandwidth Speed Test"       $W
    menu_item "11" "🛰️" " ARP Scan (Local Net)"      $W
    menu_item "12" "🌐" "SSL/TLS Certificate Info"   $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"       $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read net_choice
    echo -e "${RST}"

    case $net_choice in
        01|1) net_my_ip ;;
        02|2) net_ping ;;
        03|3) net_port_scan ;;
        04|4) net_dns ;;
        05|5) net_whois ;;
        06|6) net_traceroute ;;
        07|7) net_http_header ;;
        08|8) net_interface ;;
        09|9) net_subnet_calc ;;
        10)   net_speed_test ;;
        11)   net_arp_scan ;;
        12)   net_ssl_info ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; network_menu ;;
    esac
}

net_my_ip() {
    sub_banner "🌍 MY IP & GEOLOCATION"
    spin "Fetching IP information..." 2 6

    local pub_ip=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo "N/A")
    local local_ip=$(ip addr show 2>/dev/null | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    local geo=$(curl -s --max-time 5 "http://ip-api.com/json/$pub_ip" 2>/dev/null)

    local country=$(echo "$geo" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
    local city=$(echo "$geo" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
    local region=$(echo "$geo" | grep -o '"regionName":"[^"]*"' | cut -d'"' -f4)
    local isp=$(echo "$geo" | grep -o '"isp":"[^"]*"' | cut -d'"' -f4)
    local org=$(echo "$geo" | grep -o '"org":"[^"]*"' | cut -d'"' -f4)
    local as_info=$(echo "$geo" | grep -o '"as":"[^"]*"' | cut -d'"' -f4)
    local tz=$(echo "$geo" | grep -o '"timezone":"[^"]*"' | cut -d'"' -f4)
    local lat=$(echo "$geo" | grep -o '"lat":[0-9.-]*' | cut -d: -f2)
    local lon=$(echo "$geo" | grep -o '"lon":[0-9.-]*' | cut -d: -f2)
    local zip_code=$(echo "$geo" | grep -o '"zip":"[^"]*"' | cut -d'"' -f4)
    local dns_ip=$(getprop net.dns1 2>/dev/null || echo "N/A")

    local W=52
    draw_box $W "IP INTELLIGENCE REPORT"
    draw_box_empty $W
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Public IP    ${T_MUTED}: ${T_SUCCESS}${pub_ip:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Local IP     ${T_MUTED}: ${T_SUCCESS}${local_ip:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}DNS Server   ${T_MUTED}: ${T_SUCCESS}${dns_ip:-N/A}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}📍 GEOLOCATION${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Country      ${T_MUTED}: ${T_INFO}${country:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Region       ${T_MUTED}: ${T_INFO}${region:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}City         ${T_MUTED}: ${T_INFO}${city:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}ZIP Code     ${T_MUTED}: ${T_INFO}${zip_code:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Latitude     ${T_MUTED}: ${T_INFO}${lat:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Longitude    ${T_MUTED}: ${T_INFO}${lon:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Timezone     ${T_MUTED}: ${T_INFO}${tz:-N/A}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}🏢 ISP / ORG${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}ISP          ${T_MUTED}: ${T_INFO}${isp:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}Org          ${T_MUTED}: ${T_INFO}${org:-N/A}${RST}"
    draw_box_line $W "  ${T_MUTED}▸ ${T_WARNING}AS           ${T_MUTED}: ${T_INFO}${as_info:-N/A}${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    if [ -n "$lat" ] && [ -n "$lon" ]; then
        echo ""
        echo -e "    ${T_MUTED}🗺️  Google Maps: ${T_INFO}https://maps.google.com/?q=${lat},${lon}${RST}"
    fi

    go_back network_menu
}

net_ping() {
    sub_banner "📡 PING HOST"
    echo -ne "    ${T_WARNING}Target host/IP: ${T_SUCCESS}"
    read target
    echo -ne "    ${T_WARNING}Packet count (default 10): ${T_SUCCESS}"
    read pcount
    echo -e "${RST}"
    pcount=${pcount:-10}

    [ -z "$target" ] && { echo -e "    ${T_ERROR}[✗] Target kosong!${RST}"; sleep 1; network_menu; return; }

    spin "Sending $pcount packets to $target..." 1 4
    echo ""
    draw_line "━" 50 "${T_BORDER}"

    ping -c "$pcount" -W 2 "$target" 2>/dev/null | while IFS= read -r line; do
        if echo "$line" | grep -q "bytes from"; then
            local ms=$(echo "$line" | grep -o 'time=[0-9.]*' | cut -d= -f2)
            local bar_len=$(echo "$ms" | cut -d. -f1)
            [ -z "$bar_len" ] && bar_len=1
            [ "$bar_len" -gt 40 ] && bar_len=40

            local color="${T_SUCCESS}"
            [ "$(echo "$ms > 100" | bc 2>/dev/null)" = "1" ] && color="${T_WARNING}"
            [ "$(echo "$ms > 300" | bc 2>/dev/null)" = "1" ] && color="${T_ERROR}"

            echo -ne "    ${color}"
            for ((b=0; b<bar_len; b++)); do echo -ne "█"; done
            echo -e " ${WH}${ms}ms${RST}"
        elif echo "$line" | grep -q "statistics\|transmitted\|rtt"; then
            echo -e "    ${T_INFO}$line${RST}"
        fi
    done

    draw_line "━" 50 "${T_BORDER}"
    go_back network_menu
}

net_port_scan() {
    sub_banner "🔌 ADVANCED PORT SCANNER"
    echo -ne "    ${T_WARNING}Target host/IP: ${T_SUCCESS}"
    read target
    echo -e ""
    echo -e "    ${T_INFO}Scan Mode:${RST}"
    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Quick Scan (Top 100 ports)${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}Full Scan (1-1024)${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Custom Range${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Specific Ports${RST}"
    echo -ne "    ${T_WARNING}Mode: ${T_SUCCESS}"
    read scan_mode
    echo -e "${RST}"

    [ -z "$target" ] && { echo -e "    ${T_ERROR}[✗] Target kosong!${RST}"; sleep 1; network_menu; return; }

    local ports_to_scan=()
    case $scan_mode in
        1) ports_to_scan=(21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1723 3306 3389 5900 8080 8443) ;;
        2) for ((p=1; p<=1024; p++)); do ports_to_scan+=($p); done ;;
        3)
            echo -ne "    ${T_WARNING}Start port: ${T_SUCCESS}"; read ps
            echo -ne "    ${T_WARNING}End port: ${T_SUCCESS}"; read pe
            echo -e "${RST}"
            ps=${ps:-1}; pe=${pe:-1024}
            for ((p=ps; p<=pe; p++)); do ports_to_scan+=($p); done
            ;;
        4)
            echo -ne "    ${T_WARNING}Ports (comma-separated): ${T_SUCCESS}"
            read custom_ports
            echo -e "${RST}"
            IFS=',' read -ra ports_to_scan <<< "$custom_ports"
            ;;
        *) ports_to_scan=(21 22 23 25 53 80 110 143 443 445 3306 3389 8080) ;;
    esac

    local total=${#ports_to_scan[@]}
    echo ""
    draw_box 52 "SCAN RESULTS — $target"
    draw_box_empty 52
    draw_box_line 52 "  ${T_MUTED}Total ports to scan: ${T_INFO}$total${RST}"
    draw_box_line 52 "  ${T_MUTED}Scan started: ${T_INFO}$(date '+%H:%M:%S')${RST}"
    draw_box_separator 52
    draw_box_line 52 "  ${T_WARNING}PORT       STATE      SERVICE${RST}"
    draw_box_separator 52

    # Well-known ports
    declare -A port_services
    port_services=([21]="FTP" [22]="SSH" [23]="Telnet" [25]="SMTP" [53]="DNS"
                   [80]="HTTP" [110]="POP3" [111]="RPC" [135]="MSRPC" [139]="NetBIOS"
                   [143]="IMAP" [443]="HTTPS" [445]="SMB" [993]="IMAPS" [995]="POP3S"
                   [1723]="PPTP" [3306]="MySQL" [3389]="RDP" [5432]="PostgreSQL"
                   [5900]="VNC" [6379]="Redis" [8080]="HTTP-ALT" [8443]="HTTPS-ALT"
                   [27017]="MongoDB" [6667]="IRC" [1433]="MSSQL" [9200]="Elastic")

    local open_count=0
    local closed_count=0
    local scanned=0

    for port in "${ports_to_scan[@]}"; do
        ((scanned++))
        local service="${port_services[$port]:-unknown}"

        if (echo >/dev/tcp/$target/$port) &>/dev/null; then
            draw_box_line 52 "  ${T_SUCCESS}✓ ${WH}${port}$(printf '%*s' $((10 - ${#port})) '')${T_SUCCESS}OPEN${RST}$(printf '%*s' 7 '')${T_INFO}${service}${RST}"
            ((open_count++))
        fi
        ((closed_count++))

        # Progress indicator setiap 50 port
        if [ $((scanned % 50)) -eq 0 ]; then
            draw_box_line 52 "  ${T_MUTED}... scanned ${scanned}/${total} ports ...${RST}"
        fi
    done

    draw_box_separator 52
    draw_box_line 52 "  ${T_INFO}Scan finished: ${WH}$(date '+%H:%M:%S')${RST}"
    draw_box_line 52 "  ${T_SUCCESS}Open: ${WH}${open_count}${RST}  ${T_ERROR}Closed/Filtered: ${WH}$((total - open_count))${RST}"
    draw_box_empty 52
    draw_box_bottom 52

    go_back network_menu
}

net_dns() {
    sub_banner "🔎 DNS LOOKUP"
    echo -ne "    ${T_WARNING}Domain: ${T_SUCCESS}"
    read domain
    echo -e "${RST}"
    [ -z "$domain" ] && { echo -e "    ${T_ERROR}[✗] Domain kosong!${RST}"; sleep 1; network_menu; return; }

    spin "Querying DNS records..." 2 3

    local W=52
    draw_box $W "DNS RECORDS — $domain"
    draw_box_empty $W

    # A Record
    local a_records=$(nslookup "$domain" 2>/dev/null | grep "Address:" | tail -n +2 | awk '{print $2}')
    if [ -z "$a_records" ]; then
        a_records=$(host "$domain" 2>/dev/null | grep "has address" | awk '{print $NF}')
    fi
    draw_box_line $W "  ${T_ACCENT}A Records:${RST}"
    if [ -n "$a_records" ]; then
        while IFS= read -r rec; do
            draw_box_line $W "    ${T_SUCCESS}→ ${WH}$rec${RST}"
        done <<< "$a_records"
    else
        draw_box_line $W "    ${T_MUTED}No A records found${RST}"
    fi

    draw_box_separator $W

    # MX Record
    local mx_records=$(host -t MX "$domain" 2>/dev/null | grep "mail" | awk '{print $NF}')
    draw_box_line $W "  ${T_ACCENT}MX Records (Mail):${RST}"
    if [ -n "$mx_records" ]; then
        while IFS= read -r rec; do
            draw_box_line $W "    ${T_SUCCESS}→ ${WH}$rec${RST}"
        done <<< "$mx_records"
    else
        draw_box_line $W "    ${T_MUTED}No MX records found${RST}"
    fi

    draw_box_separator $W

    # NS Record
    local ns_records=$(host -t NS "$domain" 2>/dev/null | grep "name server" | awk '{print $NF}')
    draw_box_line $W "  ${T_ACCENT}NS Records:${RST}"
    if [ -n "$ns_records" ]; then
        while IFS= read -r rec; do
            draw_box_line $W "    ${T_SUCCESS}→ ${WH}$rec${RST}"
        done <<< "$ns_records"
    else
        draw_box_line $W "    ${T_MUTED}No NS records found${RST}"
    fi

    draw_box_separator $W

    # TXT Record
    local txt_records=$(host -t TXT "$domain" 2>/dev/null | grep "descriptive" | head -3)
    draw_box_line $W "  ${T_ACCENT}TXT Records:${RST}"
    if [ -n "$txt_records" ]; then
        while IFS= read -r rec; do
            local short=$(echo "$rec" | cut -c1-44)
            draw_box_line $W "    ${T_SUCCESS}→ ${WH}${short}${RST}"
        done <<< "$txt_records"
    else
        draw_box_line $W "    ${T_MUTED}No TXT records found${RST}"
    fi

    draw_box_empty $W
    draw_box_bottom $W

    go_back network_menu
}

net_whois() {
    sub_banner "📋 WHOIS LOOKUP"
    echo -ne "    ${T_WARNING}Domain/IP: ${T_SUCCESS}"
    read target
    echo -e "${RST}"
    [ -z "$target" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; network_menu; return; }

    spin "Querying WHOIS database..." 2 8

    local W=52
    draw_box $W "WHOIS — $target"
    draw_box_empty $W

    whois "$target" 2>/dev/null | grep -iE "domain name|registrar|creation|expir|updated|name server|registrant|status|org" | head -20 | while IFS= read -r line; do
        local key=$(echo "$line" | cut -d: -f1 | xargs)
        local val=$(echo "$line" | cut -d: -f2- | xargs)
        draw_box_line $W "  ${T_WARNING}${key}${RST}"
        draw_box_line $W "    ${T_SUCCESS}→ ${WH}${val:0:36}${RST}"
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back network_menu
}

net_traceroute() {
    sub_banner "🗺️ TRACEROUTE"
    echo -ne "    ${T_WARNING}Target: ${T_SUCCESS}"
    read target
    echo -e "${RST}"
    [ -z "$target" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; network_menu; return; }

    spin "Tracing route to $target..." 1 7

    echo ""
    draw_line "━" 55 "${T_BORDER}"
    echo -e "    ${T_ACCENT}HOP  ${T_WARNING}HOST / IP                    ${T_INFO}TIME${RST}"
    draw_line "━" 55 "${T_BORDER}"

    traceroute -m 20 "$target" 2>/dev/null | tail -n +2 | while IFS= read -r line; do
        local hop=$(echo "$line" | awk '{print $1}')
        local host_ip=$(echo "$line" | awk '{print $2, $3}')
        local time_ms=$(echo "$line" | grep -o '[0-9.]* ms' | head -1)
        printf "    ${T_SUCCESS}%-4s ${WH}%-35s ${T_INFO}%s${RST}\n" "$hop" "${host_ip:0:35}" "$time_ms"
    done || echo -e "    ${T_WARNING}[!] traceroute not found. Install: pkg install traceroute${RST}"

    draw_line "━" 55 "${T_BORDER}"
    go_back network_menu
}

net_http_header() {
    sub_banner "📨 HTTP HEADER GRABBER"
    echo -ne "    ${T_WARNING}URL (e.g. google.com): ${T_SUCCESS}"
    read url
    echo -e "${RST}"
    [ -z "$url" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; network_menu; return; }
    [[ "$url" != http* ]] && url="https://$url"

    spin "Grabbing HTTP headers..." 2 2

    local W=52
    draw_box $W "HTTP HEADERS"
    draw_box_empty $W

    curl -sI --max-time 10 "$url" 2>/dev/null | while IFS= read -r line; do
        line=$(echo "$line" | tr -d '\r')
        [ -z "$line" ] && continue
        if echo "$line" | grep -q "^HTTP"; then
            draw_box_line $W "  ${T_SUCCESS}${BLD}$line${RST}"
        else
            local key=$(echo "$line" | cut -d: -f1)
            local val=$(echo "$line" | cut -d: -f2- | xargs)
            draw_box_line $W "  ${T_WARNING}${key}${T_MUTED}: ${T_INFO}${val:0:30}${RST}"
        fi
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back network_menu
}

net_interface() {
    sub_banner "📶 NETWORK INTERFACE INFO"
    spin "Scanning interfaces..." 1 3

    local W=52
    draw_box $W "NETWORK INTERFACES"
    draw_box_empty $W

    ip -brief addr show 2>/dev/null | while IFS= read -r line; do
        local iface=$(echo "$line" | awk '{print $1}')
        local state=$(echo "$line" | awk '{print $2}')
        local addr=$(echo "$line" | awk '{print $3}')

        local state_color="${T_ERROR}"
        [ "$state" = "UP" ] && state_color="${T_SUCCESS}"

        draw_box_line $W "  ${T_PRIMARY}${BLD}${iface}${RST}"
        draw_box_line $W "    ${T_MUTED}State : ${state_color}${state}${RST}"
        draw_box_line $W "    ${T_MUTED}Addr  : ${T_INFO}${addr:-N/A}${RST}"
        draw_box_line $W ""
    done

    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}Default Gateway:${RST}"
    local gw=$(ip route | grep default | awk '{print $3}' | head -1)
    draw_box_line $W "    ${T_SUCCESS}→ ${WH}${gw:-N/A}${RST}"

    draw_box_empty $W
    draw_box_bottom $W
    go_back network_menu
}

net_subnet_calc() {
    sub_banner "🔗 SUBNET CALCULATOR"
    echo -ne "    ${T_WARNING}IP Address (e.g. 192.168.1.0): ${T_SUCCESS}"
    read ip_addr
    echo -ne "    ${T_WARNING}CIDR (e.g. 24): ${T_SUCCESS}"
    read cidr
    echo -e "${RST}"

    ip_addr=${ip_addr:-192.168.1.0}
    cidr=${cidr:-24}

    local hosts=$((2 ** (32 - cidr) - 2))
    local total=$((2 ** (32 - cidr)))

    # Calculate netmask
    local mask=""
    local bits=$cidr
    for ((i=0; i<4; i++)); do
        if [ $bits -ge 8 ]; then
            mask+="255"
            bits=$((bits - 8))
        elif [ $bits -gt 0 ]; then
            mask+="$((256 - 2 ** (8 - bits)))"
            bits=0
        else
            mask+="0"
        fi
        [ $i -lt 3 ] && mask+="."
    done

    local W=52
    draw_box $W "SUBNET CALCULATION"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Network     ${T_MUTED}: ${T_SUCCESS}${ip_addr}/${cidr}${RST}"
    draw_box_line $W "  ${T_WARNING}Netmask     ${T_MUTED}: ${T_SUCCESS}${mask}${RST}"
    draw_box_line $W "  ${T_WARNING}CIDR        ${T_MUTED}: ${T_SUCCESS}/${cidr}${RST}"
    draw_box_line $W "  ${T_WARNING}Total IPs   ${T_MUTED}: ${T_SUCCESS}${total}${RST}"
    draw_box_line $W "  ${T_WARNING}Usable Hosts${T_MUTED}: ${T_SUCCESS}${hosts}${RST}"
    draw_box_line $W "  ${T_WARNING}Wildcard    ${T_MUTED}: ${T_SUCCESS}$(echo "$mask" | awk -F. '{printf "%d.%d.%d.%d", 255-$1, 255-$2, 255-$3, 255-$4}')${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back network_menu
}

net_speed_test() {
    sub_banner "📊 BANDWIDTH SPEED TEST"
    echo -e "    ${T_INFO}Testing download speed using curl...${RST}"
    echo ""

    spin "Connecting to test server..." 1 6

    local start_time=$(date +%s%N 2>/dev/null || date +%s)
    local bytes=$(curl -s --max-time 10 -o /dev/null -w '%{size_download}' "http://speedtest.tele2.net/1MB.zip" 2>/dev/null)
    local end_time=$(date +%s%N 2>/dev/null || date +%s)

    if [ -n "$bytes" ] && [ "$bytes" -gt 0 ] 2>/dev/null; then
        local duration=$(echo "scale=2; ($end_time - $start_time) / 1000000000" | bc 2>/dev/null || echo "10")
        local speed_bps=$(echo "scale=2; $bytes * 8 / $duration" | bc 2>/dev/null || echo "0")
        local speed_mbps=$(echo "scale=2; $speed_bps / 1000000" | bc 2>/dev/null || echo "0")
        local speed_kbps=$(echo "scale=2; $speed_bps / 1000" | bc 2>/dev/null || echo "0")

        local W=52
        draw_box $W "SPEED TEST RESULTS"
        draw_box_empty $W
        draw_box_line $W "  ${T_WARNING}Downloaded  ${T_MUTED}: ${T_SUCCESS}${bytes} bytes${RST}"
        draw_box_line $W "  ${T_WARNING}Duration    ${T_MUTED}: ${T_SUCCESS}${duration}s${RST}"
        draw_box_line $W "  ${T_WARNING}Speed       ${T_MUTED}: ${T_PRIMARY}${BLD}${speed_mbps} Mbps${RST}"
        draw_box_line $W "  ${T_WARNING}             ${T_MUTED}: ${T_INFO}${speed_kbps} Kbps${RST}"
        draw_box_empty $W

        # Speed bar
        local bar_val=$(echo "$speed_mbps" | cut -d. -f1)
        [ -z "$bar_val" ] && bar_val=0
        [ "$bar_val" -gt 30 ] && bar_val=30
        echo -ne "    ${T_BORDER}║${RST}  "
        for ((b=0; b<bar_val; b++)); do
            if [ $b -lt 5 ]; then echo -ne "\033[38;5;196m█"
            elif [ $b -lt 15 ]; then echo -ne "\033[38;5;226m█"
            else echo -ne "\033[38;5;46m█"
            fi
        done
        echo -e "${RST}"

        draw_box_empty $W
        draw_box_bottom $W
    else
        echo -e "    ${T_ERROR}[✗] Speed test failed. Check connection.${RST}"
    fi

    go_back network_menu
}

net_arp_scan() {
    sub_banner "🛰️ ARP SCAN — LOCAL NETWORK"
    spin "Scanning local network..." 2 3

    local gw=$(ip route | grep default | awk '{print $3}' | head -1)
    local subnet=$(echo "$gw" | sed 's/\.[0-9]*$/.0\/24/')

    local W=52
    draw_box $W "DEVICES ON NETWORK"
    draw_box_line $W "  ${T_MUTED}Gateway: ${T_SUCCESS}${gw}${RST}  ${T_MUTED}Subnet: ${T_INFO}${subnet}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}IP ADDRESS         MAC ADDRESS${RST}"
    draw_box_separator $W

    # Ping sweep
    local base=$(echo "$gw" | sed 's/\.[0-9]*$//')
    local found=0
    for i in $(seq 1 254); do
        ping -c 1 -W 1 "${base}.${i}" &>/dev/null &
    done
    wait 2>/dev/null

    arp -a 2>/dev/null | grep -v "incomplete" | while IFS= read -r line; do
        local ip=$(echo "$line" | grep -oP '\(\K[^\)]+')
        local mac=$(echo "$line" | grep -oP '([0-9a-f]{2}:){5}[0-9a-f]{2}')
        if [ -n "$ip" ] && [ -n "$mac" ]; then
            draw_box_line $W "  ${T_SUCCESS}● ${WH}${ip}$(printf '%*s' $((18 - ${#ip})) '')${T_INFO}${mac}${RST}"
            ((found++))
        fi
    done

    # Fallback: ip neigh
    ip neigh 2>/dev/null | grep -v "FAILED" | while IFS= read -r line; do
        local ip=$(echo "$line" | awk '{print $1}')
        local mac=$(echo "$line" | grep -oP '([0-9a-f]{2}:){5}[0-9a-f]{2}')
        local state=$(echo "$line" | awk '{print $NF}')
        if [ -n "$mac" ]; then
            draw_box_line $W "  ${T_SUCCESS}● ${WH}${ip}$(printf '%*s' $((18 - ${#ip})) '')${T_INFO}${mac}${RST}"
        fi
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back network_menu
}

net_ssl_info() {
    sub_banner "🌐 SSL/TLS CERTIFICATE INFO"
    echo -ne "    ${T_WARNING}Domain (e.g. google.com): ${T_SUCCESS}"
    read domain
    echo -e "${RST}"
    [ -z "$domain" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; network_menu; return; }

    spin "Fetching SSL certificate..." 2 2

    local cert_info=$(echo | openssl s_client -servername "$domain" -connect "${domain}:443" 2>/dev/null | openssl x509 -noout -text 2>/dev/null)

    local issuer=$(echo "$cert_info" | grep "Issuer:" | head -1 | sed 's/.*Issuer: //')
    local subject=$(echo "$cert_info" | grep "Subject:" | head -1 | sed 's/.*Subject: //')
    local not_before=$(echo "$cert_info" | grep "Not Before" | sed 's/.*Not Before: //')
    local not_after=$(echo "$cert_info" | grep "Not After" | sed 's/.*Not After *: //')
    local serial=$(echo "$cert_info" | grep "Serial Number" -A1 | tail -1 | xargs)
    local sig_algo=$(echo "$cert_info" | grep "Signature Algorithm" | head -1 | sed 's/.*: //')
    local key_size=$(echo "$cert_info" | grep "Public-Key" | grep -o '[0-9]* bit')
    local san=$(echo "$cert_info" | grep "DNS:" | xargs | head -1)

    local W=52
    draw_box $W "SSL CERTIFICATE — $domain"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Subject    ${T_MUTED}: ${T_SUCCESS}${subject:0:35}${RST}"
    draw_box_line $W "  ${T_WARNING}Issuer     ${T_MUTED}: ${T_INFO}${issuer:0:35}${RST}"
    draw_box_line $W "  ${T_WARNING}Valid From ${T_MUTED}: ${T_SUCCESS}${not_before}${RST}"
    draw_box_line $W "  ${T_WARNING}Valid To   ${T_MUTED}: ${T_ACCENT}${not_after}${RST}"
    draw_box_line $W "  ${T_WARNING}Key Size   ${T_MUTED}: ${T_INFO}${key_size:-N/A}${RST}"
    draw_box_line $W "  ${T_WARNING}Signature  ${T_MUTED}: ${T_INFO}${sig_algo:0:35}${RST}"
    draw_box_line $W "  ${T_WARNING}Serial     ${T_MUTED}: ${T_MUTED}${serial:0:35}${RST}"

    if [ -n "$san" ]; then
        draw_box_separator $W
        draw_box_line $W "  ${T_ACCENT}SANs:${RST}"
        echo "$san" | tr ',' '\n' | head -5 | while IFS= read -r s; do
            draw_box_line $W "    ${T_SUCCESS}→ ${WH}$(echo "$s" | xargs | head -c 38)${RST}"
        done
    fi

    draw_box_empty $W
    draw_box_bottom $W
    go_back network_menu
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 02: INFORMATION GATHERING (OSINT)
# ═══════════════════════════════════════════════════════════════

info_gathering_menu() {
    sub_banner "🔍 INFORMATION GATHERING — OSINT"

    local W=52
    draw_box $W "OSINT TOOLS"
    draw_box_empty $W
    menu_item "01" "📍" "IP Geolocation Tracker"    $W
    menu_item "02" "📱" "Phone Number OSINT"         $W
    menu_item "03" "🔗" "Subdomain Finder"           $W
    menu_item "04" "🔧" "Website Technology Detect"  $W
    menu_item "05" "📧" "Email Validator"             $W
    menu_item "06" "👤" "Username Checker"            $W
    menu_item "07" "🌐" "Website Status Checker"     $W
    menu_item "08" "📸" "Website Screenshot (URL)"   $W
    menu_item "09" "🔑" "Reverse IP Lookup"          $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"       $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1) osint_ip_geo ;;
        02|2) osint_phone ;;
        03|3) osint_subdomain ;;
        04|4) osint_webtech ;;
        05|5) osint_email_validate ;;
        06|6) osint_username ;;
        07|7) osint_website_status ;;
        08|8) osint_screenshot ;;
        09|9) osint_reverse_ip ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; info_gathering_menu ;;
    esac
}

osint_ip_geo() {
    sub_banner "📍 IP GEOLOCATION TRACKER"
    echo -ne "    ${T_WARNING}IP Address: ${T_SUCCESS}"
    read ip
    echo -e "${RST}"
    [ -z "$ip" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    spin "Tracking IP geolocation..." 2 6

    local geo=$(curl -s --max-time 5 "http://ip-api.com/json/$ip?fields=66846719" 2>/dev/null)

    local fields=("country" "regionName" "city" "zip" "lat" "lon" "timezone" "isp" "org" "as" "mobile" "proxy" "hosting")
    local icons=("🏳️" "📍" "🏙️" "📮" "📐" "📐" "⏰" "📡" "🏢" "🔢" "📱" "🔒" "💻")

    local W=52
    draw_box $W "GEOLOCATION — $ip"
    draw_box_empty $W

    for ((i=0; i<${#fields[@]}; i++)); do
        local value=$(echo "$geo" | grep -o "\"${fields[$i]}\":\"[^\"]*\"" | cut -d'"' -f4)
        [ -z "$value" ] && value=$(echo "$geo" | grep -o "\"${fields[$i]}\":[^,}]*" | cut -d: -f2 | tr -d '"')
        local fname=$(printf "%-12s" "${fields[$i]^}")
        draw_box_line $W "  ${icons[$i]} ${T_WARNING}${fname}${T_MUTED}: ${T_SUCCESS}${value:-N/A}${RST}"
    done

    draw_box_empty $W
    draw_box_bottom $W

    local lat=$(echo "$geo" | grep -o '"lat":[0-9.-]*' | cut -d: -f2)
    local lon=$(echo "$geo" | grep -o '"lon":[0-9.-]*' | cut -d: -f2)
    [ -n "$lat" ] && echo -e "    ${T_MUTED}🗺️  Maps: ${T_INFO}https://maps.google.com/?q=${lat},${lon}${RST}"

    go_back info_gathering_menu
}

osint_phone() {
    sub_banner "📱 PHONE NUMBER OSINT"
    echo -ne "    ${T_WARNING}Phone Number (with country code, e.g. +62812xxx): ${T_SUCCESS}"
    read phone
    echo -e "${RST}"
    [ -z "$phone" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    spin "Analyzing phone number..." 2 8

    # Country code detection
    declare -A cc_map
    cc_map=(["+62"]="Indonesia" ["+1"]="United States" ["+60"]="Malaysia" ["+65"]="Singapore"
            ["+44"]="United Kingdom" ["+81"]="Japan" ["+82"]="South Korea" ["+86"]="China"
            ["+91"]="India" ["+61"]="Australia" ["+33"]="France" ["+49"]="Germany"
            ["+7"]="Russia" ["+55"]="Brazil" ["+66"]="Thailand" ["+63"]="Philippines"
            ["+84"]="Vietnam" ["+880"]="Bangladesh" ["+92"]="Pakistan" ["+234"]="Nigeria")

    # Indonesian carriers
    declare -A indo_carrier
    indo_carrier=(["+6281"]="Telkomsel" ["+6282"]="Telkomsel" ["+6285"]="Indosat"
                  ["+6283"]="Axis" ["+6287"]="XL Axiata" ["+6289"]="Tri (3)"
                  ["+6288"]="Smartfren" ["+6278"]="Smartfren" ["+6281"]="Telkomsel")

    local country="Unknown"
    local carrier="Unknown"
    local number_type="Mobile"
    local clean_phone=$(echo "$phone" | tr -d ' -')

    for code in "${!cc_map[@]}"; do
        if [[ "$clean_phone" == ${code}* ]]; then
            country="${cc_map[$code]}"
            break
        fi
    done

    for prefix in "${!indo_carrier[@]}"; do
        if [[ "$clean_phone" == ${prefix}* ]]; then
            carrier="${indo_carrier[$prefix]}"
            break
        fi
    done

    local digits_only=$(echo "$clean_phone" | tr -dc '0-9')
    local num_length=${#digits_only}

    local W=52
    draw_box $W "PHONE NUMBER INTELLIGENCE"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Number       ${T_MUTED}: ${T_SUCCESS}${phone}${RST}"
    draw_box_line $W "  ${T_WARNING}Cleaned      ${T_MUTED}: ${T_SUCCESS}${clean_phone}${RST}"
    draw_box_line $W "  ${T_WARNING}Length       ${T_MUTED}: ${T_SUCCESS}${num_length} digits${RST}"
    draw_box_line $W "  ${T_WARNING}Country      ${T_MUTED}: ${T_INFO}${country}${RST}"
    draw_box_line $W "  ${T_WARNING}Carrier      ${T_MUTED}: ${T_INFO}${carrier}${RST}"
    draw_box_line $W "  ${T_WARNING}Type         ${T_MUTED}: ${T_INFO}${number_type}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}Format Variations:${RST}"
    draw_box_line $W "    ${T_SUCCESS}International : ${WH}${clean_phone}${RST}"
    draw_box_line $W "    ${T_SUCCESS}Local (0...)   : ${WH}0${clean_phone:3}${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back info_gathering_menu
}

osint_subdomain() {
    sub_banner "🔗 SUBDOMAIN FINDER"
    echo -ne "    ${T_WARNING}Domain (e.g. example.com): ${T_SUCCESS}"
    read domain
    echo -e "${RST}"
    [ -z "$domain" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    premium_bar "Scanning subdomains" 2

    local subs=("www" "mail" "ftp" "admin" "blog" "dev" "api" "staging" "test"
                "portal" "shop" "store" "app" "m" "mobile" "cdn" "ns1" "ns2"
                "smtp" "pop" "imap" "vpn" "remote" "secure" "static" "media"
                "img" "images" "video" "docs" "wiki" "forum" "support" "help"
                "status" "monitor" "dashboard" "panel" "cp" "webmail" "cloud"
                "git" "svn" "jenkins" "ci" "staging" "uat" "demo" "beta"
                "old" "new" "v2" "api2" "dev2" "db" "database" "sql" "redis"
                "elastic" "search" "analytics" "track" "sso" "auth" "login"
                "register" "signup" "pay" "payment" "billing" "invoice")

    local W=52
    draw_box $W "SUBDOMAINS — $domain"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}SUBDOMAIN$(printf '%*s' 20 '')STATUS   IP${RST}"
    draw_box_separator $W

    local found=0
    for sub in "${subs[@]}"; do
        local result=$(host "$sub.$domain" 2>/dev/null | grep "has address" | head -1)
        if [ -n "$result" ]; then
            local ip=$(echo "$result" | awk '{print $NF}')
            draw_box_line $W "  ${T_SUCCESS}✓ ${WH}${sub}.${domain}${RST}"
            draw_box_line $W "    ${T_MUTED}→ ${T_INFO}${ip}${RST}"
            ((found++))
        fi
    done

    draw_box_separator $W
    draw_box_line $W "  ${T_INFO}Total found: ${WH}${found}${RST} ${T_MUTED}/ ${#subs[@]} tested${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back info_gathering_menu
}

osint_webtech() {
    sub_banner "🔧 WEBSITE TECHNOLOGY DETECTOR"
    echo -ne "    ${T_WARNING}URL: ${T_SUCCESS}"
    read url
    echo -e "${RST}"
    [ -z "$url" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }
    [[ "$url" != http* ]] && url="https://$url"

    spin "Analyzing website technology..." 2 8

    local headers=$(curl -sI --max-time 10 "$url" 2>/dev/null)
    local body=$(curl -s --max-time 10 "$url" 2>/dev/null | head -200)

    local W=52
    draw_box $W "TECH STACK — $url"
    draw_box_empty $W

    # Server
    local server=$(echo "$headers" | grep -i "^server:" | cut -d: -f2- | xargs)
    [ -n "$server" ] && draw_box_line $W "  🖥️  ${T_WARNING}Server     ${T_MUTED}: ${T_SUCCESS}${server}${RST}"

    # Powered By
    local powered=$(echo "$headers" | grep -i "^x-powered-by:" | cut -d: -f2- | xargs)
    [ -n "$powered" ] && draw_box_line $W "  ⚡ ${T_WARNING}Powered By ${T_MUTED}: ${T_SUCCESS}${powered}${RST}"

    # CMS Detection
    echo "$body" | grep -qi "wp-content\|wordpress" && draw_box_line $W "  📝 ${T_WARNING}CMS        ${T_MUTED}: ${T_SUCCESS}WordPress${RST}"
    echo "$body" | grep -qi "joomla" && draw_box_line $W "  📝 ${T_WARNING}CMS        ${T_MUTED}: ${T_SUCCESS}Joomla${RST}"
    echo "$body" | grep -qi "drupal" && draw_box_line $W "  📝 ${T_WARNING}CMS        ${T_MUTED}: ${T_SUCCESS}Drupal${RST}"
    echo "$body" | grep -qi "shopify" && draw_box_line $W "  🛒 ${T_WARNING}Platform   ${T_MUTED}: ${T_SUCCESS}Shopify${RST}"

    # Frameworks
    echo "$body" | grep -qi "react\|__NEXT" && draw_box_line $W "  ⚛️  ${T_WARNING}Framework  ${T_MUTED}: ${T_SUCCESS}React/Next.js${RST}"
    echo "$body" | grep -qi "vue\|nuxt" && draw_box_line $W "  💚 ${T_WARNING}Framework  ${T_MUTED}: ${T_SUCCESS}Vue/Nuxt${RST}"
    echo "$body" | grep -qi "angular" && draw_box_line $W "  🅰️  ${T_WARNING}Framework  ${T_MUTED}: ${T_SUCCESS}Angular${RST}"
    echo "$body" | grep -qi "laravel" && draw_box_line $W "  🔴 ${T_WARNING}Framework  ${T_MUTED}: ${T_SUCCESS}Laravel${RST}"
    echo "$body" | grep -qi "django" && draw_box_line $W "  🐍 ${T_WARNING}Framework  ${T_MUTED}: ${T_SUCCESS}Django${RST}"
    echo "$body" | grep -qi "bootstrap" && draw_box_line $W "  🅱️  ${T_WARNING}CSS        ${T_MUTED}: ${T_SUCCESS}Bootstrap${RST}"
    echo "$body" | grep -qi "tailwind" && draw_box_line $W "  🎨 ${T_WARNING}CSS        ${T_MUTED}: ${T_SUCCESS}Tailwind CSS${RST}"
    echo "$body" | grep -qi "jquery" && draw_box_line $W "  💲 ${T_WARNING}JS Library ${T_MUTED}: ${T_SUCCESS}jQuery${RST}"

    # CDN
    echo "$headers" | grep -qi "cloudflare" && draw_box_line $W "  ☁️  ${T_WARNING}CDN        ${T_MUTED}: ${T_SUCCESS}Cloudflare${RST}"
    echo "$headers" | grep -qi "akamai" && draw_box_line $W "  ☁️  ${T_WARNING}CDN        ${T_MUTED}: ${T_SUCCESS}Akamai${RST}"
    echo "$headers" | grep -qi "fastly" && draw_box_line $W "  ☁️  ${T_WARNING}CDN        ${T_MUTED}: ${T_SUCCESS}Fastly${RST}"

    # Analytics
    echo "$body" | grep -qi "google-analytics\|gtag\|ga.js" && draw_box_line $W "  📊 ${T_WARNING}Analytics  ${T_MUTED}: ${T_SUCCESS}Google Analytics${RST}"
    echo "$body" | grep -qi "hotjar" && draw_box_line $W "  🔥 ${T_WARNING}Analytics  ${T_MUTED}: ${T_SUCCESS}Hotjar${RST}"

    draw_box_empty $W
    draw_box_bottom $W
    go_back info_gathering_menu
}

osint_email_validate() {
    sub_banner "📧 EMAIL VALIDATOR"
    echo -ne "    ${T_WARNING}Email address: ${T_SUCCESS}"
    read email
    echo -e "${RST}"
    [ -z "$email" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    spin "Validating email..." 2 3

    local domain=$(echo "$email" | cut -d@ -f2)
    local user=$(echo "$email" | cut -d@ -f1)

    local W=52
    draw_box $W "EMAIL ANALYSIS — $email"
    draw_box_empty $W

    # Format check
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        draw_box_line $W "  ${T_SUCCESS}✓ ${WH}Format valid${RST}"
    else
        draw_box_line $W "  ${T_ERROR}✗ ${WH}Format invalid${RST}"
    fi

    # MX check
    local mx=$(host -t MX "$domain" 2>/dev/null | grep "mail" | head -1)
    if [ -n "$mx" ]; then
        draw_box_line $W "  ${T_SUCCESS}✓ ${WH}MX record exists${RST}"
        draw_box_line $W "    ${T_MUTED}→ ${T_INFO}$(echo "$mx" | awk '{print $NF}')${RST}"
    else
        draw_box_line $W "  ${T_ERROR}✗ ${WH}No MX record found${RST}"
    fi

    # Domain resolves
    local domain_ip=$(host "$domain" 2>/dev/null | grep "has address" | head -1)
    if [ -n "$domain_ip" ]; then
        draw_box_line $W "  ${T_SUCCESS}✓ ${WH}Domain resolves${RST}"
    else
        draw_box_line $W "  ${T_ERROR}✗ ${WH}Domain does not resolve${RST}"
    fi

    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}Username ${T_MUTED}: ${T_INFO}${user}${RST}"
    draw_box_line $W "  ${T_WARNING}Domain   ${T_MUTED}: ${T_INFO}${domain}${RST}"

    # Known providers
    case "$domain" in
        gmail.com)     draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_SUCCESS}Google Gmail${RST}" ;;
        yahoo.com)     draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_SUCCESS}Yahoo Mail${RST}" ;;
        outlook.com|hotmail.com) draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_SUCCESS}Microsoft Outlook${RST}" ;;
        protonmail.com|proton.me) draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_SUCCESS}ProtonMail (Encrypted)${RST}" ;;
        icloud.com)    draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_SUCCESS}Apple iCloud${RST}" ;;
        *)             draw_box_line $W "  ${T_WARNING}Provider ${T_MUTED}: ${T_INFO}Custom / Unknown${RST}" ;;
    esac

    draw_box_empty $W
    draw_box_bottom $W
    go_back info_gathering_menu
}

osint_username() {
    sub_banner "👤 USERNAME CHECKER"
    echo -ne "    ${T_WARNING}Username to check: ${T_SUCCESS}"
    read username
    echo -e "${RST}"
    [ -z "$username" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    premium_bar "Checking username across platforms" 3

    declare -A platforms
    platforms=(
        ["GitHub"]="https://github.com/${username}"
        ["Twitter/X"]="https://x.com/${username}"
        ["Instagram"]="https://instagram.com/${username}"
        ["TikTok"]="https://tiktok.com/@${username}"
        ["Reddit"]="https://reddit.com/user/${username}"
        ["YouTube"]="https://youtube.com/@${username}"
        ["LinkedIn"]="https://linkedin.com/in/${username}"
        ["Pinterest"]="https://pinterest.com/${username}"
        ["Medium"]="https://medium.com/@${username}"
        ["Twitch"]="https://twitch.tv/${username}"
        ["GitLab"]="https://gitlab.com/${username}"
        ["Telegram"]="https://t.me/${username}"
        ["Spotify"]="https://open.spotify.com/user/${username}"
        ["SoundCloud"]="https://soundcloud.com/${username}"
    )

    local W=52
    draw_box $W "USERNAME — @${username}"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}PLATFORM$(printf '%*s' 14 '')STATUS       URL${RST}"
    draw_box_separator $W

    for platform in "${!platforms[@]}"; do
        local url="${platforms[$platform]}"
        local status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null)

        if [ "$status_code" = "200" ]; then
            draw_box_line $W "  ${T_SUCCESS}✓ ${WH}${platform}$(printf '%*s' $((14 - ${#platform})) '')${T_SUCCESS}FOUND${RST}"
        elif [ "$status_code" = "404" ]; then
            draw_box_line $W "  ${T_ERROR}✗ ${T_MUTED}${platform}$(printf '%*s' $((14 - ${#platform})) '')${T_MUTED}NOT FOUND${RST}"
        else
            draw_box_line $W "  ${T_WARNING}? ${T_MUTED}${platform}$(printf '%*s' $((14 - ${#platform})) '')${T_WARNING}${status_code}${RST}"
        fi
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back info_gathering_menu
}

osint_website_status() {
    sub_banner "🌐 WEBSITE STATUS CHECKER"
    echo -ne "    ${T_WARNING}Enter URLs (comma-separated): ${T_SUCCESS}"
    read urls_input
    echo -e "${RST}"
    [ -z "$urls_input" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    spin "Checking website status..." 2 4

    local W=52
    draw_box $W "WEBSITE STATUS"
    draw_box_empty $W

    IFS=',' read -ra urls <<< "$urls_input"
    for url in "${urls[@]}"; do
        url=$(echo "$url" | xargs)
        [[ "$url" != http* ]] && url="https://$url"

        local status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 8 "$url" 2>/dev/null)
        local time_total=$(curl -s -o /dev/null -w "%{time_total}" --max-time 8 "$url" 2>/dev/null)

        local status_text="" status_color=""
        case $status in
            200) status_text="UP ✓"; status_color="${T_SUCCESS}" ;;
            301|302) status_text="REDIRECT"; status_color="${T_WARNING}" ;;
            403) status_text="FORBIDDEN"; status_color="${T_ERROR}" ;;
            404) status_text="NOT FOUND"; status_color="${T_ERROR}" ;;
            500) status_text="SERVER ERR"; status_color="${T_ERROR}" ;;
            000) status_text="TIMEOUT"; status_color="${T_ERROR}" ;;
            *) status_text="HTTP $status"; status_color="${T_WARNING}" ;;
        esac

        draw_box_line $W "  ${status_color}● ${WH}${url:0:30}${RST}"
        draw_box_line $W "    ${T_MUTED}Status: ${status_color}${status_text}${RST} ${T_MUTED}| Time: ${T_INFO}${time_total}s${RST}"
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back info_gathering_menu
}

osint_screenshot() {
    sub_banner "📸 WEBSITE SCREENSHOT"
    echo -ne "    ${T_WARNING}URL: ${T_SUCCESS}"
    read url
    echo -e "${RST}"
    [ -z "$url" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }
    [[ "$url" != http* ]] && url="https://$url"

    local encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$url', safe=''))" 2>/dev/null || echo "$url")
    local screenshot_url="https://image.thum.io/get/width/1280/crop/720/${url}"
    local api_url="https://api.screenshotmachine.com?key=guest&url=${encoded}&dimension=1024x768"

    echo ""
    echo -e "    ${T_INFO}📸 Screenshot Links:${RST}"
    echo ""
    echo -e "    ${T_SUCCESS}1. ${WH}${screenshot_url}${RST}"
    echo -e "    ${T_SUCCESS}2. ${WH}${api_url}${RST}"
    echo ""
    echo -e "    ${T_MUTED}Open these links in your browser to view screenshots${RST}"

    # Try to download
    echo ""
    echo -ne "    ${T_WARNING}Download screenshot? [y/n]: ${T_SUCCESS}"
    read dl
    echo -e "${RST}"
    if [[ "$dl" =~ ^[Yy]$ ]]; then
        local filename="screenshot_$(date +%s).jpg"
        spin "Downloading screenshot..." 3 6
        wget -q -O "$HOME/$filename" "$screenshot_url" 2>/dev/null && {
            echo -e "    $(badge_ok) Saved to: ${WH}$HOME/$filename${RST}"
        } || {
            echo -e "    ${T_ERROR}[✗] Download failed${RST}"
        }
    fi

    go_back info_gathering_menu
}

osint_reverse_ip() {
    sub_banner "🔑 REVERSE IP LOOKUP"
    echo -ne "    ${T_WARNING}IP Address: ${T_SUCCESS}"
    read ip
    echo -e "${RST}"
    [ -z "$ip" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; info_gathering_menu; return; }

    spin "Performing reverse lookup..." 2 3

    local W=52
    draw_box $W "REVERSE IP — $ip"
    draw_box_empty $W

    local reverse=$(host "$ip" 2>/dev/null | grep "pointer" | awk '{print $NF}')
    if [ -n "$reverse" ]; then
        draw_box_line $W "  ${T_SUCCESS}✓ ${WH}PTR Record found:${RST}"
        while IFS= read -r ptr; do
            draw_box_line $W "    ${T_INFO}→ ${WH}${ptr}${RST}"
        done <<< "$reverse"
    else
        draw_box_line $W "  ${T_WARNING}No PTR record found${RST}"
    fi

    draw_box_empty $W
    draw_box_bottom $W
    go_back info_gathering_menu
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 03: SECURITY & EXPLOIT TOOLS
# ═══════════════════════════════════════════════════════════════

security_menu() {
    sub_banner "🛡️ SECURITY & EXPLOIT TOOLS"

    local W=52
    draw_box $W "SECURITY ARSENAL"
    draw_box_empty $W
    menu_item "01" "🔐" "Password Generator Pro"     $W
    menu_item "02" "💪" "Password Strength Analyzer"  $W
    menu_item "03" "🔑" "Hash Generator (Multi)"      $W
    menu_item "04" "🔎" "Hash Identifier & Cracker"   $W
    menu_item "05" "🔒" "File Encryptor (AES-256)"    $W
    menu_item "06" "🔓" "File Decryptor"              $W
    menu_item "07" "📜" "JWT Token Decoder"           $W
    menu_item "08" "🛡️" " Vulnerability Header Check" $W
    menu_item "09" "🎲" "Random Data Generator"       $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"        $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1) sec_passgen ;;
        02|2) sec_passcheck ;;
        03|3) sec_hashgen ;;
        04|4) sec_hashid ;;
        05|5) sec_encrypt ;;
        06|6) sec_decrypt ;;
        07|7) sec_jwt ;;
        08|8) sec_vuln_headers ;;
        09|9) sec_random ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; security_menu ;;
    esac
}

sec_passgen() {
    sub_banner "🔐 PASSWORD GENERATOR PRO"
    echo -ne "    ${T_WARNING}Length (default 20): ${T_SUCCESS}"; read len
    echo -ne "    ${T_WARNING}Count (default 8): ${T_SUCCESS}"; read count
    echo -e ""
    echo -e "    ${T_INFO}Charset:${RST}"
    echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} ${T_INFO}Full (letters+digits+symbols)${RST}"
    echo -e "    ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} ${T_INFO}Alphanumeric only${RST}"
    echo -e "    ${T_SUCCESS}[${WH}3${T_SUCCESS}]${RST} ${T_INFO}Hex characters${RST}"
    echo -e "    ${T_SUCCESS}[${WH}4${T_SUCCESS}]${RST} ${T_INFO}Passphrase (words)${RST}"
    echo -ne "    ${T_WARNING}Charset: ${T_SUCCESS}"; read charset_choice
    echo -e "${RST}"

    len=${len:-20}; count=${count:-8}

    local charset='a-zA-Z0-9!@#$%^&*()_+-=[]{}|;:,.<>?'
    case $charset_choice in
        2) charset='a-zA-Z0-9' ;;
        3) charset='0-9a-f' ;;
    esac

    spin "Generating secure passwords..." 1 1

    local W=52
    draw_box $W "GENERATED PASSWORDS (len=$len)"
    draw_box_empty $W

    if [ "$charset_choice" = "4" ]; then
        local words=("alpha" "bravo" "cyber" "delta" "echo" "foxtrot" "gamma" "hawk"
                     "iron" "jade" "knight" "lunar" "matrix" "nova" "omega" "phantom"
                     "quantum" "raven" "shadow" "titan" "ultra" "viper" "wolf" "xenon"
                     "zero" "storm" "blaze" "frost" "nexus" "pulse" "forge" "drift"
                     "crypt" "vault" "blade" "spark" "ghost" "flame" "stone" "surge")
        for ((i=1; i<=count; i++)); do
            local phrase=""
            for ((w=0; w<4; w++)); do
                phrase+="${words[$((RANDOM % ${#words[@]}))]}"
                [ $w -lt 3 ] && phrase+="-"
            done
            phrase+="-$((RANDOM % 100))"
            draw_box_line $W "  ${T_SUCCESS}[${WH}$(printf '%02d' $i)${T_SUCCESS}]${RST} ${T_INFO}${phrase}${RST}"
        done
    else
        for ((i=1; i<=count; i++)); do
            local pass=$(cat /dev/urandom | tr -dc "$charset" | head -c "$len" 2>/dev/null)
            # Entropy estimation
            local entropy=$(echo "scale=0; $len * 6" | bc 2>/dev/null || echo "?")
            draw_box_line $W "  ${T_SUCCESS}[${WH}$(printf '%02d' $i)${T_SUCCESS}]${RST} ${T_INFO}${pass}${RST}"
        done
    fi

    draw_box_separator $W
    draw_box_line $W "  ${T_MUTED}Est. Entropy: ~$((len * 6)) bits${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back security_menu
}

sec_passcheck() {
    sub_banner "💪 PASSWORD STRENGTH ANALYZER"
    echo -ne "    ${T_WARNING}Enter password: ${T_SUCCESS}"
    read -s password
    echo ""
    echo -e "${RST}"

    local score=0 max=10
    local checks=()

    [ ${#password} -ge 8 ]   && { ((score+=1)); checks+=("${T_SUCCESS}✓ Length ≥ 8${RST}"); }  || checks+=("${T_ERROR}✗ Length < 8${RST}")
    [ ${#password} -ge 12 ]  && { ((score+=1)); checks+=("${T_SUCCESS}✓ Length ≥ 12${RST}"); } || checks+=("${T_WARNING}△ Length < 12${RST}")
    [ ${#password} -ge 16 ]  && { ((score+=1)); checks+=("${T_SUCCESS}✓ Length ≥ 16${RST}"); } || checks+=("${T_WARNING}△ Length < 16${RST}")
    [[ "$password" =~ [a-z] ]] && { ((score+=1)); checks+=("${T_SUCCESS}✓ Has lowercase${RST}"); } || checks+=("${T_ERROR}✗ No lowercase${RST}")
    [[ "$password" =~ [A-Z] ]] && { ((score+=1)); checks+=("${T_SUCCESS}✓ Has uppercase${RST}"); } || checks+=("${T_ERROR}✗ No uppercase${RST}")
    [[ "$password" =~ [0-9] ]] && { ((score+=1)); checks+=("${T_SUCCESS}✓ Has digits${RST}"); }    || checks+=("${T_ERROR}✗ No digits${RST}")
    [[ "$password" =~ [^a-zA-Z0-9] ]] && { ((score+=2)); checks+=("${T_SUCCESS}✓ Has symbols${RST}"); } || checks+=("${T_ERROR}✗ No symbols${RST}")

    # Common password check
    local common=("password" "123456" "qwerty" "admin" "letmein" "welcome" "monkey" "dragon")
    local is_common=false
    for cp in "${common[@]}"; do
        [[ "${password,,}" == *"$cp"* ]] && { is_common=true; break; }
    done
    $is_common && { checks+=("${T_ERROR}✗ Contains common word${RST}"); } || { ((score+=1)); checks+=("${T_SUCCESS}✓ No common patterns${RST}"); }

    # Repeated chars
    if echo "$password" | grep -qP '(.)\1{2,}'; then
        checks+=("${T_ERROR}✗ Has repeated chars${RST}")
    else
        ((score+=1)); checks+=("${T_SUCCESS}✓ No repeated chars${RST}")
    fi

    local strength="" strength_color="" bar_char=""
    if [ $score -le 3 ]; then
        strength="VERY WEAK 💀"; strength_color="${T_ERROR}"; bar_char="▓"
    elif [ $score -le 5 ]; then
        strength="WEAK 😟"; strength_color="\033[38;5;208m"; bar_char="▓"
    elif [ $score -le 7 ]; then
        strength="MODERATE 😐"; strength_color="${T_WARNING}"; bar_char="█"
    elif [ $score -le 9 ]; then
        strength="STRONG 💪"; strength_color="${T_SUCCESS}"; bar_char="█"
    else
        strength="VERY STRONG 🔥"; strength_color="\033[38;5;46m"; bar_char="█"
    fi

    local W=52
    draw_box $W "PASSWORD ANALYSIS"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Length   ${T_MUTED}: ${T_INFO}${#password} characters${RST}"
    draw_box_line $W "  ${T_WARNING}Score    ${T_MUTED}: ${strength_color}${score}/${max}${RST}"
    draw_box_line $W "  ${T_WARNING}Strength ${T_MUTED}: ${strength_color}${strength}${RST}"
    draw_box_empty $W

    # Strength bar
    echo -ne "    ${T_BORDER}║${RST}  ${T_MUTED}["
    local bar_len=$((score * 3))
    for ((b=0; b<bar_len; b++)); do echo -ne "${strength_color}${bar_char}"; done
    for ((b=bar_len; b<30; b++)); do echo -ne "${T_MUTED}░"; done
    echo -e "${T_MUTED}]${RST}"

    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}Analysis:${RST}"
    for check in "${checks[@]}"; do
        draw_box_line $W "  $check"
    done

    draw_box_empty $W
    draw_box_bottom $W
    go_back security_menu
}

sec_hashgen() {
    sub_banner "🔑 HASH GENERATOR"
    echo -ne "    ${T_WARNING}Text to hash: ${T_SUCCESS}"
    read text
    echo -e "${RST}"
    [ -z "$text" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; security_menu; return; }

    spin "Generating hashes..." 1 3

    local W=56
    draw_box $W "HASH RESULTS"
    draw_box_empty $W
    draw_box_line $W "  ${T_ACCENT}Input: ${WH}\"${text}\"${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}MD5${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(echo -n "$text" | md5sum | cut -d' ' -f1)${RST}"
    draw_box_line $W "  ${T_WARNING}SHA-1${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(echo -n "$text" | sha1sum | cut -d' ' -f1)${RST}"
    draw_box_line $W "  ${T_WARNING}SHA-256${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(echo -n "$text" | sha256sum | cut -d' ' -f1)${RST}"
    draw_box_line $W "  ${T_WARNING}SHA-512${RST}"
    local sha512=$(echo -n "$text" | sha512sum | cut -d' ' -f1)
    draw_box_line $W "    ${T_SUCCESS}${sha512:0:48}${RST}"
    draw_box_line $W "    ${T_SUCCESS}${sha512:48}${RST}"
    draw_box_line $W "  ${T_WARNING}BASE64${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(echo -n "$text" | base64)${RST}"
    draw_box_line $W "  ${T_WARNING}CRC32${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(echo -n "$text" | cksum | awk '{print $1}')${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back security_menu
}

sec_hashid() {
    sub_banner "🔎 HASH IDENTIFIER"
    echo -ne "    ${T_WARNING}Enter hash: ${T_SUCCESS}"
    read hash
    echo -e "${RST}"
    [ -z "$hash" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; security_menu; return; }

    local len=${#hash}
    local hash_type="Unknown"
    local possible=()

    case $len in
        32)  possible=("MD5" "NTLM" "MD4") ;;
        40)  possible=("SHA-1" "MySQL5" "RIPEMD-160") ;;
        56)  possible=("SHA-224" "SHA3-224") ;;
        64)  possible=("SHA-256" "SHA3-256" "BLAKE2s") ;;
        96)  possible=("SHA-384" "SHA3-384") ;;
        128) possible=("SHA-512" "SHA3-512" "BLAKE2b" "Whirlpool") ;;
        *)   possible=("Unknown (len=$len)") ;;
    esac

    # Check if hex
    local is_hex=true
    [[ "$hash" =~ ^[0-9a-fA-F]+$ ]] || is_hex=false

    local W=52
    draw_box $W "HASH IDENTIFICATION"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}Hash   ${T_MUTED}: ${T_INFO}${hash:0:40}${RST}"
    [ ${#hash} -gt 40 ] && draw_box_line $W "           ${T_INFO}${hash:40:40}${RST}"
    draw_box_line $W "  ${T_WARNING}Length ${T_MUTED}: ${T_SUCCESS}${len} chars${RST}"
    draw_box_line $W "  ${T_WARNING}Hex    ${T_MUTED}: ${T_SUCCESS}${is_hex}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}Possible Types:${RST}"
    for pt in "${possible[@]}"; do
        draw_box_line $W "    ${T_SUCCESS}→ ${WH}${pt}${RST}"
    done
    draw_box_empty $W
    draw_box_bottom $W

    go_back security_menu
}

sec_encrypt() {
    sub_banner "🔒 FILE ENCRYPTOR (AES-256-CBC)"
    echo -ne "    ${T_WARNING}File to encrypt: ${T_SUCCESS}"
    read filepath
    echo -ne "    ${T_WARNING}Password: ${T_SUCCESS}"
    read -s enc_pass
    echo ""
    echo -e "${RST}"

    [ ! -f "$filepath" ] && { echo -e "    ${T_ERROR}[✗] File not found!${RST}"; sleep 1; security_menu; return; }
    [ -z "$enc_pass" ] && { echo -e "    ${T_ERROR}[✗] Password kosong!${RST}"; sleep 1; security_menu; return; }

    local outfile="${filepath}.enc"
    spin "Encrypting file..." 2 8

    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$filepath" -out "$outfile" -pass pass:"$enc_pass" 2>/dev/null && {
        echo -e "    $(badge_ok) File encrypted successfully!"
        echo -e "    ${T_MUTED}Output: ${T_SUCCESS}${outfile}${RST}"
        echo -e "    ${T_MUTED}Size  : ${T_INFO}$(du -h "$outfile" | cut -f1)${RST}"
    } || {
        echo -e "    $(badge_fail) Encryption failed!"
    }

    go_back security_menu
}

sec_decrypt() {
    sub_banner "🔓 FILE DECRYPTOR"
    echo -ne "    ${T_WARNING}Encrypted file (.enc): ${T_SUCCESS}"
    read filepath
    echo -ne "    ${T_WARNING}Password: ${T_SUCCESS}"
    read -s dec_pass
    echo ""
    echo -e "${RST}"

    [ ! -f "$filepath" ] && { echo -e "    ${T_ERROR}[✗] File not found!${RST}"; sleep 1; security_menu; return; }

    local outfile="${filepath%.enc}.dec"
    spin "Decrypting file..." 2 8

    openssl enc -d -aes-256-cbc -pbkdf2 -in "$filepath" -out "$outfile" -pass pass:"$dec_pass" 2>/dev/null && {
        echo -e "    $(badge_ok) File decrypted successfully!"
        echo -e "    ${T_MUTED}Output: ${T_SUCCESS}${outfile}${RST}"
    } || {
        echo -e "    $(badge_fail) Decryption failed! Wrong password?"
        rm -f "$outfile" 2>/dev/null
    }

    go_back security_menu
}

sec_jwt() {
    sub_banner "📜 JWT TOKEN DECODER"
    echo -ne "    ${T_WARNING}JWT Token: ${T_SUCCESS}"
    read jwt
    echo -e "${RST}"
    [ -z "$jwt" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; security_menu; return; }

    local header=$(echo "$jwt" | cut -d. -f1 | base64 -d 2>/dev/null)
    local payload=$(echo "$jwt" | cut -d. -f2 | base64 -d 2>/dev/null)

    local W=56
    draw_box $W "JWT TOKEN DECODED"
    draw_box_empty $W
    draw_box_line $W "  ${T_ACCENT}Header:${RST}"
    echo "$header" | python3 -m json.tool 2>/dev/null | while IFS= read -r line; do
        draw_box_line $W "    ${T_SUCCESS}${line:0:44}${RST}"
    done || draw_box_line $W "    ${T_INFO}${header:0:44}${RST}"

    draw_box_separator $W
    draw_box_line $W "  ${T_ACCENT}Payload:${RST}"
    echo "$payload" | python3 -m json.tool 2>/dev/null | while IFS= read -r line; do
        draw_box_line $W "    ${T_SUCCESS}${line:0:44}${RST}"
    done || draw_box_line $W "    ${T_INFO}${payload:0:44}${RST}"

    draw_box_empty $W
    draw_box_bottom $W
    go_back security_menu
}

sec_vuln_headers() {
    sub_banner "🛡️ SECURITY HEADER CHECK"
    echo -ne "    ${T_WARNING}URL: ${T_SUCCESS}"
    read url
    echo -e "${RST}"
    [ -z "$url" ] && { echo -e "    ${T_ERROR}[✗] Kosong!${RST}"; sleep 1; security_menu; return; }
    [[ "$url" != http* ]] && url="https://$url"

    spin "Checking security headers..." 2 3

    local headers=$(curl -sI --max-time 10 "$url" 2>/dev/null)

    local security_headers=("Strict-Transport-Security" "Content-Security-Policy" "X-Frame-Options"
                            "X-Content-Type-Options" "X-XSS-Protection" "Referrer-Policy"
                            "Permissions-Policy" "X-Permitted-Cross-Domain-Policies")

    local W=52
    draw_box $W "SECURITY HEADERS — $url"
    draw_box_empty $W

    local found=0 missing=0
    for sh in "${security_headers[@]}"; do
        local value=$(echo "$headers" | grep -i "^${sh}:" | cut -d: -f2- | xargs)
        if [ -n "$value" ]; then
            draw_box_line $W "  ${T_SUCCESS}✓ ${WH}${sh}${RST}"
            draw_box_line $W "    ${T_INFO}${value:0:40}${RST}"
            ((found++))
        else
            draw_box_line $W "  ${T_ERROR}✗ ${T_MUTED}${sh} — MISSING${RST}"
            ((missing++))
        fi
    done

    draw_box_separator $W

    local grade=""
    local total=${#security_headers[@]}
    local perc=$((found * 100 / total))
    if [ $perc -ge 80 ]; then grade="A ${T_SUCCESS}(Excellent)"; 
    elif [ $perc -ge 60 ]; then grade="B ${T_WARNING}(Good)";
    elif [ $perc -ge 40 ]; then grade="C ${T_WARNING}(Fair)";
    else grade="F ${T_ERROR}(Poor)"; fi

    draw_box_line $W "  ${T_WARNING}Score: ${T_INFO}${found}/${total}${RST} ${T_MUTED}(${perc}%)${RST}"
    draw_box_line $W "  ${T_WARNING}Grade: ${grade}${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back security_menu
}

sec_random() {
    sub_banner "🎲 RANDOM DATA GENERATOR"

    local W=52
    draw_box $W "RANDOM DATA"
    draw_box_empty $W
    draw_box_line $W "  ${T_WARNING}UUID v4:${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(cat /proc/sys/kernel/random/uuid 2>/dev/null || python3 -c 'import uuid; print(uuid.uuid4())' 2>/dev/null || echo 'N/A')${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}Random Hex (32 bytes):${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(openssl rand -hex 32 2>/dev/null)${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}Random Base64 (32 bytes):${RST}"
    draw_box_line $W "    ${T_SUCCESS}$(openssl rand -base64 32 2>/dev/null)${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}Random MAC Address:${RST}"
    local mac=$(openssl rand -hex 6 2>/dev/null | sed 's/\(..\)/\1:/g; s/:$//')
    draw_box_line $W "    ${T_SUCCESS}${mac}${RST}"
    draw_box_separator $W
    draw_box_line $W "  ${T_WARNING}Random IPv4:${RST}"
    draw_box_line $W "    ${T_SUCCESS}$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))${RST}"
    draw_box_empty $W
    draw_box_bottom $W

    go_back security_menu
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 04: WIFI PASSWORD EXTRACTOR ★ NEW ★
# ═══════════════════════════════════════════════════════════════

wifi_menu() {
    sub_banner "📡 WIFI PASSWORD EXTRACTOR"

    echo -e "    ${T_WARNING}${BLD}⚠️  DISCLAIMER:${RST}"
    echo -e "    ${T_MUTED}This tool extracts saved WiFi passwords from${RST}"
    echo -e "    ${T_MUTED}YOUR OWN device. Root access may be required.${RST}"
    echo -e "    ${T_MUTED}Use responsibly and ethically.${RST}"
    echo ""

    local W=52
    draw_box $W "WIFI TOOLS"
    draw_box_empty $W
    menu_item "01" "🔑" "Extract Saved WiFi Passwords"  $W
    menu_item "02" "📶" "Current WiFi Connection Info"   $W
    menu_item "03" "📡" "Scan Nearby WiFi Networks"      $W
    menu_item "04" "📋" "Export Passwords to File"       $W
    menu_item "05" "🔍" "WiFi Config File Viewer"        $W
    menu_item "06" "📊" "WiFi Signal Strength Monitor"   $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"           $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1) wifi_extract_passwords ;;
        02|2) wifi_current_info ;;
        03|3) wifi_scan_nearby ;;
        04|4) wifi_export ;;
        05|5) wifi_config_viewer ;;
        06|6) wifi_signal_monitor ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; wifi_menu ;;
    esac
}

wifi_extract_passwords() {
    sub_banner "🔑 EXTRACT SAVED WIFI PASSWORDS"

    premium_bar "Scanning for saved WiFi credentials" 2

    local W=56
    draw_box $W "SAVED WIFI PASSWORDS"
    draw_box_empty $W

    local found=0

    # Method 1: Root — WifiConfigStore.xml (Android 8+)
    local config_files=(
        "/data/misc/wifi/WifiConfigStore.xml"
        "/data/misc/wifi/wpa_supplicant.conf"
        "/data/misc/wifi/softap.conf"
        "/data/misc/apexdata/com.android.wifi/WifiConfigStore.xml"
    )

    local root_available=false
    if su -c "echo test" &>/dev/null 2>&1; then
        root_available=true
    fi

    if $root_available; then
        draw_box_line $W "  ${T_SUCCESS}✓ ROOT ACCESS DETECTED${RST}"
        draw_box_separator $W

        for cfg in "${config_files[@]}"; do
            if su -c "test -f '$cfg'" 2>/dev/null; then
                draw_box_line $W "  ${T_INFO}📄 Source: ${T_MUTED}${cfg}${RST}"
                draw_box_separator $W

                if echo "$cfg" | grep -q "WifiConfigStore.xml"; then
                    # Parse WifiConfigStore.xml
                    local wifi_data=$(su -c "cat '$cfg'" 2>/dev/null)

                    # Extract SSID and PreSharedKey pairs
                    local ssids=$(echo "$wifi_data" | grep -oP '(?<=name="SSID").*?(?=</)' | sed 's/.*">//' | sed 's/&quot;//g' | sed 's/"//g')
                    local passwords=$(echo "$wifi_data" | grep -oP '(?<=name="PreSharedKey").*?(?=</)' | sed 's/.*">//' | sed 's/&quot;//g' | sed 's/"//g')

                    # Alternative parsing
                    if [ -z "$ssids" ]; then
                        local entries=$(echo "$wifi_data" | grep -A2 "ConfigKey\|SSID\|PreSharedKey")
                        
                        echo "$wifi_data" | grep -B1 -A1 "SSID\|PreSharedKey" | while IFS= read -r line; do
                            if echo "$line" | grep -q "SSID"; then
                                local ssid=$(echo "$line" | sed 's/.*>\(.*\)<.*/\1/' | sed 's/&quot;//g' | tr -d '"')
                                if [ -n "$ssid" ] && [ "$ssid" != "SSID" ]; then
                                    echo "SSID:$ssid"
                                fi
                            elif echo "$line" | grep -q "PreSharedKey"; then
                                local psk=$(echo "$line" | sed 's/.*>\(.*\)<.*/\1/' | sed 's/&quot;//g' | tr -d '"')
                                if [ -n "$psk" ] && [ "$psk" != "PreSharedKey" ]; then
                                    echo "PSK:$psk"
                                fi
                            fi
                        done | paste -d'|' - - 2>/dev/null | while IFS='|' read -r ssid_line psk_line; do
                            local s_name=$(echo "$ssid_line" | cut -d: -f2-)
                            local s_pass=$(echo "$psk_line" | cut -d: -f2-)
                            if [ -n "$s_name" ]; then
                                draw_box_line $W "  ${T_PRIMARY}📶 ${BLD}${s_name}${RST}"
                                if [ -n "$s_pass" ] && [ "$s_pass" != "*" ]; then
                                    draw_box_line $W "     ${T_WARNING}🔑 ${T_SUCCESS}${s_pass}${RST}"
                                else
                                    draw_box_line $W "     ${T_WARNING}🔑 ${T_MUTED}(open / hidden)${RST}"
                                fi
                                draw_box_line $W ""
                                ((found++))
                            fi
                        done
                    fi

                    # Simpler grep approach
                    if [ $found -eq 0 ]; then
                        su -c "cat '$cfg'" 2>/dev/null | grep -oP '"[^"]*"' | while IFS= read -r val; do
                            val=$(echo "$val" | tr -d '"')
                            [ ${#val} -gt 2 ] && [ ${#val} -lt 50 ] && {
                                draw_box_line $W "    ${T_INFO}${val}${RST}"
                            }
                        done
                    fi

                elif echo "$cfg" | grep -q "wpa_supplicant"; then
                    # Parse wpa_supplicant.conf (older Android)
                    su -c "cat '$cfg'" 2>/dev/null | grep -A3 "network=" | while IFS= read -r line; do
                        if echo "$line" | grep -q "ssid="; then
                            local ssid=$(echo "$line" | cut -d'"' -f2)
                            draw_box_line $W "  ${T_PRIMARY}📶 ${BLD}${ssid}${RST}"
                        elif echo "$line" | grep -q "psk="; then
                            local psk=$(echo "$line" | cut -d'"' -f2)
                            draw_box_line $W "     ${T_WARNING}🔑 ${T_SUCCESS}${psk}${RST}"
                            draw_box_line $W ""
                            ((found++))
                        fi
                    done
                fi
                break
            fi
        done

        if [ $found -eq 0 ]; then
            draw_box_line $W "  ${T_WARNING}[!] Trying alternative method...${RST}"
            draw_box_separator $W

            # Try cmd wifi
            local wifi_list=$(su -c "cmd wifi list-networks" 2>/dev/null)
            if [ -n "$wifi_list" ]; then
                echo "$wifi_list" | while IFS= read -r line; do
                    draw_box_line $W "  ${T_INFO}${line:0:48}${RST}"
                done
            fi
        fi

    else
        draw_box_line $W "  ${T_ERROR}✗ ROOT ACCESS NOT AVAILABLE${RST}"
        draw_box_separator $W
        draw_box_line $W "  ${T_INFO}Alternative Methods:${RST}"
        draw_box_empty $W

        # Method 2: Termux:API (non-root)
        if command -v termux-wifi-connectioninfo &>/dev/null; then
            draw_box_line $W "  ${T_SUCCESS}✓ Termux:API available${RST}"
            draw_box_separator $W
            draw_box_line $W "  ${T_ACCENT}Current WiFi Info:${RST}"
            local wifi_info=$(termux-wifi-connectioninfo 2>/dev/null)
            if [ -n "$wifi_info" ]; then
                echo "$wifi_info" | python3 -m json.tool 2>/dev/null | while IFS= read -r line; do
                    draw_box_line $W "    ${T_INFO}${line:0:44}${RST}"
                done
            fi
        else
            draw_box_line $W "  ${T_WARNING}Install Termux:API for WiFi info:${RST}"
            draw_box_line $W "    ${T_MUTED}pkg install termux-api${RST}"
            draw_box_line $W "    ${T_MUTED}+ Install Termux:API app from F-Droid${RST}"
        fi

        draw_box_separator $W
        draw_box_line $W "  ${T_ACCENT}To get WiFi passwords, you need:${RST}"
        draw_box_line $W "    ${T_INFO}1. Root access (Magisk/KernelSU)${RST}"
        draw_box_line $W "    ${T_INFO}2. Or: adb backup method${RST}"
        draw_box_line $W "    ${T_INFO}3. Or: Android 10+ Share QR${RST}"
    fi

    draw_box_empty $W
    draw_box_bottom $W
    go_back wifi_menu
}

wifi_current_info() {
    sub_banner "📶 CURRENT WIFI INFO"
    spin "Getting WiFi connection details..." 2 2

    local W=52
    draw_box $W "CURRENT CONNECTION"
    draw_box_empty $W

    # Termux API method
    if command -v termux-wifi-connectioninfo &>/dev/null; then
        local info=$(termux-wifi-connectioninfo 2>/dev/null)
        if [ -n "$info" ]; then
            local ssid=$(echo "$info" | grep -o '"ssid":"[^"]*"' | cut -d'"' -f4)
            local bssid=$(echo "$info" | grep -o '"bssid":"[^"]*"' | cut -d'"' -f4)
            local freq=$(echo "$info" | grep -o '"frequency_mhz":[0-9]*' | cut -d: -f2)
            local rssi=$(echo "$info" | grep -o '"rssi":-*[0-9]*' | cut -d: -f2)
            local link_speed=$(echo "$info" | grep -o '"link_speed_mbps":[0-9]*' | cut -d: -f2)
            local ip_addr=$(echo "$info" | grep -o '"ip":"[^"]*"' | cut -d'"' -f4)
            local mac_addr=$(echo "$info" | grep -o '"mac_address":"[^"]*"' | cut -d'"' -f4)
            local network_id=$(echo "$info" | grep -o '"network_id":[0-9]*' | cut -d: -f2)

            draw_box_line $W "  📶 ${T_WARNING}SSID        ${T_MUTED}: ${T_SUCCESS}${BLD}${ssid:-N/A}${RST}"
            draw_box_line $W "  🔗 ${T_WARNING}BSSID       ${T_MUTED}: ${T_INFO}${bssid:-N/A}${RST}"
            draw_box_line $W "  📡 ${T_WARNING}Frequency   ${T_MUTED}: ${T_INFO}${freq:-N/A} MHz${RST}"
            draw_box_line $W "  📊 ${T_WARNING}Signal(RSSI)${T_MUTED}: ${T_INFO}${rssi:-N/A} dBm${RST}"
            draw_box_line $W "  🚀 ${T_WARNING}Link Speed  ${T_MUTED}: ${T_INFO}${link_speed:-N/A} Mbps${RST}"
            draw_box_line $W "  🌐 ${T_WARNING}IP Address  ${T_MUTED}: ${T_INFO}${ip_addr:-N/A}${RST}"
            draw_box_line $W "  🔢 ${T_WARNING}MAC Address ${T_MUTED}: ${T_INFO}${mac_addr:-N/A}${RST}"
            draw_box_line $W "  🆔 ${T_WARNING}Network ID  ${T_MUTED}: ${T_INFO}${network_id:-N/A}${RST}"

            # Signal strength bar
            if [ -n "$rssi" ]; then
                local sig_pct=0
                [ "$rssi" -ge -50 ] && sig_pct=100
                [ "$rssi" -lt -50 ] && [ "$rssi" -ge -60 ] && sig_pct=80
                [ "$rssi" -lt -60 ] && [ "$rssi" -ge -70 ] && sig_pct=60
                [ "$rssi" -lt -70 ] && [ "$rssi" -ge -80 ] && sig_pct=40
                [ "$rssi" -lt -80 ] && sig_pct=20

                draw_box_separator $W
                local bar_w=30
                local bar_filled=$((sig_pct * bar_w / 100))
                echo -ne "    ${T_BORDER}║${RST}  Signal: ["
                local sig_color="${T_SUCCESS}"
                [ $sig_pct -lt 60 ] && sig_color="${T_WARNING}"
                [ $sig_pct -lt 30 ] && sig_color="${T_ERROR}"
                for ((b=0; b<bar_filled; b++)); do echo -ne "${sig_color}█"; done
                for ((b=bar_filled; b<bar_w; b++)); do echo -ne "${T_MUTED}░"; done
                echo -e "${RST}] ${sig_color}${sig_pct}%${RST}"

                # Band info
                if [ -n "$freq" ]; then
                    local band="2.4 GHz"
                    [ "$freq" -gt 5000 ] && band="5 GHz"
                    [ "$freq" -gt 6000 ] && band="6 GHz (WiFi 6E)"
                    draw_box_line $W "  📻 ${T_WARNING}Band        ${T_MUTED}: ${T_INFO}${band}${RST}"
                fi
            fi
        fi
    else
        draw_box_line $W "  ${T_WARNING}Using ip/ifconfig for basic info:${RST}"
        draw_box_separator $W

        local wlan_ip=$(ip addr show wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
        local wlan_mac=$(ip link show wlan0 2>/dev/null | grep "link/ether" | awk '{print $2}')

        draw_box_line $W "  ${T_WARNING}IP      ${T_MUTED}: ${T_INFO}${wlan_ip:-N/A}${RST}"
        draw_box_line $W "  ${T_WARNING}MAC     ${T_MUTED}: ${T_INFO}${wlan_mac:-N/A}${RST}"
        draw_box_separator $W
        draw_box_line $W "  ${T_MUTED}Install termux-api for more info${RST}"
    fi

    draw_box_empty $W
    draw_box_bottom $W
    go_back wifi_menu
}

wifi_scan_nearby() {
    sub_banner "📡 SCAN NEARBY WIFI NETWORKS"

    if command -v termux-wifi-scaninfo &>/dev/null; then
        spin "Scanning nearby WiFi networks..." 3 6

        local scan=$(termux-wifi-scaninfo 2>/dev/null)

        local W=56
        draw_box $W "NEARBY WIFI NETWORKS"
        draw_box_empty $W
        draw_box_line $W "  ${T_WARNING}SSID$(printf '%*s' 20 '')SIGNAL  FREQ   SEC${RST}"
        draw_box_separator $W

        echo "$scan" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for net in data[:25]:
        ssid = net.get('ssid', 'Hidden')[:20]
        rssi = net.get('rssi', 0)
        freq = net.get('frequency_mhz', 0)
        caps = net.get('capabilities', '')
        sec = 'OPEN'
        if 'WPA3' in caps: sec = 'WPA3'
        elif 'WPA2' in caps: sec = 'WPA2'
        elif 'WPA' in caps: sec = 'WPA'
        elif 'WEP' in caps: sec = 'WEP'
        
        sig_bar = '█' * max(1, min(5, (rssi + 100) // 15))
        sig_bar = sig_bar.ljust(5, '░')
        print(f'{ssid}|{rssi}|{freq}|{sec}|{sig_bar}')
except:
    pass
" 2>/dev/null | while IFS='|' read -r ssid rssi freq sec sig_bar; do
            local sec_color="${T_SUCCESS}"
            [ "$sec" = "OPEN" ] && sec_color="${T_ERROR}"
            [ "$sec" = "WEP" ] && sec_color="${T_WARNING}"

            draw_box_line $W "  ${T_INFO}${ssid}$(printf '%*s' $((22 - ${#ssid})) '')${T_SUCCESS}${sig_bar} ${T_MUTED}${freq} ${sec_color}${sec}${RST}"
        done

        draw_box_empty $W
        draw_box_bottom $W
    else
        echo -e "    ${T_WARNING}[!] Requires Termux:API${RST}"
        echo -e "    ${T_MUTED}Install: pkg install termux-api${RST}"
        echo -e "    ${T_MUTED}+ Install Termux:API app from F-Droid${RST}"
    fi

    go_back wifi_menu
}

wifi_export() {
    sub_banner "📋 EXPORT WIFI PASSWORDS"

    local export_file="$HOME/wifi_passwords_$(date +%Y%m%d_%H%M%S).txt"

    spin "Exporting WiFi credentials..." 2 8

    echo "═══════════════════════════════════════════" > "$export_file"
    echo "  KyyInfinite WiFi Password Export" >> "$export_file"
    echo "  Date: $(date)" >> "$export_file"
    echo "  Device: $(uname -a)" >> "$export_file"
    echo "═══════════════════════════════════════════" >> "$export_file"
    echo "" >> "$export_file"

    if su -c "echo test" &>/dev/null 2>&1; then
        for cfg in "/data/misc/wifi/WifiConfigStore.xml" "/data/misc/wifi/wpa_supplicant.conf"; do
            if su -c "test -f '$cfg'" 2>/dev/null; then
                echo "Source: $cfg" >> "$export_file"
                echo "---" >> "$export_file"
                su -c "cat '$cfg'" >> "$export_file" 2>/dev/null
                echo "" >> "$export_file"
            fi
        done
        echo -e "    $(badge_ok) Exported to: ${WH}${export_file}${RST}"
        echo -e "    ${T_MUTED}Size: $(du -h "$export_file" | cut -f1)${RST}"
    else
        echo "[NO ROOT] Cannot export WiFi config files" >> "$export_file"
        echo -e "    ${T_WARNING}[!] Root required for full export${RST}"
        echo -e "    ${T_MUTED}Partial export saved to: ${WH}${export_file}${RST}"
    fi

    go_back wifi_menu
}

wifi_config_viewer() {
    sub_banner "🔍 WIFI CONFIG FILE VIEWER"

    if su -c "echo test" &>/dev/null 2>&1; then
        local configs=(
            "/data/misc/wifi/WifiConfigStore.xml"
            "/data/misc/wifi/wpa_supplicant.conf"
            "/data/misc/wifi/p2p_supplicant.conf"
            "/data/misc/wifi/softap.conf"
            "/data/misc/apexdata/com.android.wifi/WifiConfigStore.xml"
        )

        local W=52
        draw_box $W "WIFI CONFIG FILES"
        draw_box_empty $W

        for cfg in "${configs[@]}"; do
            if su -c "test -f '$cfg'" 2>/dev/null; then
                local size=$(su -c "du -h '$cfg'" 2>/dev/null | cut -f1)
                draw_box_line $W "  ${T_SUCCESS}✓ ${WH}${cfg##*/}${RST}"
                draw_box_line $W "    ${T_MUTED}Path: ${T_INFO}${cfg}${RST}"
                draw_box_line $W "    ${T_MUTED}Size: ${T_INFO}${size}${RST}"
            else
                draw_box_line $W "  ${T_ERROR}✗ ${T_MUTED}${cfg##*/}${RST}"
            fi
        done

        draw_box_separator $W
        echo -ne "    ${T_BORDER}║${RST} ${T_WARNING}View file content? [1-5/n]: ${T_SUCCESS}"
        read view_choice
        echo -e "${RST}"

        if [[ "$view_choice" =~ ^[1-5]$ ]]; then
            local idx=$((view_choice - 1))
            local selected="${configs[$idx]}"
            if su -c "test -f '$selected'" 2>/dev/null; then
                draw_box_separator $W
                draw_box_line $W "  ${T_ACCENT}Content (first 50 lines):${RST}"
                su -c "head -50 '$selected'" 2>/dev/null | while IFS= read -r line; do
                    echo -e "    ${T_INFO}${line:0:50}${RST}"
                done
            fi
        fi

        draw_box_empty $W
        draw_box_bottom $W
    else
        echo -e "    ${T_ERROR}[✗] Root access required${RST}"
    fi

    go_back wifi_menu
}

wifi_signal_monitor() {
    sub_banner "📊 WIFI SIGNAL STRENGTH MONITOR"

    if ! command -v termux-wifi-connectioninfo &>/dev/null; then
        echo -e "    ${T_ERROR}[✗] Requires termux-api${RST}"
        go_back wifi_menu
        return
    fi

    echo -e "    ${T_INFO}Monitoring signal... Press Ctrl+C to stop${RST}"
    echo ""

    for ((i=0; i<15; i++)); do
        local info=$(termux-wifi-connectioninfo 2>/dev/null)
        local rssi=$(echo "$info" | grep -o '"rssi":-*[0-9]*' | cut -d: -f2)
        local ssid=$(echo "$info" | grep -o '"ssid":"[^"]*"' | cut -d'"' -f4)
        local speed=$(echo "$info" | grep -o '"link_speed_mbps":[0-9]*' | cut -d: -f2)

        [ -z "$rssi" ] && rssi=-99

        local sig_pct=0
        [ "$rssi" -ge -50 ] && sig_pct=100
        [ "$rssi" -lt -50 ] && [ "$rssi" -ge -60 ] && sig_pct=80
        [ "$rssi" -lt -60 ] && [ "$rssi" -ge -70 ] && sig_pct=60
        [ "$rssi" -lt -70 ] && [ "$rssi" -ge -80 ] && sig_pct=40
        [ "$rssi" -lt -80 ] && sig_pct=20

        local bar_w=25
        local bar_filled=$((sig_pct * bar_w / 100))
        local sig_color="${T_SUCCESS}"
        [ $sig_pct -lt 60 ] && sig_color="${T_WARNING}"
        [ $sig_pct -lt 30 ] && sig_color="${T_ERROR}"

        echo -ne "\r    ${T_MUTED}$(date +%H:%M:%S) ${T_INFO}${ssid:-?} ${RST}["
        for ((b=0; b<bar_filled; b++)); do echo -ne "${sig_color}█"; done
        for ((b=bar_filled; b<bar_w; b++)); do echo -ne "${T_MUTED}░"; done
        echo -ne "${RST}] ${sig_color}${rssi}dBm ${WH}${speed}Mbps   ${RST}"

        sleep 2
    done
    echo ""
    go_back wifi_menu
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 05: DEVICE & SYSTEM DASHBOARD
# ═══════════════════════════════════════════════════════════════

device_info() {
    sub_banner "📱 SYSTEM DASHBOARD"
    spin "Collecting system information..." 2 6

    local os=$(uname -o 2>/dev/null || echo "N/A")
    local kernel=$(uname -r 2>/dev/null || echo "N/A")
    local arch=$(uname -m 2>/dev/null || echo "N/A")
    local host=$(hostname 2>/dev/null || echo "N/A")
    local user=$(whoami 2>/dev/null || echo "N/A")
    local shell_name=$(basename "$SHELL" 2>/dev/null || echo "N/A")
    local uptime_info=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
    local cpu=$(cat /proc/cpuinfo 2>/dev/null | grep "model name" | head -1 | cut -d: -f2 | xargs || echo "N/A")
    local cpu_hw=$(cat /proc/cpuinfo 2>/dev/null | grep "Hardware" | head -1 | cut -d: -f2 | xargs)
    local cores=$(nproc 2>/dev/null || echo "N/A")
    local mem_total=$(free -h 2>/dev/null | awk '/Mem:/{print $2}' || echo "N/A")
    local mem_used=$(free -h 2>/dev/null | awk '/Mem:/{print $3}' || echo "N/A")
    local mem_free=$(free -h 2>/dev/null | awk '/Mem:/{print $4}' || echo "N/A")
    local swap_total=$(free -h 2>/dev/null | awk '/Swap:/{print $2}' || echo "N/A")
    local disk_total=$(df -h / 2>/dev/null | awk 'NR==2{print $2}' || echo "N/A")
    local disk_used=$(df -h / 2>/dev/null | awk 'NR==2{print $3}' || echo "N/A")
    local disk_perc=$(df -h / 2>/dev/null | awk 'NR==2{print $5}' || echo "N/A")
    local pkg_count=$(dpkg -l 2>/dev/null | grep -c '^ii' || echo "N/A")
    local android_ver=$(getprop ro.build.version.release 2>/dev/null)
    local device_model=$(getprop ro.product.model 2>/dev/null)
    local device_brand=$(getprop ro.product.brand 2>/dev/null)
    local sdk=$(getprop ro.build.version.sdk 2>/dev/null)
    local build=$(getprop ro.build.display.id 2>/dev/null)
    local battery=$(termux-battery-status 2>/dev/null)
    local bat_pct=$(echo "$battery" | grep -o '"percentage":[0-9]*' | cut -d: -f2)
    local bat_status=$(echo "$battery" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

    local W=52
    draw_box $W "SYSTEM INFORMATION"
    draw_box_empty $W

    # Android Info
    if [ -n "$android_ver" ]; then
        draw_box_line $W "  ${T_ACCENT}📱 DEVICE${RST}"
        draw_box_line $W "    ${T_WARNING}Brand       ${T_MUTED}: ${T_SUCCESS}${device_brand:-N/A}${RST}"
        draw_box_line $W "    ${T_WARNING}Model       ${T_MUTED}: ${T_SUCCESS}${device_model:-N/A}${RST}"
        draw_box_line $W "    ${T_WARNING}Android     ${T_MUTED}: ${T_SUCCESS}${android_ver} (SDK ${sdk})${RST}"
        draw_box_line $W "    ${T_WARNING}Build       ${T_MUTED}: ${T_INFO}${build:-N/A}${RST}"
        draw_box_separator $W
    fi

    # System
    draw_box_line $W "  ${T_ACCENT}⚙️  SYSTEM${RST}"
    draw_box_line $W "    ${T_WARNING}OS          ${T_MUTED}: ${T_SUCCESS}${os}${RST}"
    draw_box_line $W "    ${T_WARNING}Kernel      ${T_MUTED}: ${T_SUCCESS}${kernel}${RST}"
    draw_box_line $W "    ${T_WARNING}Arch        ${T_MUTED}: ${T_SUCCESS}${arch}${RST}"
    draw_box_line $W "    ${T_WARNING}User        ${T_MUTED}: ${T_SUCCESS}${user}@${host}${RST}"
    draw_box_line $W "    ${T_WARNING}Shell       ${T_MUTED}: ${T_SUCCESS}${shell_name}${RST}"
    draw_box_line $W "    ${T_WARNING}Uptime      ${T_MUTED}: ${T_INFO}${uptime_info}${RST}"
    draw_box_line $W "    ${T_WARNING}Packages    ${T_MUTED}: ${T_INFO}${pkg_count}${RST}"

    draw_box_separator $W

    # CPU
    draw_box_line $W "  ${T_ACCENT}🔧 CPU${RST}"
    draw_box_line $W "    ${T_WARNING}Processor   ${T_MUTED}: ${T_SUCCESS}${cpu:0:35}${RST}"
    [ -n "$cpu_hw" ] && draw_box_line $W "    ${T_WARNING}Hardware    ${T_MUTED}: ${T_SUCCESS}${cpu_hw:0:35}${RST}"
    draw_box_line $W "    ${T_WARNING}Cores       ${T_MUTED}: ${T_SUCCESS}${cores}${RST}"

    draw_box_separator $W

    # Memory with bar
    draw_box_line $W "  ${T_ACCENT}💾 MEMORY${RST}"
    draw_box_line $W "    ${T_WARNING}RAM         ${T_MUTED}: ${T_SUCCESS}${mem_used} / ${mem_total}${RST}"
    draw_box_line $W "    ${T_WARNING}Free        ${T_MUTED}: ${T_INFO}${mem_free}${RST}"
    draw_box_line $W "    ${T_WARNING}Swap        ${T_MUTED}: ${T_INFO}${swap_total}${RST}"

    draw_box_separator $W

    # Disk with bar
    draw_box_line $W "  ${T_ACCENT}💽 STORAGE${RST}"
    draw_box_line $W "    ${T_WARNING}Used        ${T_MUTED}: ${T_SUCCESS}${disk_used} / ${disk_total} (${disk_perc})${RST}"

    local perc_num=$(echo "$disk_perc" | tr -d '%')
    if [ -n "$perc_num" ] && [ "$perc_num" -eq "$perc_num" ] 2>/dev/null; then
        local bar_w=30
        local bar_filled=$((perc_num * bar_w / 100))
        local bar_color="${T_SUCCESS}"
        [ "$perc_num" -gt 60 ] && bar_color="${T_WARNING}"
        [ "$perc_num" -gt 85 ] && bar_color="${T_ERROR}"
        echo -ne "    ${T_BORDER}║${RST}    ["
        for ((b=0; b<bar_filled; b++)); do echo -ne "${bar_color}█"; done
        for ((b=bar_filled; b<bar_w; b++)); do echo -ne "${T_MUTED}░"; done
        echo -e "${RST}] ${bar_color}${disk_perc}${RST}"
    fi

    # Battery
    if [ -n "$bat_pct" ]; then
        draw_box_separator $W
        draw_box_line $W "  ${T_ACCENT}🔋 BATTERY${RST}"
        draw_box_line $W "    ${T_WARNING}Level       ${T_MUTED}: ${T_SUCCESS}${bat_pct}%${RST}"
        draw_box_line $W "    ${T_WARNING}Status      ${T_MUTED}: ${T_INFO}${bat_status:-N/A}${RST}"
    fi

    draw_box_empty $W
    draw_box_bottom $W
    go_back main_menu
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 07: TEXT / ENCODE / CRYPTO TOOLS
# ═══════════════════════════════════════════════════════════════

text_tools_menu() {
    sub_banner "📝 TEXT / ENCODE / CRYPTO TOOLS"

    local W=52
    draw_box $W "TEXT TOOLS"
    draw_box_empty $W
    menu_item "01" "🔤" "Base64 Encode/Decode"      $W
    menu_item "02" "🔗" "URL Encode/Decode"          $W
    menu_item "03" "🔄" "ROT13 / ROT47 Cipher"      $W
    menu_item "04" "💻" "Binary ↔ Text"              $W
    menu_item "05" "🔢" "Hex ↔ Text"                 $W
    menu_item "06" "📊" "Word & Character Counter"   $W
    menu_item "07" "🔀" "Text Reverser"              $W
    menu_item "08" "📋" "Lorem Ipsum Generator"      $W
    menu_item "09" "🔠" "Case Converter"             $W
    menu_item "10" "🧮" "Number Base Converter"      $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"       $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1)
            sub_banner "BASE64"
            echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} Encode  ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} Decode"
            echo -ne "    ${T_WARNING}Choice: ${T_SUCCESS}"; read mode
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            if [ "$mode" = "1" ]; then
                echo -e "    ${T_SUCCESS}Result: ${WH}$(echo -n "$text" | base64)${RST}"
            else
                echo -e "    ${T_SUCCESS}Result: ${WH}$(echo -n "$text" | base64 -d 2>/dev/null)${RST}"
            fi
            go_back text_tools_menu ;;
        02|2)
            sub_banner "URL ENCODE/DECODE"
            echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} Encode  ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} Decode"
            echo -ne "    ${T_WARNING}Choice: ${T_SUCCESS}"; read mode
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            if [ "$mode" = "1" ]; then
                local res=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$text'))" 2>/dev/null)
                echo -e "    ${T_SUCCESS}Result: ${WH}${res}${RST}"
            else
                local res=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('$text'))" 2>/dev/null)
                echo -e "    ${T_SUCCESS}Result: ${WH}${res}${RST}"
            fi
            go_back text_tools_menu ;;
        03|3)
            sub_banner "ROT CIPHER"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            echo -e "    ${T_ACCENT}ROT13: ${WH}$(echo "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m')${RST}"
            echo -e "    ${T_ACCENT}ROT47: ${WH}$(echo "$text" | tr '\!-~' 'P-~\!-O')${RST}"
            go_back text_tools_menu ;;
        04|4)
            sub_banner "BINARY CONVERTER"
            echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} Text→Binary  ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} Binary→Text"
            echo -ne "    ${T_WARNING}Choice: ${T_SUCCESS}"; read mode
            echo -ne "    ${T_WARNING}Input: ${T_SUCCESS}"; read text; echo -e "${RST}"
            if [ "$mode" = "1" ]; then
                local res=$(echo -n "$text" | xxd -b | awk '{for(i=2;i<=7;i++) printf "%s ",$i}')
                echo -e "    ${T_SUCCESS}Binary: ${WH}${res}${RST}"
            else
                local res=$(python3 -c "
bins = '$text'.split()
result = ''.join([chr(int(b,2)) for b in bins])
print(result)
" 2>/dev/null)
                echo -e "    ${T_SUCCESS}Text: ${WH}${res}${RST}"
            fi
            go_back text_tools_menu ;;
        05|5)
            sub_banner "HEX CONVERTER"
            echo -e "    ${T_SUCCESS}[${WH}1${T_SUCCESS}]${RST} Text→Hex  ${T_SUCCESS}[${WH}2${T_SUCCESS}]${RST} Hex→Text"
            echo -ne "    ${T_WARNING}Choice: ${T_SUCCESS}"; read mode
            echo -ne "    ${T_WARNING}Input: ${T_SUCCESS}"; read text; echo -e "${RST}"
            if [ "$mode" = "1" ]; then
                echo -e "    ${T_SUCCESS}Hex: ${WH}$(echo -n "$text" | xxd -p)${RST}"
            else
                echo -e "    ${T_SUCCESS}Text: ${WH}$(echo "$text" | xxd -r -p)${RST}"
            fi
            go_back text_tools_menu ;;
        06|6)
            sub_banner "WORD COUNTER"
            echo -ne "    ${T_WARNING}Enter text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            local chars=${#text}
            local words=$(echo "$text" | wc -w)
            local no_space=$(echo "$text" | tr -d ' ' | wc -c)
            local sentences=$(echo "$text" | grep -o '[.!?]' | wc -l)

            local W=42
            draw_box $W "TEXT ANALYSIS"
            draw_box_empty $W
            draw_box_line $W "  ${T_WARNING}Characters    ${T_MUTED}: ${T_SUCCESS}$chars${RST}"
            draw_box_line $W "  ${T_WARNING}No spaces     ${T_MUTED}: ${T_SUCCESS}$no_space${RST}"
            draw_box_line $W "  ${T_WARNING}Words         ${T_MUTED}: ${T_SUCCESS}$words${RST}"
            draw_box_line $W "  ${T_WARNING}Sentences     ${T_MUTED}: ${T_SUCCESS}$sentences${RST}"
            draw_box_empty $W
            draw_box_bottom $W
            go_back text_tools_menu ;;
        07|7)
            sub_banner "TEXT REVERSER"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            echo -e "    ${T_SUCCESS}Reversed: ${WH}$(echo "$text" | rev)${RST}"
            go_back text_tools_menu ;;
        08|8)
            sub_banner "LOREM IPSUM"
            echo -ne "    ${T_WARNING}Paragraphs (1-5): ${T_SUCCESS}"; read para_count; echo -e "${RST}"
            para_count=${para_count:-1}
            local lorem="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
            for ((p=0; p<para_count; p++)); do
                echo -e "    ${T_INFO}${lorem}${RST}"
                echo ""
            done
            go_back text_tools_menu ;;
        09|9)
            sub_banner "CASE CONVERTER"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read text; echo -e "${RST}"
            echo -e "    ${T_ACCENT}UPPER:  ${WH}${text^^}${RST}"
            echo -e "    ${T_ACCENT}lower:  ${WH}${text,,}${RST}"
            echo -e "    ${T_ACCENT}Title:  ${WH}$(echo "$text" | sed 's/\b\(.\)/\u\1/g')${RST}"
            echo -e "    ${T_ACCENT}sWAP:   ${WH}$(echo "$text" | tr 'a-zA-Z' 'A-Za-z')${RST}"
            go_back text_tools_menu ;;
        10)
            sub_banner "NUMBER BASE CONVERTER"
            echo -ne "    ${T_WARNING}Number: ${T_SUCCESS}"; read num
            echo -ne "    ${T_WARNING}From base (10): ${T_SUCCESS}"; read from_base
            echo -e "${RST}"
            from_base=${from_base:-10}

            local dec_val=$(echo "ibase=$from_base; ${num^^}" | bc 2>/dev/null)
            [ -z "$dec_val" ] && dec_val=$num

            echo -e "    ${T_ACCENT}Decimal : ${WH}${dec_val}${RST}"
            echo -e "    ${T_ACCENT}Binary  : ${WH}$(echo "obase=2; $dec_val" | bc 2>/dev/null)${RST}"
            echo -e "    ${T_ACCENT}Octal   : ${WH}$(echo "obase=8; $dec_val" | bc 2>/dev/null)${RST}"
            echo -e "    ${T_ACCENT}Hex     : ${WH}$(echo "obase=16; $dec_val" | bc 2>/dev/null)${RST}"
            go_back text_tools_menu ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; text_tools_menu ;;
    esac
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 08: FILE MANAGER & DOWNLOADER
# ═══════════════════════════════════════════════════════════════

file_manager_menu() {
    sub_banner "📁 FILE MANAGER & DOWNLOADER"

    echo -e "    ${T_MUTED}📂 CWD: ${T_INFO}$(pwd)${RST}"
    echo ""

    local W=52
    draw_box $W "FILE TOOLS"
    draw_box_empty $W
    menu_item "01" "📄" "List Files (Enhanced)"     $W
    menu_item "02" "🔍" "Search File by Name"        $W
    menu_item "03" "📝" "Search Text in Files"       $W
    menu_item "04" "📊" "Disk Usage Analyzer"        $W
    menu_item "05" "📐" "File/Folder Size Top 20"    $W
    menu_item "06" "📥" "URL Downloader"             $W
    menu_item "07" "📦" "File Compressor (tar.gz)"   $W
    menu_item "08" "📂" "File Decompressor"          $W
    menu_item "09" "🔑" "File Permissions Changer"   $W
    menu_item "10" "🔒" "Checksum Verifier"          $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"       $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1)
            sub_banner "FILE LIST"
            ls -lahF --color=always 2>/dev/null | while IFS= read -r line; do echo -e "    $line"; done
            go_back file_manager_menu ;;
        02|2)
            sub_banner "SEARCH FILE"
            echo -ne "    ${T_WARNING}Filename pattern: ${T_SUCCESS}"; read fname
            echo -ne "    ${T_WARNING}Search in (default .): ${T_SUCCESS}"; read sdir; echo -e "${RST}"
            sdir=${sdir:-.}
            spin "Searching..." 2 4
            find "$sdir" -iname "*$fname*" 2>/dev/null | head -30 | while IFS= read -r f; do
                echo -e "    ${T_SUCCESS}📄 ${WH}$f${RST}"
            done
            go_back file_manager_menu ;;
        03|3)
            sub_banner "SEARCH TEXT"
            echo -ne "    ${T_WARNING}Text to search: ${T_SUCCESS}"; read stext
            echo -ne "    ${T_WARNING}In directory (default .): ${T_SUCCESS}"; read sdir; echo -e "${RST}"
            sdir=${sdir:-.}
            spin "Searching..." 2 3
            grep -rl --color=always "$stext" "$sdir" 2>/dev/null | head -20 | while IFS= read -r f; do
                echo -e "    ${T_SUCCESS}📄 ${WH}$f${RST}"
            done
            go_back file_manager_menu ;;
        04|4)
            sub_banner "DISK USAGE"
            df -h 2>/dev/null | while IFS= read -r line; do echo -e "    ${T_INFO}$line${RST}"; done
            go_back file_manager_menu ;;
        05|5)
            sub_banner "TOP 20 SIZES"
            echo -ne "    ${T_WARNING}Path (default .): ${T_SUCCESS}"; read spath; echo -e "${RST}"
            spath=${spath:-.}
            du -sh "$spath"/* 2>/dev/null | sort -rh | head -20 | while IFS= read -r line; do
                echo -e "    ${T_SUCCESS}📊 ${WH}$line${RST}"
            done
            go_back file_manager_menu ;;
        06|6)
            sub_banner "URL DOWNLOADER"
            echo -ne "    ${T_WARNING}URL: ${T_SUCCESS}"; read dl_url
            echo -ne "    ${T_WARNING}Save as (leave empty for auto): ${T_SUCCESS}"; read dl_name
            echo -e "${RST}"
            [ -z "$dl_url" ] && { echo -e "    ${T_ERROR}[✗] URL kosong!${RST}"; sleep 1; file_manager_menu; return; }

            if [ -n "$dl_name" ]; then
                spin "Downloading..." 2 4
                wget -O "$dl_name" "$dl_url" 2>&1 | tail -3 | while IFS= read -r line; do echo -e "    ${T_INFO}$line${RST}"; done
            else
                spin "Downloading..." 2 4
                wget "$dl_url" 2>&1 | tail -3 | while IFS= read -r line; do echo -e "    ${T_INFO}$line${RST}"; done
            fi
            echo -e "    $(badge_ok) Download complete!"
            go_back file_manager_menu ;;
        07|7)
            sub_banner "FILE COMPRESSOR"
            echo -ne "    ${T_WARNING}File/Folder to compress: ${T_SUCCESS}"; read comp_src
            echo -ne "    ${T_WARNING}Output name (without .tar.gz): ${T_SUCCESS}"; read comp_out
            echo -e "${RST}"
            comp_out=${comp_out:-archive}
            spin "Compressing..." 2 8
            tar -czf "${comp_out}.tar.gz" "$comp_src" 2>/dev/null && {
                echo -e "    $(badge_ok) Created: ${WH}${comp_out}.tar.gz${RST}"
                echo -e "    ${T_MUTED}Size: $(du -h "${comp_out}.tar.gz" | cut -f1)${RST}"
            } || echo -e "    $(badge_fail) Compression failed!"
            go_back file_manager_menu ;;
        08|8)
            sub_banner "FILE DECOMPRESSOR"
            echo -ne "    ${T_WARNING}Archive file: ${T_SUCCESS}"; read dec_file
            echo -e "${RST}"
            if [ -f "$dec_file" ]; then
                spin "Decompressing..." 2 8
                case "$dec_file" in
                    *.tar.gz|*.tgz) tar -xzf "$dec_file" ;;
                    *.tar.bz2) tar -xjf "$dec_file" ;;
                    *.tar.xz) tar -xJf "$dec_file" ;;
                    *.zip) unzip "$dec_file" ;;
                    *.gz) gunzip "$dec_file" ;;
                    *) echo -e "    ${T_ERROR}Unsupported format${RST}" ;;
                esac
                echo -e "    $(badge_ok) Decompression complete!"
            else
                echo -e "    $(badge_fail) File not found!"
            fi
            go_back file_manager_menu ;;
        09|9)
            sub_banner "PERMISSIONS CHANGER"
            echo -ne "    ${T_WARNING}File/Folder: ${T_SUCCESS}"; read ppath
            echo -e "${RST}"
            if [ -e "$ppath" ]; then
                ls -la "$ppath" | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
                echo -ne "    ${T_WARNING}New permissions (e.g. 755): ${T_SUCCESS}"; read perms; echo -e "${RST}"
                [ -n "$perms" ] && chmod "$perms" "$ppath" 2>/dev/null && echo -e "    $(badge_ok) Updated!"
            else
                echo -e "    $(badge_fail) Not found!"
            fi
            go_back file_manager_menu ;;
        10)
            sub_banner "CHECKSUM VERIFIER"
            echo -ne "    ${T_WARNING}File path: ${T_SUCCESS}"; read ckfile; echo -e "${RST}"
            if [ -f "$ckfile" ]; then
                spin "Calculating checksums..." 1 3
                echo -e "    ${T_ACCENT}MD5:    ${WH}$(md5sum "$ckfile" | cut -d' ' -f1)${RST}"
                echo -e "    ${T_ACCENT}SHA1:   ${WH}$(sha1sum "$ckfile" | cut -d' ' -f1)${RST}"
                echo -e "    ${T_ACCENT}SHA256: ${WH}$(sha256sum "$ckfile" | cut -d' ' -f1)${RST}"
            else
                echo -e "    $(badge_fail) File not found!"
            fi
            go_back file_manager_menu ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; file_manager_menu ;;
    esac
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 09: CLEANER & OPTIMIZER
# ═══════════════════════════════════════════════════════════════

cleaner_menu() {
    sub_banner "🧹 CLEANER & OPTIMIZER"

    local W=52
    draw_box $W "CLEANUP TOOLS"
    draw_box_empty $W
    menu_item "01" "🗑️" " Clear APT Cache"           $W
    menu_item "02" "📁" "Clear Temp Files"            $W
    menu_item "03" "📦" "Remove Orphan Packages"      $W
    menu_item "04" "📜" "Clear Bash History"          $W
    menu_item "05" "🔥" "FULL DEEP CLEAN"             $W
    menu_item "06" "📊" "Storage Usage Report"        $W
    menu_item "07" "🔍" "Find Large Files (>10MB)"    $W
    menu_item "08" "📋" "Find Duplicate Files"        $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"        $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1)
            sub_banner "CLEAR APT CACHE"
            spin "Clearing APT cache..." 2 3
            apt clean 2>/dev/null
            rm -rf "$PREFIX/var/cache/apt/archives/"*.deb 2>/dev/null
            echo -e "    $(badge_ok) APT cache cleared!"
            go_back cleaner_menu ;;
        02|2)
            sub_banner "CLEAR TEMP"
            spin "Clearing temp files..." 2 8
            rm -rf "$TMPDIR/"* /tmp/* 2>/dev/null
            rm -rf "$HOME/.cache/"* 2>/dev/null
            echo -e "    $(badge_ok) Temp files cleared!"
            go_back cleaner_menu ;;
        03|3)
            sub_banner "REMOVE ORPHANS"
            spin "Removing orphan packages..." 2 6
            apt autoremove -y 2>/dev/null | tail -3 | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
            echo -e "    $(badge_ok) Done!"
            go_back cleaner_menu ;;
        04|4)
            sub_banner "CLEAR HISTORY"
            history -c 2>/dev/null
            > "$HOME/.bash_history" 2>/dev/null
            > "$HOME/.python_history" 2>/dev/null
            echo -e "    $(badge_ok) History cleared!"
            go_back cleaner_menu ;;
        05|5)
            sub_banner "FULL DEEP CLEAN"
            echo -e "    ${T_ERROR}${BLD}⚠️  This will clean everything!${RST}"
            echo -ne "    ${T_WARNING}Continue? [y/n]: ${T_SUCCESS}"; read confirm; echo -e "${RST}"
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                premium_bar "Cleaning APT cache" 1
                apt clean 2>/dev/null

                premium_bar "Removing orphans" 1
                apt autoremove -y &>/dev/null

                premium_bar "Clearing temp" 1
                rm -rf "$TMPDIR/"* /tmp/* "$HOME/.cache/"* 2>/dev/null

                premium_bar "Clearing history" 1
                history -c 2>/dev/null
                > "$HOME/.bash_history" 2>/dev/null

                premium_bar "Clearing thumbnails" 1
                rm -rf "$HOME/.thumbnails/"* 2>/dev/null

                premium_bar "Clearing logs" 1
                find "$PREFIX/var/log" -type f -name "*.log" -exec truncate -s 0 {} \; 2>/dev/null

                echo ""
                echo -e "    $(badge_ok) ${T_SUCCESS}${BLD}FULL DEEP CLEAN COMPLETE! 🧹${RST}"
                echo ""
                echo -e "    ${T_INFO}Disk after clean:${RST}"
                df -h / 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_SUCCESS}$l${RST}"; done
            fi
            go_back cleaner_menu ;;
        06|6)
            sub_banner "STORAGE REPORT"
            echo -e "    ${T_ACCENT}Top 15 folders by size:${RST}"
            echo ""
            du -sh "$PREFIX/"* 2>/dev/null | sort -rh | head -15 | while IFS= read -r l; do
                echo -e "    ${T_SUCCESS}📂 ${WH}$l${RST}"
            done
            echo ""
            echo -e "    ${T_ACCENT}Overall:${RST}"
            df -h 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}$l${RST}"; done
            go_back cleaner_menu ;;
        07|7)
            sub_banner "FIND LARGE FILES"
            echo -ne "    ${T_WARNING}Min size in MB (default 10): ${T_SUCCESS}"; read min_size; echo -e "${RST}"
            min_size=${min_size:-10}
            spin "Searching for files > ${min_size}MB..." 3 4
            find / -type f -size +${min_size}M 2>/dev/null | head -20 | while IFS= read -r f; do
                local fsize=$(du -h "$f" 2>/dev/null | cut -f1)
                echo -e "    ${T_WARNING}${fsize}${RST} ${T_INFO}${f}${RST}"
            done
            go_back cleaner_menu ;;
        08|8)
            sub_banner "FIND DUPLICATES"
            echo -ne "    ${T_WARNING}Directory (default .): ${T_SUCCESS}"; read dup_dir; echo -e "${RST}"
            dup_dir=${dup_dir:-.}
            spin "Scanning for duplicates..." 3 8
            find "$dup_dir" -type f -exec md5sum {} \; 2>/dev/null | sort | uniq -d -w32 | head -15 | while IFS= read -r l; do
                echo -e "    ${T_WARNING}⚠️ ${WH}$l${RST}"
            done
            go_back cleaner_menu ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; cleaner_menu ;;
    esac
}


# ═══════════════════════════════════════════════════════════════
#  MODULE 10: FUN & VISUAL EFFECTS LAB
# ═══════════════════════════════════════════════════════════════

fun_menu() {
    sub_banner "🎨 FUN & VISUAL EFFECTS LAB"

    local W=52
    draw_box $W "EFFECTS LAB"
    draw_box_empty $W
    menu_item "01" "🟩" "Matrix Digital Rain"        $W
    menu_item "02" "🌈" "256 Color Palette"          $W
    menu_item "03" "✨" "ASCII Art Generator"         $W
    menu_item "04" "📊" "Live System Monitor"        $W
    menu_item "05" "💬" "Random Quote Generator"     $W
    menu_item "06" "⏰" "Neon Clock"                 $W
    menu_item "07" "🔥" "Fire Text Effect"           $W
    menu_item "08" "🌀" "Particle Storm"             $W
    menu_item "09" "📈" "Gradient Text Generator"    $W
    menu_item "10" "👾" "Glitch Text Effect"         $W
    menu_item "11" "🎵" "Audio Visualizer (Fake)"    $W
    menu_item "12" "🌌" "Starfield Simulation"       $W
    draw_box_empty $W
    menu_item_red "00" "←" "Back to Main Menu"       $W
    draw_box_empty $W
    draw_box_bottom $W

    echo ""
    echo -ne "    ${T_PRIMARY}╰─${T_WARNING}⮞ ${T_SUCCESS}"
    read choice
    echo -e "${RST}"

    case $choice in
        01|1)
            sub_banner "MATRIX RAIN"
            echo -e "    ${T_INFO}Press Ctrl+C to stop${RST}"; sleep 1
            matrix_rain 8
            go_back fun_menu ;;
        02|2)
            sub_banner "256 COLOR PALETTE"
            echo ""
            echo -e "    ${T_ACCENT}Standard Colors (0-15):${RST}"
            echo -n "    "
            for i in $(seq 0 15); do
                printf "\033[48;5;${i}m  \033[0m"
            done
            echo ""
            echo ""
            echo -e "    ${T_ACCENT}Extended Colors (16-231):${RST}"
            for i in $(seq 16 231); do
                [ $(( (i-16) % 36 )) -eq 0 ] && echo -n "    "
                printf "\033[48;5;${i}m  \033[0m"
                [ $(( (i-16+1) % 36 )) -eq 0 ] && echo ""
            done
            echo ""
            echo -e "    ${T_ACCENT}Grayscale (232-255):${RST}"
            echo -n "    "
            for i in $(seq 232 255); do
                printf "\033[48;5;${i}m  \033[0m"
            done
            echo ""
            go_back fun_menu ;;
        03|3)
            sub_banner "ASCII ART"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read art_text; echo -e "${RST}"
            if [ -n "$art_text" ]; then
                if command -v figlet &>/dev/null; then
                    echo -e "    ${T_ACCENT}━━━ Standard ━━━${RST}"
                    figlet "$art_text" 2>/dev/null | while IFS= read -r l; do gradient_text "    $l"; done
                    if command -v toilet &>/dev/null; then
                        echo -e "    ${T_ACCENT}━━━ Future ━━━${RST}"
                        toilet -f future "$art_text" 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_PRIMARY}$l${RST}"; done
                        echo -e "    ${T_ACCENT}━━━ Mono12 ━━━${RST}"
                        toilet -f mono12 "$art_text" 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_SUCCESS}$l${RST}"; done
                    fi
                else
                    echo -e "    ${T_WARNING}Install figlet: pkg install figlet${RST}"
                fi
            fi
            go_back fun_menu ;;
        04|4)
            sub_banner "LIVE MONITOR"
            echo -e "    ${T_INFO}Monitoring... (15 cycles)${RST}"; sleep 1
            for ((i=0; i<15; i++)); do
                clear
                echo ""
                echo -e "    ${T_ACCENT}${BLD}◆ LIVE SYSTEM MONITOR ◆${RST}  ${T_MUTED}Cycle: $((i+1))/15${RST}"
                echo ""
                echo -e "    ${T_WARNING}⏰ ${WH}$(date '+%H:%M:%S')${RST}  ${T_WARNING}Up: ${WH}$(uptime -p 2>/dev/null | sed 's/up //')${RST}"
                echo ""
                echo -e "    ${T_ACCENT}Memory:${RST}"
                free -h 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}  $l${RST}"; done
                echo ""
                echo -e "    ${T_ACCENT}Disk:${RST}"
                df -h / 2>/dev/null | while IFS= read -r l; do echo -e "    ${T_INFO}  $l${RST}"; done
                sleep 2
            done
            go_back fun_menu ;;
        05|5)
            sub_banner "RANDOM QUOTE"
            spin "Fetching wisdom..." 2 6
            local quote=$(curl -s --max-time 5 "https://api.quotable.io/random" 2>/dev/null)
            local content=$(echo "$quote" | grep -o '"content":"[^"]*"' | cut -d'"' -f4)
            local author=$(echo "$quote" | grep -o '"author":"[^"]*"' | cut -d'"' -f4)

            local W=52
            draw_box $W "💬 QUOTE"
            draw_box_empty $W
            if [ -n "$content" ]; then
                echo "$content" | fold -s -w 44 | while IFS= read -r l; do
                    draw_box_line $W "  ${T_INFO}\"${l}\"${RST}"
                done
                draw_box_line $W ""
                draw_box_line $W "  ${T_ACCENT}— ${author}${RST}"
            else
                draw_box_line $W "  ${T_INFO}\"The best time to plant a tree was 20${RST}"
                draw_box_line $W "  ${T_INFO}years ago. The second best time is now.\"${RST}"
                draw_box_line $W "  ${T_ACCENT}— Chinese Proverb${RST}"
            fi
            draw_box_empty $W
            draw_box_bottom $W
            go_back fun_menu ;;
        06|6)
            sub_banner "NEON CLOCK"
            echo -e "    ${T_INFO}Press Ctrl+C to stop${RST}"; sleep 1
            for ((i=0; i<20; i++)); do
                clear
                echo ""; echo ""; echo ""
                if command -v figlet &>/dev/null; then
                    figlet -c "$(date '+%H : %M : %S')" 2>/dev/null | while IFS= read -r l; do
                        gradient_text "  $l" 0 200 255 255 50 200
                    done
                else
                    center_text "${BLD}\033[38;5;51m$(date '+%H : %M : %S')${RST}"
                fi
                echo ""
                center_text "${T_MUTED}$(date '+%A, %d %B %Y')${RST}"
                sleep 1
            done
            go_back fun_menu ;;
        07|7)
            sub_banner "FIRE TEXT"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read ft; echo -e "${RST}"
            [ -n "$ft" ] && for ((x=0; x<5; x++)); do fire_text "$ft"; sleep 0.3; done
            go_back fun_menu ;;
        08|8)
            sub_banner "PARTICLE STORM"
            echo -e "    ${T_INFO}Press Ctrl+C to stop${RST}"; sleep 1
            particle_effect 5
            go_back fun_menu ;;
        09|9)
            sub_banner "GRADIENT TEXT"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read gt; echo -e "${RST}"
            [ -n "$gt" ] && {
                echo ""
                gradient_text "    $gt" 255 0 0 0 0 255
                gradient_text "    $gt" 255 100 0 0 255 100
                gradient_text "    $gt" 200 0 255 0 255 200
                gradient_text "    $gt" 255 255 0 255 0 255
                gradient_text "    $gt" 0 255 255 255 0 128
            }
            go_back fun_menu ;;
        10)
            sub_banner "GLITCH TEXT"
            echo -ne "    ${T_WARNING}Text: ${T_SUCCESS}"; read glt; echo -e "${RST}"
            [ -n "$glt" ] && for ((x=0; x<3; x++)); do glitch_effect "$glt" 8; sleep 0.5; done
            go_back fun_menu ;;
        11)
            sub_banner "AUDIO VISUALIZER"
            echo -e "    ${T_INFO}Simulating audio... Ctrl+C to stop${RST}"; sleep 1
            for ((i=0; i<30; i++)); do
                echo -ne "\r    "
                for ((b=0; b<20; b++)); do
                    local h=$((RANDOM % 8 + 1))
                    local bar=""
                    for ((v=0; v<h; v++)); do bar+="█"; done
                    local colors=(196 208 226 46 39 171 213 87)
                    echo -ne "\033[38;5;${colors[$((b % 8))]}m${bar}$(printf '%*s' $((8-h)) '')"
                done
                echo -ne "${RST}"
                sleep 0.15
            done
            echo ""
            go_back fun_menu ;;
        12)
            sub_banner "STARFIELD"
            echo -e "    ${T_INFO}Warping through space... Ctrl+C to stop${RST}"; sleep 1
            local end_time=$((SECONDS + 5))
            while [ $SECONDS -lt $end_time ]; do
                local line="    "
                for ((c=0; c<50; c++)); do
                    local r=$((RANDOM % 12))
                    if [ $r -eq 0 ]; then line+="\033[1;37m★"
                    elif [ $r -eq 1 ]; then line+="\033[38;5;226m✦"
                    elif [ $r -eq 2 ]; then line+="\033[38;5;87m·"
                    elif [ $r -eq 3 ]; then line+="\033[38;5;245m."
                    else line+=" "
                    fi
                done
                echo -e "${line}${RST}"
                sleep 0.08
            done
            go_back fun_menu ;;
        00|0) main_menu ;;
        *) echo -e "    ${T_ERROR}[✗] Invalid!${RST}"; sleep 1; fun_menu ;;
    esac
}

# ═══════════════════════════════════════════════════════════════
#  Module loaded confirmation (silent)
# ═══════════════════════════════════════════════════════════════
log_msg "kyy-modules.sh loaded successfully"
