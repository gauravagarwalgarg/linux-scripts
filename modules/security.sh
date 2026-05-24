#!/usr/bin/env bash
# =============================================================================
# Module: Security Firewall, intrusion detection, SSH hardening
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Security Hardening"

# ─── Security Packages ────────────────────────────────────────────────────────
info "Installing security tools..."
install_packages "${SECURITY_PACKAGES[@]}"

# ─── UFW Firewall ─────────────────────────────────────────────────────────────
if ! sudo ufw status | grep -q "active"; then
  info "Configuring UFW firewall..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw --force enable
  info "UFW enabled. SSH allowed."
else
  info "UFW already active."
fi

# ─── SSH Hardening ────────────────────────────────────────────────────────────
SSHD_CONFIG="/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
  info "Hardening SSH configuration..."

  # Disable root login
  sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"

  # Disable password auth (uncomment if you use keys)
  # sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"

  # Limit auth attempts
  sudo sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"

  sudo systemctl restart sshd 2>/dev/null || true
  info "SSH hardened: root login disabled, max 3 auth attempts."
fi

# ─── Fail2ban ─────────────────────────────────────────────────────────────────
if is_installed fail2ban; then
  sudo systemctl enable fail2ban
  sudo systemctl start fail2ban
  info "fail2ban enabled."
fi

info "Security setup complete."
