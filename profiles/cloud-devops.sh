#!/usr/bin/env bash
# =============================================================================
# Profile: Cloud & DevOps
# Installs: base + dev-tools + cloud + security
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "═══════════════════════════════════════════════════════"
echo "  Profile: Cloud & DevOps"
echo "  Modules: base → dev-tools → cloud → security"
echo "═══════════════════════════════════════════════════════"

bash "$SCRIPT_DIR/modules/base.sh"
bash "$SCRIPT_DIR/modules/dev-tools.sh"
bash "$SCRIPT_DIR/modules/cloud.sh"
bash "$SCRIPT_DIR/modules/security.sh"

echo ""
echo "✓ Cloud & DevOps profile complete."
echo "  You now have: Docker, kubectl, Helm, Terraform,"
echo "  AWS/GCP CLI, Minikube, and security hardening."
