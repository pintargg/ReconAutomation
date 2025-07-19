#!/bin/bash

echo "[*] Installing dependencies for ReconYuuki..."
sudo apt update && sudo apt install -y golang python3 python3-pip jq git curl

tools=(subfinder httpx nuclei massdns assetfinder waybackurls unfurl subjack subzy ffuf shuffledns gau amass)

for tool in "${tools[@]}"; do
    echo "[*] Installing $tool..."
    go install github.com/projectdiscovery/$tool/v2/cmd/$tool@latest
done

echo "[*] Cloning SecretFinder..."
git clone https://github.com/m4ll0k/SecretFinder.git /opt/SecretFinder
pip3 install -r /opt/SecretFinder/requirements.txt

echo "[*] All tools installed! Add GOPATH/bin to your PATH if needed."
