#!/data/data/com.termux/files/usr/bin/bash

# ╔══════════════════════════════════════════════╗
# ║  KyyInfinite Python Bridge                   ║
# ║  Connects kyy_engine.py to bash framework    ║
# ╚══════════════════════════════════════════════╝

if [ -z "$VERSION" ]; then
    echo "[!] Source from kyy-core.sh"
    exit 1
fi

PYTHON_ENGINE="${SCRIPT_DIR}/kyy_engine.py"

check_python_engine() {
    if [ ! -f "$PYTHON_ENGINE" ]; then
        echo -e "    ${T_ERROR}[✗] kyy_engine.py not found!${RST}"
        echo -e "    ${T_MUTED}Place it in: ${T_INFO}${SCRIPT_DIR}/${RST}"
        return 1
    fi
    if ! command -v python3 &>/dev/null; then
        echo -e "    ${T_ERROR}[✗] Python3 not installed!${RST}"
        echo -e "    ${T_MUTED}Install: pkg install python${RST}"
        return 1
    fi
    return 0
}

python_tools_menu() {
    check_python_engine || { go_back main_menu; return; }
    python3 "$PYTHON_ENGINE" menu
    main_menu
}

run_py_tool() {
    check_python_engine || return
    python3 "$PYTHON_ENGINE" "$1"
    echo ""
    echo -ne "    ${T_WARNING}Press [ENTER]...${RST}"
    read
}

py_instagram()     { run_py_tool 1; }
py_email_breach()  { run_py_tool 2; }
py_google_dork()   { run_py_tool 3; }
py_web_crawler()   { run_py_tool 4; }
py_exif()          { run_py_tool 5; }
py_admin_finder()  { run_py_tool 6; }
py_hash_crack()    { run_py_tool 7; }
py_revshell()      { run_py_tool 8; }
py_fake_id()       { run_py_tool 9; }
py_crypto()        { run_py_tool 10; }
py_stego()         { run_py_tool 11; }
py_api_test()      { run_py_tool 12; }

log_msg "kyy-pymodules.sh loaded"
