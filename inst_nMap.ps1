if (Get-Command nmap -ErrorAction SilentlyContinue) {
    Write-Host "Nmap is already installed."
    Read-Host "Press Enter to exit..."
    exit
}

if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey detected. Installing nmap via Chocolatey..."
    choco install nmap -y
} else {
    Write-Host "Chocolatey not found. Installing nmap via Winget..."
    winget install Insecure.Nmap
}
