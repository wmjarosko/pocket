#!/bin/bash

# Configuration
TARGET_NET="192.168.1.0/24" # CHANGE THIS to your network subnet
PROXY_PORTS="1080,3128,8000,8080,8118,8123,8888,9050,9051,4444"
KNOWN_APPS="honeygain|packetstream|iproyal|pawns|earnapp|peer2profit"

echo "=========================================="
echo "   Residential Proxy Detection Suite"
echo "=========================================="

# --- PART 1: Local Check ---
echo "[*] Checking local processes for known proxyware..."
if pgrep -f -i "$KNOWN_APPS" > /dev/null; then
    echo "[!] ALERT: Potential proxy software running on this machine!"
    pgrep -a -f -i "$KNOWN_APPS"
else
    echo "[+] No common proxy processes found locally."
fi

# --- PART 2: Network Scan ---
echo ""
echo "[*] Checking for Nmap..."
if ! command -v nmap &> /dev/null; then
    echo "[X] Nmap could not be found. Please install it first."
    exit 1
fi

echo "[*] Scanning network $TARGET_NET for open proxy ports ($PROXY_PORTS)..."
# -sS: SYN Scan (Stealthy)
# -sV: Version detection (identifies if it's actually a proxy)
# -n: No DNS resolution (faster)
sudo nmap -sS -sV -n -p "$PROXY_PORTS" --open "$TARGET_NET"