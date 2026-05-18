#!/usr/bin/env bash
# =============================================================================
# Module: Desktop — GNOME tweaks, productivity apps, theming
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Desktop & Productivity"

# Skip on WSL (no GUI)
if is_wsl; then
  warn "WSL detected. Skipping desktop module (no native GUI)."
  exit 0
fi

# ─── Desktop Packages ─────────────────────────────────────────────────────────
info "Installing desktop packages..."
install_packages "${DESKTOP_PACKAGES[@]}"

# ─── GNOME Settings ──────────────────────────────────────────────────────────
info "Applying GNOME tweaks..."

# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true 2>/dev/null || true

# Dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# Minimize/maximize buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:' 2>/dev/null || true

# Disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false 2>/dev/null || true

# Natural scrolling for touchpad
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true 2>/dev/null || true

# Tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true 2>/dev/null || true

info "Desktop setup complete."
