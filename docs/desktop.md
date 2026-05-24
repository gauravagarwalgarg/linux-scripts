# 🖥️ Desktop & Productivity Guide

> Turn a fresh Ubuntu install into a polished daily-driver workstation.

---

## 🧰 What Gets Installed

| Package | Purpose |
|---------|---------|
| `gnome-tweaks` | Advanced GNOME settings (fonts, themes, extensions) |
| `gnome-shell-extensions` | Extension framework |
| `gnome-sushi` | Quick preview (spacebar in Files) |
| `nautilus-admin` | "Open as Admin" in file manager |
| `mpv` / `vlc` | Media players (lightweight / full-featured) |
| `flameshot` | Screenshot tool with annotation |
| `variety` | Auto-changing wallpapers |
| `ttf-mscorefonts-installer` | Microsoft fonts (for document compatibility) |

---

## 🎨 GNOME Configuration

The `desktop.sh` module applies these settings automatically:

```bash
# Dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Window buttons on left (macOS-style)
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Disable hot corner
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Tap to click (touchpad)
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true
```

---

## 🧩 Recommended GNOME Extensions

Install from https://extensions.gnome.org:

| Extension | What It Does |
|-----------|-------------|
| **Dash to Dock** | macOS-style dock at bottom |
| **AppIndicator** | System tray icons (for apps that need it) |
| **Clipboard Indicator** | Clipboard history (like Windows Win+V) |
| **Caffeine** | Prevent screen lock with one click |
| **Blur My Shell** | Blur effect on overview/panel |
| **Space Bar** | Workspace indicator in top bar |
| **Just Perfection** | Hide/show any GNOME UI element |

### Install via CLI

```bash
# Install extension manager
sudo apt install gnome-shell-extension-manager

# Or use the browser extension + extensions.gnome.org
```

---

## ⌨️ Keyboard Shortcuts

Set these in Settings → Keyboard → Shortcuts:

| Action | Shortcut |
|--------|----------|
| Terminal | `Ctrl+Alt+T` (default) |
| Screenshot (area) | `Shift+Print` → remap to `Super+Shift+S` |
| Close window | `Super+Q` |
| Maximize | `Super+Up` |
| Tile left/right | `Super+Left/Right` |
| Switch workspace | `Super+PageUp/Down` |
| Move to workspace | `Super+Shift+PageUp/Down` |

---

## 🔤 Fonts

```bash
# Install popular dev fonts
sudo apt install fonts-firacode fonts-jetbrains-mono

# Nerd Fonts (for terminal icons)
# Download from https://www.nerdfonts.com/font-downloads
# Extract to ~/.local/share/fonts/
# Then: fc-cache -fv
```

### Recommended Font Stack

| Use | Font | Why |
|-----|------|-----|
| Terminal | JetBrainsMono Nerd | Ligatures + icons |
| Editor | Fira Code | Best ligatures |
| System UI | Inter | Clean, modern |
| Documents | Noto Sans | Universal coverage |

---

## 🖼️ Theming

### GTK Theme

```bash
# Adwaita Dark (default, polished)
gsettings set org.gnome.desktop.interface gtk-theme 'Adw-dark'

# Or install third-party:
# Catppuccin GTK: https://github.com/catppuccin/gtk
# Dracula: https://draculatheme.com/gtk
```

### Icon Theme

```bash
# Papirus (popular, comprehensive)
sudo add-apt-repository ppa:papirus/papirus
sudo apt install papirus-icon-theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
```

### Cursor Theme

```bash
sudo apt install breeze-cursor-theme
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze_Snow'
```

---

## 📱 Essential Desktop Apps

| App | Install | Purpose |
|-----|---------|---------|
| VS Code | `snap install code --classic` | Code editor |
| Firefox | Pre-installed | Browser |
| Chromium | `sudo apt install chromium-browser` | Alt browser / web dev |
| Slack | `snap install slack` | Team communication |
| Obsidian | `snap install obsidian --classic` | Notes / knowledge base |
| GIMP | `sudo apt install gimp` | Image editing |
| OBS Studio | `sudo apt install obs-studio` | Screen recording |
| Thunderbird | Pre-installed | Email |

---

## 🔋 Power Management (Laptops)

```bash
# TLP advanced power management
sudo apt install tlp tlp-rdw
sudo systemctl enable tlp

# Check battery status
tlp-stat -b

# Powertop analyze power usage
sudo apt install powertop
sudo powertop --auto-tune
```

---

## Anecdote

> *"I used to spend hours theming my desktop custom icons, animated wallpapers, conky widgets. Then I realized: the best desktop is one you never see because you're always in a terminal or editor. Now I run stock GNOME dark mode with one extension (Dash to Dock) and spend my time writing code instead of ricing."*

---

*"Productivity isn't about how your desktop looks. It's about how fast you can get from idea to implementation."*
