#!/usr/bin/env bash
# =============================================================================
# Profile: Embedded Engineer
# Installs: base + dev-tools + embedded + networking
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "═══════════════════════════════════════════════════════"
echo "  Profile: Embedded Engineer"
echo "  Modules: base → dev-tools → embedded → networking"
echo "═══════════════════════════════════════════════════════"

bash "$SCRIPT_DIR/modules/base.sh"
bash "$SCRIPT_DIR/modules/dev-tools.sh"
bash "$SCRIPT_DIR/modules/embedded.sh"
bash "$SCRIPT_DIR/modules/networking.sh"

echo ""
echo "✓ Embedded Engineer profile complete."
echo "  You now have: cross-compilers, QEMU, OpenOCD, serial tools,"
echo "  Yocto dependencies, and all build essentials."
