#!/usr/bin/env python3
# Patch kyy-core.sh untuk menambah Hacker Module

fp = 'kyy-core.sh'

try:
    with open(fp, 'r') as f:
        c = f.read()
except FileNotFoundError:
    print("❌ ERROR: kyy-core.sh tidak ditemukan!")
    print("   Pastikan Anda menjalankan script ini di folder ~/kyyinfinite")
    exit(1)

modified = False

# Add source hackmod
if 'kyy-hackmod.sh' not in c:
    c = c.replace(
        'if [ -f "$pymodules_file" ]; then\n        source "$pymodules_file"\n    fi',
        'if [ -f "$pymodules_file" ]; then\n        source "$pymodules_file"\n    fi\n    local hackmod_file="${SCRIPT_DIR}/kyy-hackmod.sh"\n    if [ -f "$hackmod_file" ]; then\n        source "$hackmod_file"\n    fi'
    )
    print("✅ Added hackmod source")
    modified = True
else:
    print("⏭️  Hackmod source already exists")

# Add menu item 12
if 'Hacker Module' not in c:
    marker = 'Python Advanced Tools'
    lines = c.split('\n')
    new = []
    for line in lines:
        new.append(line)
        if marker in line:
            if '${WH}' in line:
                cv = '${WH}'
            else:
                cv = '${W}'
            new.append(f'    echo -e "    ${{T_BORDER}}║${{RST}}  ${{T_SUCCESS}}[{cv}${{BLD}}12${{RST}}${{T_SUCCESS}}]${{RST}} ☠️  ${{T_INFO}}Hacker Module (Pentesting)${{RST}} $(badge_new) ${{T_BORDER}}║${{RST}}"')
    c = '\n'.join(new)
    print("✅ Added menu [12] Hacker Module")
    modified = True
else:
    print("⏭️  Menu [12] already exists")

# Add case 12
if 'hacker_menu' not in c:
    c = c.replace(
        '11)    source_and_run "python_tools_menu" ;;',
        '11)    source_and_run "python_tools_menu" ;;\n        12)    source_and_run "hacker_menu" ;;'
    )
    c = c.replace('01-11', '01-12')
    print("✅ Added case 12 handler")
    modified = True
else:
    print("⏭️  Case 12 already exists")

if modified:
    # Backup original
    import shutil
    backup = fp + '.backup'
    shutil.copy2(fp, backup)
    print(f"📁 Backup created: {backup}")
    
    # Write patched version
    with open(fp, 'w') as f:
        f.write(c)
    print("✅ kyy-core.sh successfully patched!")
else:
    print("✅ kyy-core.sh already fully patched - no changes needed")

print("")
print("╔══════════════════════════════════════════════════╗")
print("║  ✅ PATCH COMPLETE!                             ║")
print("╚══════════════════════════════════════════════════╝")
print("")
print("Next steps:")
print("1. Run: bash kyy-core.sh")
print("2. Select [12] Hacker Module")
print("")
