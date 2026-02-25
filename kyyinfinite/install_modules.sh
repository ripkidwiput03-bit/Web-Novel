#!/data/data/com.termux/files/usr/bin/bash

# ═══════════════════════════════════════════════════════
# KYYINFINITE HACKER MODULE - INSTALLER SCRIPT
# ONE-CLICK INSTALLATION FOR TERMUX
# ═══════════════════════════════════════════════════════

clear
echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     KyyInfinite Hacker Module Installer         ║"
echo "║              v3.0 - 2024                         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "⚠️  DISCLAIMER: Untuk authorized pentesting saja!"
echo ""

# Check if in correct directory
if [ ! -f "kyy-core.sh" ]; then
    echo "❌ ERROR: kyy-core.sh tidak ditemukan!"
    echo "   Pastikan Anda berada di folder ~/kyyinfinite"
    echo ""
    echo "   Jalankan: cd ~/kyyinfinite"
    exit 1
fi

echo "📁 Working directory: $(pwd)"
echo ""

# Step 1: Check if kyy_hacker.py exists
echo "════════════════════════════════════════════════════"
echo " STEP 1: Check kyy_hacker.py"
echo "════════════════════════════════════════════════════"

if [ -f "kyy_hacker.py" ]; then
    lines=$(wc -l < kyy_hacker.py)
    echo "✅ kyy_hacker.py found ($lines lines)"
    
    if [ "$lines" -lt 1000 ]; then
        echo "⚠️  WARNING: File tampaknya tidak lengkap!"
        echo "   Expected: ~1192 lines"
        echo "   Found: $lines lines"
        echo ""
        echo "   Apakah ingin melanjutkan? (y/n)"
        read -r answer
        if [ "$answer" != "y" ]; then
            echo "Installation dibatalkan."
            exit 1
        fi
    fi
else
    echo "❌ kyy_hacker.py TIDAK DITEMUKAN!"
    echo ""
    echo "   Silakan download atau copy file kyy_hacker.py terlebih dahulu"
    echo "   ke folder ~/kyyinfinite"
    echo ""
    echo "   Download dari file yang di-share atau gunakan:"
    echo "   cp /path/to/kyy_hacker.py ~/kyyinfinite/"
    echo ""
    exit 1
fi

# Make executable
chmod +x kyy_hacker.py
echo "✅ Set executable permission"
echo ""

# Step 2: Create kyy-hackmod.sh
echo "════════════════════════════════════════════════════"
echo " STEP 2: Create kyy-hackmod.sh"
echo "════════════════════════════════════════════════════"

if [ -f "kyy-hackmod.sh" ]; then
    echo "⏭️  kyy-hackmod.sh sudah ada, akan di-overwrite..."
fi

cat > kyy-hackmod.sh << 'HACKBRIDGE'
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
HACKBRIDGE

chmod +x kyy-hackmod.sh
echo "✅ kyy-hackmod.sh created"
echo ""

# Step 3: Patch kyy-core.sh
echo "════════════════════════════════════════════════════"
echo " STEP 3: Patch kyy-core.sh"
echo "════════════════════════════════════════════════════"

# Create patch script
cat > /tmp/patch_hacker.py << 'PATCHPY'
fp = 'kyy-core.sh'
with open(fp, 'r') as f:
    c = f.read()

modified = False

# Add source hackmod
if 'kyy-hackmod.sh' not in c:
    c = c.replace(
        'if [ -f "$pymodules_file" ]; then\n        source "$pymodules_file"\n    fi',
        'if [ -f "$pymodules_file" ]; then\n        source "$pymodules_file"\n    fi\n    local hackmod_file="${SCRIPT_DIR}/kyy-hackmod.sh"\n    if [ -f "$hackmod_file" ]; then\n        source "$hackmod_file"\n    fi'
    )
    print("✅ Added hackmod source")
    modified = True

# Add menu item 12
if 'Hacker Module' not in c:
    marker = 'Python Advanced Tools'
    lines = c.split('\n')
    new = []
    for line in lines:
        new.append(line)
        if marker in line:
            cv = '${WH}' if '${WH}' in line else '${W}'
            new.append(f'    echo -e "    ${{T_BORDER}}║${{RST}}  ${{T_SUCCESS}}[{cv}${{BLD}}12${{RST}}${{T_SUCCESS}}]${{RST}} ☠️  ${{T_INFO}}Hacker Module (Pentesting)${{RST}} $(badge_new) ${{T_BORDER}}║${{RST}}"')
    c = '\n'.join(new)
    print("✅ Added menu [12]")
    modified = True

# Add case 12
if 'hacker_menu' not in c:
    c = c.replace(
        '11)    source_and_run "python_tools_menu" ;;',
        '11)    source_and_run "python_tools_menu" ;;\n        12)    source_and_run "hacker_menu" ;;'
    )
    c = c.replace('01-11', '01-12')
    print("✅ Added case 12")
    modified = True

if modified:
    import shutil
    shutil.copy2(fp, fp + '.backup')
    with open(fp, 'w') as f:
        f.write(c)
    print(f"📁 Backup: {fp}.backup")

exit(0 if modified else 10)
PATCHPY

python3 /tmp/patch_hacker.py
patch_status=$?

if [ $patch_status -eq 0 ]; then
    echo "✅ kyy-core.sh successfully patched!"
elif [ $patch_status -eq 10 ]; then
    echo "✅ kyy-core.sh already patched"
else
    echo "⚠️  Warning: Patch may have issues"
fi

rm -f /tmp/patch_hacker.py
echo ""

# Final summary
echo "════════════════════════════════════════════════════"
echo " ✅ INSTALLATION COMPLETE!"
echo "════════════════════════════════════════════════════"
echo ""
echo "📁 Files installed:"
echo "   ✓ kyy_hacker.py      ($(wc -l < kyy_hacker.py) lines)"
echo "   ✓ kyy-hackmod.sh     (bridge file)"
echo "   ✓ kyy-core.sh        (patched)"
echo ""
echo "🎯 TOOLS INCLUDED:"
echo "   [01] 💉 SQL Injection Scanner"
echo "   [02] ⚡ XSS Vulnerability Scanner"
echo "   [03] 📂 Directory Bruteforcer"
echo "   [04] 🏴 Subdomain Takeover Checker"
echo "   [05] 🛡️  WAF Detector"
echo "   [06] 📄 LFI/RFI Scanner"
echo "   [07] 💣 Payload Generator"
echo "   [08] 🔍 CMS Vulnerability Scanner"
echo "   [09] 🔨 HTTP Login Brute Force"
echo "   [10] 🔬 Network Vulnerability Scanner"
echo ""
echo "▶️  HOW TO RUN:"
echo "   bash kyy-core.sh"
echo "   → Select [12] Hacker Module"
echo ""
echo "   OR run directly:"
echo "   python3 kyy_hacker.py"
echo ""
echo "⚠️  REMEMBER: Untuk authorized testing saja!"
echo "   Penggunaan ilegal = tindakan kriminal"
echo ""
