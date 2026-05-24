# 🪟 WSL Guide Ubuntu on Windows, Done Right

> The best of both worlds: Windows for hardware/drivers/Office, Linux for development. No dual-boot, no VM overhead.

---

## Why WSL + Ubuntu?

| Concern | Dual Boot | VM | WSL2 |
|---------|-----------|-----|------|
| Startup time | Reboot required | 30-60s boot | 1-2s |
| RAM overhead | N/A | 2-4GB reserved | Dynamic (returns unused) |
| File system speed | Native | Slow (shared folders) | Native ext4 |
| GPU access | Full | Limited | CUDA/DirectX supported |
| USB passthrough | Full | Requires config | USB/IP supported |
| Windows integration | None | Clipboard only | Full (file access, networking) |

**WSL2 gives you a real Linux kernel** not emulation, not translation. It's a lightweight VM managed by Windows that starts instantly and shares resources dynamically.

---

## 🚀 Installation

### Fresh Install (Windows 11 / Windows 10 2004+)

```powershell
# PowerShell (Admin)
wsl --install -d Ubuntu-22.04
```

That's it. Reboot, set username/password, done.

### Install Specific LTS Version

```powershell
# List available distros
wsl --list --online

# Install Ubuntu 24.04
wsl --install -d Ubuntu-24.04
```

### Verify WSL2 (not WSL1)

```powershell
wsl --list --verbose
# Should show VERSION: 2
```

If it shows 1:
```powershell
wsl --set-version Ubuntu-22.04 2
```

---

## ⚙️ Essential Configuration

### `.wslconfig` (Windows-side, global)

Create `C:\Users\<YourName>\.wslconfig`:

```ini
[wsl2]
memory=8GB              # Limit RAM (default: 50% of host)
processors=4            # Limit CPU cores
swap=4GB                # Swap size
localhostForwarding=true

[experimental]
autoMemoryReclaim=gradual   # Return unused RAM to Windows
sparseVhd=true              # Compact disk automatically
```

### `wsl.conf` (Linux-side, per-distro)

Edit `/etc/wsl.conf`:

```ini
[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"

[network]
generateResolvConf=true
hostname=dev-machine

[interop]
enabled=true            # Run Windows executables from Linux
appendWindowsPath=false # Don't pollute Linux PATH with Windows paths

[boot]
systemd=true            # Enable systemd (required for Docker, services)
```

After editing, restart WSL:
```powershell
wsl --shutdown
```

---

## 📁 File System The Golden Rule

> **Never cross the boundary for heavy I/O.**

| Location | Speed | Use For |
|----------|-------|---------|
| `~/` (Linux fs) | Fast (native ext4) | All source code, builds, git repos |
| `/mnt/c/` (Windows fs) | Slow (9p protocol) | Accessing Windows files occasionally |

```bash
# GOOD: Clone repos into Linux filesystem
cd ~
git clone https://github.com/your/project.git

# BAD: Working in /mnt/c/Users/you/projects
# This is 5-10x slower for git, builds, and file watchers
```

### Accessing Linux Files from Windows

In Windows Explorer, navigate to:
```
\\wsl$\Ubuntu-22.04\home\yourusername
```

Or pin it to Quick Access.

---

## 🐳 Docker in WSL

### Option 1: Docker Desktop (Easy)

Install Docker Desktop for Windows → Settings → Resources → WSL Integration → Enable for your distro.

### Option 2: Native Docker in WSL (Lighter, No Desktop App)

```bash
# Ensure systemd is enabled (wsl.conf above)
sudo apt update
sudo apt install docker.io docker-compose
sudo usermod -aG docker $USER

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Verify
docker run hello-world
```

### Anecdote
> *"Docker Desktop on Windows eats 2GB RAM just sitting there. Native Docker in WSL uses ~50MB idle. If you don't need the GUI dashboard, go native."*

---

## 🔌 USB Passthrough (Serial Ports, JTAG)

WSL2 doesn't natively see USB devices. Use `usbipd-win`:

### Setup

```powershell
# PowerShell (Admin) Install on Windows
winget install usbipd
```

```bash
# Inside WSL Install client
sudo apt install linux-tools-generic hwdata
sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/*-generic/usbip 20
```

### Usage

```powershell
# List USB devices (PowerShell)
usbipd list

# Attach device to WSL (use BUSID from list)
usbipd bind --busid 1-3
usbipd attach --wsl --busid 1-3
```

```bash
# Verify in WSL
lsusb
# You should see your device (ST-Link, FTDI, etc.)

# Access serial port
ls /dev/ttyUSB*
minicom -D /dev/ttyUSB0 -b 115200
```

