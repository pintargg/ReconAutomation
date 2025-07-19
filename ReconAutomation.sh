#!/bin/bash
# Usage: ./ReconAutomation.sh example.com

domain=$1

if [ -z "$domain" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

mkdir -p recon/$domain
cd recon/$domain

echo "[*] Starting Recon on $domain"
echo "[*] Timestamp: $(date)"

# 1. Subdomain Enumeration
echo "[+] Running subfinder..."
subfinder -d $domain -silent > subfinder.txt

echo "[+] Running assetfinder..."
assetfinder --subs-only $domain | tee -a subfinder.txt

echo "[+] Running amass passive..."
amass enum -passive -d $domain >> subfinder.txt

sort -u subfinder.txt > subs.txt

# 2. Probing for alive hosts
echo "[+] Probing alive hosts with httpx..."
cat subs.txt | httpx -silent -threads 100 > alive.txt

# 3. DNS Resolution
echo "[+] Resolving DNS with massdns..."
cat subs.txt | massdns -r /usr/share/dnsutils/resolvers.txt -t A -o S -w massdns.txt

# 4. Subdomain takeover checks
echo "[+] Checking subdomain takeover with subjack & subzy..."
subjack -w alive.txt -t 100 -timeout 30 -ssl -c /path/to/fingerprints.json -v 3 -o subjack.txt
subzy run --targets alive.txt --hide_fails -o subzy.txt

# 5. Historical URLs
echo "[+] Collecting historical URLs (waybackurls + gau)..."
cat subs.txt | waybackurls >> waybackurls.txt
cat subs.txt | gau >> gau.txt

sort -u waybackurls.txt gau.txt > allurls.txt

# 6. Endpoint Analysis
echo "[+] Unfurling endpoints..."
cat allurls.txt | unfurl --unique keys > params.txt

echo "[+] Feeding JS into endpoint testing..."
cat allurls.txt | grep ".js$" | httpx -threads 50 -silent | tee jsfiles.txt
for js in $(cat jsfiles.txt); do
    python3 /opt/SecretFinder/SecretFinder.py -i $js -o cli >> secretfinder.txt
done

# 7. Nuclei Scanning
echo "[+] Running Nuclei..."
nuclei -l alive.txt -t /path/to/nuclei-templates/ -severity high,critical -o nuclei.txt

# 8. Directory fuzzing
echo "[+] Fuzzing directories with ffuf..."
for url in $(cat alive.txt); do
    ffuf -u $url/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -mc 200,403 -o ffuf_${url//\//_}.json
done

# 9. crt.sh scraping
echo "[+] Scraping crt.sh..."
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> crtsh.txt

# 10. ShuffleDNS brute-forcing
echo "[+] Running shuffledns..."
shuffledns -d $domain -w /usr/share/wordlists/subdomains.txt -r /usr/share/dnsutils/resolvers.txt -o shuffledns.txt

# 11. Build Asset Graphs
echo "[+] Building asset graphs (cytoscape ready)..."
cat alive.txt | awk -F/ '{print $3}' | sort -u | tee assets.txt

# Final Output Summary
echo "[*] Recon Complete!"
echo "Results saved in recon/$domain/"
ls -lah

