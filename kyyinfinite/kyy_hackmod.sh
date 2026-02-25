#!/data/data/com.termux/files/usr/bin/bash
if [ -z "$VERSION" ]; then echo "[!] Source from kyy-core.sh"; exit 1; fi

HACKER_ENGINE="${SCRIPT_DIR}/kyy_hacker.py"

hacker_menu() {
    if [ ! -f "$HACKER_ENGINE" ]; then
        echo -e "    ${T_ERROR}[✗] kyy_hacker.py not found!${RST}"
        go_back main_menu; return
    fi
    python3 "$HACKER_ENGINE" menu
    main_menu
}

log_msg "kyy-hackmod.sh loaded"