### Anecdote
> *"The first time I flashed an STM32 from WSL via OpenOCD with USB passthrough, I felt like I'd cheated the system. Full embedded development workflow no Linux partition, no VM, no rebooting. Just Windows Terminal + WSL."*

---

## 🖥️ GUI Applications

WSL2 supports Linux GUI apps natively (WSLg):

```bash
# These just work they open as Windows windows
firefox &
nautilus &
code .          # VS Code (installs Remote-WSL automatically)
```

For X11 apps that need more control:
```bash
# Already works out of the box on Windows 11
# On Windows 10, you may need an X server (VcXsrv)
export DISPLAY=:0
```

---

## 🛠️ Development Workflow

### The Ideal Setup

```
Windows Terminal (tabs)
├── Tab 1: WSL Ubuntu (main dev)
├── Tab 2: WSL Ubuntu (builds/tests)
├── Tab 3: PowerShell (Windows tasks)
└── Tab 4: WSL Ubuntu (serial monitor / logs)
```

### VS Code + WSL

```bash
# From WSL, open VS Code connected to WSL
code .

# VS Code runs on Windows, but all extensions/terminals
# execute inside WSL. Best of both worlds.
```

### Git Configuration for Cross-Platform

```bash
# Handle line endings properly
git config --global core.autocrlf input

# Use Windows credential manager from WSL
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

---

## 🚨 Common Gotchas & Fixes

### "Clock skew" after sleep/hibernate

```bash
# Fix: resync time
sudo hwclock -s
# Or add to .bashrc:
sudo ntpdate time.windows.com 2>/dev/null
```

### Slow `apt update` (DNS issues)

```bash
# Edit resolv.conf
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'

# Prevent WSL from overwriting it
# In /etc/wsl.conf:
# [network]
# generateResolvConf=false
```

### High memory usage (vmmem process)

```powershell
# Add to .wslconfig:
# [wsl2]
# memory=8GB
#
# Then restart:
wsl --shutdown
```

### File permissions are wrong (everything is 777)

```bash
# In /etc/wsl.conf, ensure:
# [automount]
# options="metadata,umask=22,fmask=11"
#
# Then restart WSL
```

### Systemd services not starting

```bash
# Ensure wsl.conf has:
# [boot]
# systemd=true

# Verify:
systemctl list-units --type=service
```

---

## 📋 Useful WSL Commands (PowerShell)

```powershell
wsl --list --verbose          # List distros with version
wsl --shutdown                # Stop all WSL instances
wsl --terminate Ubuntu-22.04  # Stop specific distro
wsl --export Ubuntu-22.04 backup.tar  # Backup entire distro
wsl --import MyUbuntu C:\WSL\MyUbuntu backup.tar  # Restore/clone
wsl --set-default Ubuntu-22.04  # Set default distro
wsl --update                  # Update WSL kernel
```

---

## 🔄 Backup & Restore

```powershell
# Export (backup)
wsl --export Ubuntu-22.04 D:\Backups\ubuntu-dev-2024.tar

# Import (restore or clone)
wsl --import Ubuntu-Dev C:\WSL\Ubuntu-Dev D:\Backups\ubuntu-dev-2024.tar

# This is how you maintain reproducible dev environments
# Set up once, export, share with team
```

---

## ⚡ Performance Tips

1. **Keep source code in `~/`** never in `/mnt/c/`
2. **Use `appendWindowsPath=false`** removes 200+ Windows PATH entries from Linux
3. **Set memory limits** prevents WSL from eating all RAM
4. **Enable `autoMemoryReclaim`** returns unused pages to Windows
5. **Use `sparseVhd`** disk grows/shrinks dynamically
6. **Disable Windows Defender scanning of WSL** add `\\wsl$` to exclusions

### Add WSL Exclusion to Windows Defender

```powershell
# PowerShell (Admin)
Add-MpPreference -ExclusionPath "\\wsl$"
Add-MpPreference -ExclusionPath "C:\Users\$env:USERNAME\AppData\Local\Packages\CanonicalGroupLimited*"
```

This alone can **2-3x** your build speeds.

---

## 🎯 Why WSL + Ubuntu Specifically?

1. **Microsoft co-develops WSL with Canonical** Ubuntu is the reference distro
2. **First to get new WSL features** systemd, GUI apps, USB passthrough all tested on Ubuntu first
3. **Cloud parity** your WSL Ubuntu matches your CI/CD Ubuntu matches your production Ubuntu
4. **Embedded vendor support** TI, NXP, Xilinx all document Ubuntu. Your WSL matches their docs exactly
5. **One environment everywhere** same `.bashrc`, same tools, same scripts, laptop to cloud

---

*"WSL isn't Linux pretending to be Windows. It's Linux living inside Windows. The distinction matters it's a real kernel, real ext4, real syscalls. It just happens to share a desktop with Outlook."*
