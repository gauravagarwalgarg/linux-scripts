# 📦 Modules Reference

> Detailed breakdown of every package installed by each module.

---

## base.sh

**Purpose**: System update, essential CLI tools, fonts.

| Package | What It Does |
|---------|-------------|
| `curl`, `wget` | HTTP clients |
| `git` | Version control |
| `unzip`, `zip`, `tar` | Archive tools |
| `htop`, `btop` | Process monitors (TUI) |
| `neofetch` | System info display |
| `tree` | Directory tree visualization |
| `software-properties-common` | PPA management |
| `apt-transport-https` | HTTPS apt sources |
| `ca-certificates`, `gnupg` | Certificate/key management |
| `lsb-release` | Distro identification |
| `bash-completion` | Tab completion for commands |
| `fonts-firacode` | FiraCode programming font |
| `fonts-jetbrains-mono` | JetBrains Mono programming font |

---

## dev-tools.sh

**Purpose**: Compilers, build systems, language runtimes, CLI productivity.

| Package | What It Does |
|---------|-------------|
| `build-essential` | gcc, g++, make, libc-dev |
| `gcc`, `g++`, `gdb` | C/C++ compiler and debugger |
| `make`, `cmake`, `ninja-build` | Build systems |
| `python3`, `python3-pip`, `python3-venv` | Python runtime |
| `nodejs`, `npm` | JavaScript runtime |
| `tmux` | Terminal multiplexer |
| `vim-gtk3` | Vim with clipboard support |
| `jq`, `yq` | JSON/YAML processors |
| `ripgrep` | Fast grep replacement |
| `fd-find` | Fast find replacement |
| `bat` | cat with syntax highlighting |
| `fzf` | Fuzzy finder |
| `shellcheck` | Shell script linter |
| `clang`, `clang-format`, `clang-tidy` | LLVM toolchain |
| `valgrind`, `strace`, `ltrace` | Memory/syscall/library tracing |
| `pkg-config` | Library flag helper |

**Also installs (via script):**
- Go (latest stable from go.dev)
- Rust (via rustup)
- Python tools: pipx, virtualenv, black, flake8, mypy

---

## embedded.sh

**Purpose**: Cross-compilers, Yocto dependencies, debug tools, emulation.

| Package | What It Does |
|---------|-------------|
| `gcc-arm-none-eabi` | ARM Cortex-M bare-metal compiler |
| `binutils-arm-none-eabi` | ARM bare-metal linker/objdump |
| `gcc-aarch64-linux-gnu` | ARM64 Linux cross-compiler |
| `g++-aarch64-linux-gnu` | ARM64 Linux C++ cross-compiler |
| `gcc-arm-linux-gnueabihf` | ARM32 Linux cross-compiler |
| `g++-arm-linux-gnueabihf` | ARM32 Linux C++ cross-compiler |
| `minicom`, `picocom`, `screen` | Serial terminal emulators |
| `openocd` | JTAG/SWD debug server |
| `gawk`, `diffstat`, `texinfo`, `chrpath`, `socat`, `cpio` | Yocto build dependencies |
| `python3-distutils`, `xterm` | Yocto build dependencies |
| `libsdl1.2-dev` | Yocto QEMU display |
| `qemu-system-arm` | ARM system emulator |
| `qemu-system-aarch64` | ARM64 system emulator |
| `qemu-user-static` | ARM binary execution on x86 |
| `device-tree-compiler` | DTS/DTB compilation |
| `usbutils`, `libusb-1.0-0-dev` | USB device tools |
| `doxygen`, `graphviz` | Documentation generation |

**Also configures:**
- Serial port permissions (dialout group)
- udev rules for ST-Link, J-Link, FTDI, TI probes
- Locale generation (en_US.UTF-8 for Yocto)
- kas (Yocto build orchestrator via pip)

---

## cloud.sh

**Purpose**: Container runtime, orchestration, IaC, cloud CLIs.

| Package | What It Does |
|---------|-------------|
| `docker.io` | Container runtime |
| `docker-compose` | Multi-container orchestration |
| `ansible` | Configuration management |
| `httpie` | Human-friendly HTTP client |
| `apache2-utils` | ab (benchmarking), htpasswd |

**Also installs (via script):**
- kubectl (Kubernetes CLI)
- Helm (K8s package manager)
- k9s (Kubernetes TUI)
- Terraform (Infrastructure as Code)
- AWS CLI v2
- Google Cloud CLI
- Minikube (local Kubernetes)
- LocalStack (local AWS emulation)

---

## desktop.sh

**Purpose**: GNOME tweaks, productivity apps, theming.

| Package | What It Does |
|---------|-------------|
| `gnome-tweaks` | Advanced GNOME settings |
| `gnome-shell-extensions` | Extension support |
| `gnome-sushi` | File preview (spacebar) |
| `nautilus-admin` | Admin context menu in Files |
| `mpv`, `vlc` | Media players |
| `flameshot` | Screenshot with annotation |
| `variety` | Auto-changing wallpapers |
| `ttf-mscorefonts-installer` | Microsoft fonts |

**Also configures:**
- Dark mode, button layout, hot corners, touchpad settings

**Skipped on WSL** (no GUI).

---

## security.sh

**Purpose**: Firewall, intrusion detection, SSH hardening.

| Package | What It Does |
|---------|-------------|
| `ufw` | Uncomplicated Firewall |
| `fail2ban` | Brute-force protection |
| `clamav` | Antivirus scanner |
| `lynis` | Security auditing |
| `rkhunter` | Rootkit detection |
| `auditd` | System call auditing |

**Also configures:**
- UFW: deny incoming, allow outgoing, allow SSH
- SSH: disable root login, limit auth attempts to 3
- fail2ban: enabled and started

---

## networking.sh

**Purpose**: Network diagnostics, packet capture, connectivity tools.

| Package | What It Does |
|---------|-------------|
| `net-tools` | ifconfig, netstat (legacy but useful) |
| `openssh-client`, `openssh-server` | SSH client and server |
| `nmap` | Network scanner |
| `wireshark`, `tshark` | Packet capture and analysis |
| `traceroute`, `mtr-tiny` | Route tracing |
| `dnsutils` | dig, nslookup |
| `iperf3` | Network bandwidth testing |
| `tcpdump` | CLI packet capture |

**Also configures:**
- Wireshark group permissions (non-root capture)

---

## 🔄 Module Dependencies

```
base ← (required by all other modules)
  ├── dev-tools
  │     ├── embedded
  │     └── cloud
  ├── desktop (skipped on WSL)
  ├── security
  └── networking
```

All modules source `lib/common.sh` for logging and `lib/packages.sh` for package lists. Each module is idempotent — safe to run multiple times.

---

*"Know what you're installing. Every package is a dependency you maintain."*
