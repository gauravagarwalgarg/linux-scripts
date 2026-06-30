# 🐧 Linux Scripts

[![CI](https://github.com/gauravagarwalgarg/linux-scripts/actions/workflows/ci.yml/badge.svg)](https://github.com/gauravagarwalgarg/linux-scripts/actions/workflows/ci.yml) [![Docs](https://img.shields.io/badge/docs-live-blue?logo=github)](https://gauravagarwalgarg.github.io/linux-scripts/) ![Shell](https://img.shields.io/badge/Shell-Bash-green?logo=gnubash&logoColor=white) [![License](https://img.shields.io/github/license/gauravagarwalgarg/linux-scripts)](https://github.com/gauravagarwalgarg/linux-scripts/blob/master/LICENSE)

> 📖 **Documentation**: [https://gauravagarwalgarg.github.io/linux-scripts/](https://gauravagarwalgarg.github.io/linux-scripts/)
>
> 📦 **Repository**: [GitHub](https://github.com/gauravagarwalgarg/linux-scripts)


> Post-install automation for Ubuntu LTS. From fresh install to production-ready workstation in one command.

Scripts are Ubuntu-compatible (22.04 / 24.04 LTS). Docs cover the broader Linux landscape distro choices, WSL workflows, and role-specific tooling guides.

---

## 🚀 Quick Start

```bash
git clone https://github.com/GauravAgarwalGarg/LinuxPostInstallScripts.git
cd LinuxPostInstallScripts
chmod +x install.sh
./install.sh
```

The installer presents an interactive menu. Pick a profile or select individual modules.

---

## 📦 Profiles

| Profile | What It Installs | For |
|---------|-----------------|-----|
| `embedded-engineer` | base + dev-tools + embedded | Firmware/BSP/RTOS developers |
| `cloud-devops` | base + dev-tools + cloud | Cloud engineers, SREs, DevOps |
| `full-stack` | base + dev-tools + cloud + desktop | Full-stack developers |

---

## 🧩 Modules

| Module | Description |
|--------|-------------|
| `base` | System update, essential CLI tools, fonts, shell config |
| `dev-tools` | Git, Vim, tmux, compilers, build systems, language runtimes |
| `embedded` | Cross-compilers, Yocto deps, JTAG/serial tools, QEMU |
| `cloud` | Docker, Kubernetes, Terraform, AWS/GCP CLI, local cloud tools |
| `desktop` | GNOME tweaks, productivity apps, theming |
| `security` | UFW, fail2ban, SSH hardening, audit tools |
| `networking` | Net tools, Wireshark, VPN, DNS utilities |

---

## 📚 Documentation

| Guide | Description |
|-------|-------------|
| [Distro Journey](docs/distro-journey.md) | Why Ubuntu, distro-hopping lessons, when to use what |
| [WSL Guide](docs/wsl-guide.md) | WSL2 setup, Ubuntu on Windows, tips and gotchas |
| [Embedded Engineer](docs/embedded-engineer.md) | Yocto, cross-compilers, JTAG, serial, QEMU full toolchain |
| [Cloud & DevOps](docs/cloud-devops.md) | Docker, K8s, Terraform, local cloud development |
| [Desktop & Productivity](docs/desktop.md) | GNOME setup, theming, daily-driver apps |
| [Modules Reference](docs/modules.md) | Detailed package lists per module |

---

## 🏗️ Structure

```
├── install.sh              # Interactive entry point
├── lib/
│   ├── common.sh           # Logging, distro detection, checks
│   └── packages.sh         # Package lists per category
├── modules/
│   ├── base.sh
│   ├── dev-tools.sh
│   ├── embedded.sh
│   ├── cloud.sh
│   ├── desktop.sh
│   ├── security.sh
│   └── networking.sh
├── profiles/
│   ├── embedded-engineer.sh
│   ├── cloud-devops.sh
│   └── full-stack.sh
└── docs/
    ├── distro-journey.md
    ├── wsl-guide.md
    ├── embedded-engineer.md
    ├── cloud-devops.md
    ├── desktop.md
    └── modules.md
```

---

## ⚙️ Design Principles

- **Idempotent** safe to re-run; checks before installing
- **Modular** pick only what you need
- **Ubuntu LTS** tested on 22.04 and 24.04
- **Non-destructive** never removes packages without explicit opt-in
- **Logged** every action logged to `/tmp/linux-scripts-install.log`

---

*"The best distro is the one that gets out of your way and lets you ship code."*
