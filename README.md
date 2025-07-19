# ReconAutomation
This is a recon tool that is made to run all recon methods automatically and this tool also has the following features: 1. "FEEDS JAVASCRIPT INTO ENDPOINT TESTING" 2. "CROSS-REFERENCES WAYBACK DATA" 3. "BUILT ASSET GRAPHS"

To run the program, you need to install several tools first. To do this, run all this program: 

```bash
sudo apt install subfinder httpx nuclei massdns assetfinder \
waybackurls unfurl subjack subzy ffuf shuffledns gau amass jq curl python3-pip
git clone https://github.com/m4ll0k/SecretFinder.git /opt/SecretFinder
pip3 install -r /opt/SecretFinder/requirements.txt

# Recon

Ultimate Recon Automation Framework - One Command, Complete Recon.

## 🚀 Features
- Subdomain enumeration (subfinder, amass, assetfinder, crt.sh)
- Alive host detection (httpx)
- DNS resolution (massdns, shuffledns)
- Subdomain takeover check (subjack, subzy)
- Historical URL fetching (waybackurls, gau)
- JS endpoint testing (SecretFinder)
- Vulnerability scanning (nuclei)
- Directory fuzzing (ffuf)
- Asset graph creation

## 🛠️ Installation
```bash
git clone https://github.com/pintargg/ReconAutomation.git
cd Reconautomation
bash install.sh

##
# Usage
chmod +x ReconAutomation.sh
./ReconAutomation.sh example.com

# DISCLAMER
This project has just been created and may still have some issues that need to be fixed, so it is still alpha.
