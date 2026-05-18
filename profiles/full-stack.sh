#!/usr/bin/env bash
# =============================================================================
# Profile: Full Stack
# Installs: base + dev-tools + cloud + desktop + networking
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "═══════════════════════════════════════════════════════"
echo "  Profile: Full Stack Developer"
echo "  Modules: base → dev-tools → cloud → desktop → networking"
echo "═══════════════════════════════════════════════════════"

bash "$SCRIPT_DIR/modules/base.sh"
bash "$SCRIPT_DIR/modules/dev-tools.sh"
bash "$SCRIPT_DIR/modules/cloud.sh"
bash "$SCRIPT_DIR/modules/desktop.sh"
bash "$SCRIPT_DIR/modules/networking.sh"

echo ""
echo "✓ Full Stack profile complete."
echo "  You now have: compilers, Docker, K8s, cloud CLIs,"
echo "  desktop tweaks, and networking tools."
