#!/usr/bin/env bash
# =============================================================================
# Module: Cloud Docker, Kubernetes, Terraform, AWS/GCP CLI, local dev tools
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"

section "Cloud & DevOps Tools"

# ─── Docker ───────────────────────────────────────────────────────────────────
if ! command -v docker >/dev/null 2>&1; then
  info "Installing Docker..."
  install_packages docker.io docker-compose
  sudo usermod -aG docker "$USER"
  sudo systemctl enable docker
  warn "Log out and back in for docker group to take effect."
else
  info "Docker already installed: $(docker --version)"
fi

# ─── kubectl ──────────────────────────────────────────────────────────────────
if ! command -v kubectl >/dev/null 2>&1; then
  info "Installing kubectl..."
  curl -sLO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
  info "kubectl installed: $(kubectl version --client --short 2>/dev/null)"
else
  info "kubectl already installed."
fi

# ─── Helm ─────────────────────────────────────────────────────────────────────
if ! command -v helm >/dev/null 2>&1; then
  info "Installing Helm..."
  curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash >> "$LOG_FILE" 2>&1
  info "Helm installed: $(helm version --short)"
else
  info "Helm already installed."
fi

# ─── k9s (Kubernetes TUI) ────────────────────────────────────────────────────
if ! command -v k9s >/dev/null 2>&1; then
  info "Installing k9s..."
  K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
  curl -sLo /tmp/k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
  sudo tar -C /usr/local/bin -xzf /tmp/k9s.tar.gz k9s
  rm /tmp/k9s.tar.gz
fi

# ─── Terraform ────────────────────────────────────────────────────────────────
if ! command -v terraform >/dev/null 2>&1; then
  info "Installing Terraform..."
  wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
  sudo apt-get update -y >> "$LOG_FILE" 2>&1
  sudo apt-get install -y terraform >> "$LOG_FILE" 2>&1
  info "Terraform installed: $(terraform version | head -1)"
else
  info "Terraform already installed."
fi

# ─── AWS CLI v2 ───────────────────────────────────────────────────────────────
if ! command -v aws >/dev/null 2>&1; then
  info "Installing AWS CLI v2..."
  curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -q /tmp/awscliv2.zip -d /tmp/
  sudo /tmp/aws/install >> "$LOG_FILE" 2>&1
  rm -rf /tmp/aws /tmp/awscliv2.zip
  info "AWS CLI installed: $(aws --version)"
else
  info "AWS CLI already installed."
fi

# ─── GCP CLI ──────────────────────────────────────────────────────────────────
if ! command -v gcloud >/dev/null 2>&1; then
  info "Installing Google Cloud CLI..."
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg 2>/dev/null
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
  sudo apt-get update -y >> "$LOG_FILE" 2>&1
  sudo apt-get install -y google-cloud-cli >> "$LOG_FILE" 2>&1
  info "gcloud installed."
else
  info "gcloud already installed."
fi

# ─── Minikube (local Kubernetes) ──────────────────────────────────────────────
if ! command -v minikube >/dev/null 2>&1; then
  info "Installing Minikube (local K8s cluster)..."
  curl -sLo /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install /tmp/minikube /usr/local/bin/minikube
  rm /tmp/minikube
fi

# ─── LocalStack (local AWS) ───────────────────────────────────────────────────
if command -v pip3 >/dev/null 2>&1; then
  if ! command -v localstack >/dev/null 2>&1; then
    info "Installing LocalStack (local AWS emulation)..."
    pip3 install --user localstack >> "$LOG_FILE" 2>&1
  fi
fi

# ─── Other Utilities ──────────────────────────────────────────────────────────
install_packages "${CLOUD_PACKAGES[@]}"

info "Cloud & DevOps setup complete."
