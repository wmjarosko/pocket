# Pocket Scripts

A collection of portable "pocket" scripts for remote administration, tool installation, and network security tasks. These scripts are designed to be easily deployed and run on Windows and Linux systems to perform quick checks or installations.

## Scripts

### Proxy Detection & Network Scanning

These scripts help identify potential residential proxy software running locally and scan the network for common ports associated with proxy services.

*   **`detect_proxies.ps1` (Windows)**
    *   **Features:**
        *   Checks for known proxyware processes (e.g., Honeygain, PacketStream).
        *   **Auto-detects** the active IPv4 network subnet.
        *   Scans the subnet for common proxy ports using Nmap.
    *   **Usage:**
        ```powershell
        .\detect_proxies.ps1
        # Or specify a target manually:
        .\detect_proxies.ps1 -TargetNetwork "192.168.50.0/24"
        ```

*   **`detect_proxies.sh` (Linux)**
    *   **Features:**
        *   Checks for known proxyware processes.
        *   Scans a configured target network for proxy ports using Nmap.
    *   **Usage:**
        *   Edit the `TARGET_NET` variable in the script to match your network.
        ```bash
        chmod +x detect_proxies.sh
        ./detect_proxies.sh
        ```

### Tool Installation

Helper scripts to quickly install essential tools like Nmap.

*   **`inst_nMap.ps1` (Windows)**
    *   **Features:**
        *   Checks if Nmap is already installed.
        *   Prioritizes **Chocolatey** if available.
        *   Falls back to **Winget** if Chocolatey is missing.
    *   **Usage:**
        ```powershell
        .\inst_nMap.ps1
        ```

*   **`inst_nmap.sh` (Linux)**
    *   **Features:**
        *   Checks if Nmap is already installed.
        *   **Auto-detects** the Linux distribution (Debian/Ubuntu, RHEL/Fedora/CentOS, Arch, OpenSUSE).
        *   Uses the appropriate package manager (`apt`, `dnf`/`yum`, `pacman`, `zypper`) to install Nmap.
    *   **Usage:**
        ```bash
        chmod +x inst_nmap.sh
        sudo ./inst_nmap.sh
        ```
