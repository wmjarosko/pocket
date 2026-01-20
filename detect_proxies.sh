#!/bin/bash

# Configuration
# Automatic network detection
if command -v ip &> /dev/null; then
    # Try to find default interface
    DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

    if [ -z "$DEFAULT_IFACE" ]; then
        # Fallback to first non-loopback interface
        TARGET_NET=$(ip -o -f inet addr show | awk '$2 !~ /^lo/ {print $4}' | head -n 1)
    else
        TARGET_NET=$(ip -o -f inet addr show "$DEFAULT_IFACE" | awk '{print $4}' | head -n 1)
    fi
else
    echo "[!] 'ip' command not found. Cannot automatically detect network."
fi

# Fallback if detection failed
if [ -z "$TARGET_NET" ]; then
    echo "[!] Could not detect network subnet. Defaulting to 192.168.1.0/24"
    TARGET_NET="192.168.1.0/24"
else
    echo "[+] Detected network: $TARGET_NET"
fi

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