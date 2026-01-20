#!/bin/bash

# Check if nmap is already installed
if command -v nmap >/dev/null 2>&1; then
    echo "Nmap is already installed."
    exit 0
fi

echo "Nmap not found. Detecting distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    LIKE=$ID_LIKE
else
    echo "Cannot detect distribution via /etc/os-release."
    exit 1
fi

echo "Detected OS: $OS"

if [[ "$OS" == "ubuntu" || "$OS" == "debian" || "$OS" == "kali" || "$LIKE" == *"debian"* ]]; then
    echo "Installing for Debian/Ubuntu based systems..."
    sudo apt update && sudo apt install nmap -y
elif [[ "$OS" == "fedora" || "$OS" == "rhel" || "$OS" == "centos" || "$LIKE" == *"rhel"* || "$LIKE" == *"fedora"* ]]; then
    echo "Installing for RHEL/Fedora based systems..."
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install nmap -y
    else
        sudo yum install nmap -y
    fi
elif [[ "$OS" == "arch" || "$LIKE" == *"arch"* ]]; then
    echo "Installing for Arch Linux..."
    sudo pacman -S nmap --noconfirm
elif [[ "$OS" == "opensuse"* || "$OS" == "sles" || "$LIKE" == *"suse"* ]]; then
    echo "Installing for SUSE..."
    sudo zypper install nmap -y
else
    echo "Unsupported distribution: $OS"
    echo "Please install nmap manually."
    exit 1
fi
