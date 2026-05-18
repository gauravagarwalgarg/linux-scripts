#!/usr/bin/env bash
# =============================================================================
# Module: Base — System update, essential tools, fonts, shell config
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Base System Setup"

# ─── System Update ────────────────────────────────────────────────────────────
info "Updating package lists..."
sudo apt-get update -y >> "$LOG_FILE" 2>&1

info "Upgrading installed packages..."
sudo apt-get upgrade -y >> "$LOG_FILE" 2>&1

# ─── Essential Packages ───────────────────────────────────────────────────────
info "Installing base packages..."
install_packages "${BASE_PACKAGES[@]}"

# ─── Set Default Editor ───────────────────────────────────────────────────────
sudo update-alternatives --set editor /usr/bin/vim.basic 2>/dev/null || true

# ─── Timezone ─────────────────────────────────────────────────────────────────
info "Current timezone: $(timedatectl show --property=Timezone --value)"

# ─── Cleanup ─────────────────────────────────────────────────────────────────
info "Cleaning up..."
sudo apt-get autoremove -y >> "$LOG_FILE" 2>&1
sudo apt-get autoclean -y >> "$LOG_FILE" 2>&1

info "Base setup complete."
