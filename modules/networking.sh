#!/usr/bin/env bash
# =============================================================================
# Module: Networking Net tools, Wireshark, VPN, DNS utilities
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Networking Tools"

# ─── Networking Packages ──────────────────────────────────────────────────────
info "Installing networking tools..."
install_packages "${NETWORKING_PACKAGES[@]}"

# ─── Wireshark Permissions ────────────────────────────────────────────────────
if is_installed wireshark; then
  if ! groups "$USER" | grep -q wireshark; then
    info "Adding $USER to wireshark group..."
    sudo usermod -aG wireshark "$USER"
    warn "Log out and back in for wireshark group to take effect."
  fi
fi

info "Networking setup complete."
