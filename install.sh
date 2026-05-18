#!/usr/bin/env bash
# =============================================================================
# Linux Scripts : Interactive Installer
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

init

echo ""
echo "╔═══════════════════════════════════════════════════════╗"
echo "║       🐧 Linux Scripts Setup                    ║"
echo "╠═══════════════════════════════════════════════════════╣"
echo "║                                                       ║"
echo "║  Profiles (recommended):                              ║"
echo "║    1) Embedded Engineer                               ║"
echo "║    2) Cloud & DevOps                                  ║"
echo "║    3) Full Stack Developer                            ║"
echo "║                                                       ║"
echo "║  Individual Modules:                                  ║"
echo "║    4) Base (system update, essentials)                ║"
echo "║    5) Dev Tools (compilers, languages, CLI)           ║"
echo "║    6) Embedded (cross-compilers, Yocto, JTAG)        ║"
echo "║    7) Cloud (Docker, K8s, Terraform, AWS/GCP)        ║"
echo "║    8) Desktop (GNOME tweaks, apps)                   ║"
echo "║    9) Security (firewall, SSH hardening)             ║"
echo "║   10) Networking (Wireshark, net-tools)              ║"
echo "║                                                       ║"
echo "║    0) Exit                                            ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo ""

read -rp "Select option [0-10]: " choice

case $choice in
  1) bash "$SCRIPT_DIR/profiles/embedded-engineer.sh" ;;
  2) bash "$SCRIPT_DIR/profiles/cloud-devops.sh" ;;
  3) bash "$SCRIPT_DIR/profiles/full-stack.sh" ;;
  4) bash "$SCRIPT_DIR/modules/base.sh" ;;
  5) bash "$SCRIPT_DIR/modules/dev-tools.sh" ;;
  6) bash "$SCRIPT_DIR/modules/embedded.sh" ;;
  7) bash "$SCRIPT_DIR/modules/cloud.sh" ;;
  8) bash "$SCRIPT_DIR/modules/desktop.sh" ;;
  9) bash "$SCRIPT_DIR/modules/security.sh" ;;
  10) bash "$SCRIPT_DIR/modules/networking.sh" ;;
  0) echo "Exiting."; exit 0 ;;
  *) error "Invalid option: $choice" ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  ✓ Done. Log saved to: $LOG_FILE"
echo "═══════════════════════════════════════════════════════"
