#! /bin/bash

# Fix jittery cursor movement (if you face it)
sudo apt -y install  xserver-xorg-input-synaptics
  
# Remove games
sudo apt -y autoremove aisleriot gnome-mahjongg gnome-sudoku gnome-mines

# Remove stuff
sudo apt -y autoremove xul-ext-ubufox thunderbird rhythmbox ubuntu-web-launchers cheese baobab eog remmina simple-scan totem usb-creator-common gnome-todo gnome-calendar

# Replace slow snap versions with .deb ones
sudo snap -y remove gnome-calculator gnome-characters gnome-system-monitor gnome-logs

sudo apt -y install gnome-calculator gnome-characters gnome-system-monitor

# Install apps
sudo apt -y install gnome-tweaks geary deepin-picker mpv

# Minimal bloat installs
sudo apt -y install chromium-browser --no-install-recommends

# Enhance Files app
sudo apt -y install nautilus-admin gnome-sushi nautilus-image-converter

# Autochage Wallpaper, random quotes
sudo apt -y install variety

# LibreOffice done right
sudo add-apt-repository -y ppa:libreoffice/ppa
sudo apt -y upgrade
sudo apt -y install ttf-mscorefonts-installer

# C/C++ Packages (Minimal)
sudo apt -y install make cmake automake autoheader aclocal libtool

# Networking packages
sudo apt -y install net-tools openssh-client openssh-server

# Update and Upgrade the packages
sudo apt -y update && sudo apt upgrade && sudo apt autoremove && sudo apt autoclean
