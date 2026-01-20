<#
.SYNOPSIS
    Detects potential residential proxy software locally and scans the network for proxy ports.
.DESCRIPTION
    1. Checks local running processes for known proxyware (Honeygain, PacketStream, etc.).
    2. Wraps Nmap to scan the network for common proxy ports (HTTP, SOCKS, Squid).
#>

param (
    [string]$TargetNetwork = "192.168.1.0/24" # CHANGE THIS to your network subnet
)

# --- PART 1: Local Endpoint Check ---
Write-Host "--- Checking Local System for Proxyware Processes ---" -ForegroundColor Cyan
$proxyApps = @("Honeygain", "PacketStream", "IPRoyal", "Pawns", "EarnApp", "Peer2Profit", "Traffmonetizer")
$found = $false

foreach ($app in $proxyApps) {
    if (Get-Process | Where-Object { $_.ProcessName -like "*$app*" }) {
        Write-Host "[ALERT] Found potential proxy process: $app" -ForegroundColor Red
        $found = $true
    }
}
if (-not $found) { Write-Host "No common proxyware processes found locally." -ForegroundColor Green }

# --- PART 2: Network Scan with Nmap ---
Write-Host "`n--- Starting Network Proxy Scan on $TargetNetwork ---" -ForegroundColor Cyan
if (-not (Get-Command "nmap" -ErrorAction SilentlyContinue)) {
    Write-Error "Nmap is not installed or not in PATH. Please run 'winget install Insecure.Nmap' and restart PowerShell."
    exit
}

# Common Proxy Ports: 
# 1080 (SOCKS), 3128 (Squid), 8080 (HTTP Alt), 8118 (Privoxy), 9050 (Tor), 4444 (Metasploit/Proxy)
$ports = "1080,3128,8000,8080,8118,8123,8888,9050,9051,4444"

# Run Nmap: -sV (Version Detect) --open (Only show open ports) -T4 (Fast)
nmap -p $ports --open -sV $TargetNetwork | Out-String | Write-Host