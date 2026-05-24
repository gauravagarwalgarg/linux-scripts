#!/usr/bin/env bash
# =============================================================================
# Package lists organized by category
# =============================================================================

# ─── Base Essentials ──────────────────────────────────────────────────────────
BASE_PACKAGES=(
  curl wget git unzip zip tar
  htop btop neofetch tree
  software-properties-common apt-transport-https
  ca-certificates gnupg lsb-release
  bash-completion
  fonts-firacode fonts-jetbrains-mono
)

# ─── Developer Tools ──────────────────────────────────────────────────────────
DEV_PACKAGES=(
  build-essential gcc g++ gdb
  make cmake ninja-build
  python3 python3-pip python3-venv
  nodejs npm
  tmux vim-gtk3
  jq yq ripgrep fd-find bat fzf
  shellcheck
  clang clang-format clang-tidy
  valgrind strace ltrace
  pkg-config
)

# ─── Embedded Development ─────────────────────────────────────────────────────
EMBEDDED_PACKAGES=(
  # Cross-compilers
  gcc-arm-none-eabi binutils-arm-none-eabi
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
  gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
  # Serial & JTAG
  minicom picocom screen
  openocd
  # Yocto/BitBake dependencies
  gawk diffstat texinfo chrpath socat cpio
  python3-distutils xterm
  libsdl1.2-dev
  # QEMU for emulation
  qemu-system-arm qemu-system-aarch64 qemu-user-static
  # Device tree
  device-tree-compiler
  # USB & hardware
  usbutils libusb-1.0-0-dev
  # Documentation
  doxygen graphviz
)

# ─── Cloud & DevOps ───────────────────────────────────────────────────────────
CLOUD_PACKAGES=(
  # Container runtime
  docker.io docker-compose
  # Kubernetes tools (installed via script, not apt)
  # kubectl, helm, k9s handled separately
  # Infrastructure
  ansible
  # Utilities
  httpie
  apache2-utils
)

# ─── Desktop & Productivity ───────────────────────────────────────────────────
DESKTOP_PACKAGES=(
  gnome-tweaks gnome-shell-extensions
  gnome-sushi nautilus-admin
  mpv vlc
  flameshot
  variety
  ttf-mscorefonts-installer
)

# ─── Security ────────────────────────────────────────────────────────────────
SECURITY_PACKAGES=(
  ufw
  fail2ban
  clamav
  lynis
  rkhunter
  auditd
)

# ─── Networking ───────────────────────────────────────────────────────────────
NETWORKING_PACKAGES=(
  net-tools
  openssh-client openssh-server
  nmap
  wireshark tshark
  traceroute mtr-tiny
  dnsutils
  iperf3
  tcpdump
)
