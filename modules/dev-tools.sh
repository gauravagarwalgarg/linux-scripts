#!/usr/bin/env bash
# =============================================================================
# Module: Dev Tools Compilers, build systems, language runtimes, CLI tools
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Developer Tools"

# ─── Core Dev Packages ────────────────────────────────────────────────────────
info "Installing developer tools..."
install_packages "${DEV_PACKAGES[@]}"

# ─── Go (latest stable) ──────────────────────────────────────────────────────
if ! command -v go >/dev/null 2>&1; then
  info "Installing Go..."
  GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -1)
  curl -sLo /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz

  # Add to PATH
  if ! grep -q '/usr/local/go/bin' ~/.bashrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
  fi
  info "Go ${GO_VERSION} installed."
else
  info "Go already installed: $(go version)"
fi

# ─── Rust (via rustup) ────────────────────────────────────────────────────────
if ! command -v rustc >/dev/null 2>&1; then
  info "Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >> "$LOG_FILE" 2>&1
  source "$HOME/.cargo/env"
  info "Rust installed: $(rustc --version)"
else
  info "Rust already installed: $(rustc --version)"
fi

# ─── Python Tools ─────────────────────────────────────────────────────────────
info "Installing Python dev tools..."
pip3 install --user --quiet pipx virtualenv black flake8 mypy 2>/dev/null || true

# ─── Git Configuration Reminder ───────────────────────────────────────────────
if [ -z "$(git config --global user.name)" ]; then
  warn "Git user.name not set. Run: git config --global user.name 'Your Name'"
fi
if [ -z "$(git config --global user.email)" ]; then
  warn "Git user.email not set. Run: git config --global user.email 'you@example.com'"
fi

info "Developer tools setup complete."
