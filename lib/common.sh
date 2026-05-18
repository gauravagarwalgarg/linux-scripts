#!/usr/bin/env bash
# =============================================================================
# Common utilities — logging, distro detection, safety checks
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

LOG_FILE="/tmp/linux-scripts-install.log"

# ─── Logging ─────────────────────────────────────────────────────────────────
info()    { echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"; exit 1; }
section() { echo -e "\n${BOLD}${BLUE}═══ $1 ═══${NC}\n" | tee -a "$LOG_FILE"; }

# ─── Distro Detection ────────────────────────────────────────────────────────
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="$ID"
    DISTRO_VERSION="$VERSION_ID"
    DISTRO_NAME="$PRETTY_NAME"
  else
    error "Cannot detect distribution. /etc/os-release not found."
  fi

  if [[ "$DISTRO_ID" != "ubuntu" ]]; then
    warn "This script is designed for Ubuntu. Detected: $DISTRO_NAME"
    warn "Proceeding anyway — some packages may not be available."
  fi

  info "Detected: $DISTRO_NAME"
}

# ─── WSL Detection ───────────────────────────────────────────────────────────
is_wsl() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    return 0
  fi
  return 1
}

# ─── Package Helpers ──────────────────────────────────────────────────────────
is_installed() {
  dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -eq 0 ]; then
    info "All packages already installed. Skipping."
    return 0
  fi

  info "Installing: ${to_install[*]}"
  sudo apt-get install -y "${to_install[@]}" >> "$LOG_FILE" 2>&1
}

# ─── PPA Helper ───────────────────────────────────────────────────────────────
add_ppa() {
  local ppa="$1"
  if ! grep -q "^deb.*${ppa}" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    info "Adding PPA: $ppa"
    sudo add-apt-repository -y "ppa:$ppa" >> "$LOG_FILE" 2>&1
  else
    info "PPA already added: $ppa"
  fi
}

# ─── Command Check ───────────────────────────────────────────────────────────
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || error "'$1' is required but not installed."
}

# ─── Confirmation ────────────────────────────────────────────────────────────
confirm() {
  local prompt="${1:-Continue?}"
  read -rp "$(echo -e "${YELLOW}${prompt} [y/N]${NC} ")" response
  [[ "$response" =~ ^[Yy]$ ]]
}

# ─── Root Check ───────────────────────────────────────────────────────────────
check_not_root() {
  if [ "$EUID" -eq 0 ]; then
    error "Do not run this script as root. It will use sudo when needed."
  fi
}

# ─── Initialize ──────────────────────────────────────────────────────────────
init() {
  check_not_root
  detect_distro
  echo "─── Install started: $(date) ───" >> "$LOG_FILE"

  if is_wsl; then
    info "Running inside WSL"
  fi
}
