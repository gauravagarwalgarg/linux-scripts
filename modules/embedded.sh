#!/usr/bin/env bash
# =============================================================================
# Module: Embedded — Cross-compilers, Yocto deps, JTAG, serial, QEMU
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Embedded Development Tools"

# ─── Core Embedded Packages ───────────────────────────────────────────────────
info "Installing embedded development packages..."
install_packages "${EMBEDDED_PACKAGES[@]}"

# ─── Serial Port Permissions ─────────────────────────────────────────────────
if ! groups "$USER" | grep -q dialout; then
  info "Adding $USER to dialout group (serial port access)..."
  sudo usermod -aG dialout "$USER"
  warn "Log out and back in for group change to take effect."
fi

# ─── udev Rules for Common Debug Probes ───────────────────────────────────────
UDEV_RULES="/etc/udev/rules.d/99-debug-probes.rules"
if [ ! -f "$UDEV_RULES" ]; then
  info "Installing udev rules for debug probes..."
  sudo tee "$UDEV_RULES" > /dev/null << 'EOF'
# ST-Link
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666", GROUP="plugdev"
# J-Link
ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0101", MODE="0666", GROUP="plugdev"
ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0105", MODE="0666", GROUP="plugdev"
# FTDI (generic USB-serial)
ATTRS{idVendor}=="0403", MODE="0666", GROUP="plugdev"
# TI XDS debug probes
ATTRS{idVendor}=="0451", MODE="0666", GROUP="plugdev"
EOF
  sudo udevadm control --reload-rules
  info "udev rules installed."
fi

# ─── Yocto/BitBake Locale Fix ────────────────────────────────────────────────
if ! locale -a | grep -q "en_US.utf8"; then
  info "Generating en_US.UTF-8 locale (required by Yocto)..."
  sudo locale-gen en_US.UTF-8 >> "$LOG_FILE" 2>&1
fi

# ─── kas (Yocto build tool) ──────────────────────────────────────────────────
if ! command -v kas >/dev/null 2>&1; then
  info "Installing kas (Yocto build orchestrator)..."
  pip3 install --user kas >> "$LOG_FILE" 2>&1
fi

info "Embedded development setup complete."
info "Installed: ARM cross-compilers, QEMU, OpenOCD, serial tools, Yocto deps"
