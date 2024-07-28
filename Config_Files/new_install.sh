#!/bin/bash
#       _          _ _
#   ___| |__   ___| (_) ___  _   _ ___
#  / _ \ '_ \ / _ \ | |/ _ \| | | / __|
# |  __/ |_) |  __/ | | (_) | |_| \__ \
#  \___|_.__/ \___|_|_|\___/ \__,_|___/
# https://github.com/ebelious
#
# This is for automating a lot of the new install process for fedora
#

# Making dnf faster
sudo echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
sudo echo "fastestmirror=True" >> /etc/dnf/dnf.conf

# Installing updates
sudo dnf update

# Installing Copr repos
sudo dnf copr enable elxreno/preload

# Installing my main packages
sudo dnf install htop nmap timeshift bleachbit kitty preload fastfetch lsd fzf bat pipx lf trash-cli

# Installing flatpaks
flatpak install flathub com.valvesoftware.Steam
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub com.discordapp.Discord
flatpak install flathub net.davidotek.pupgui2
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.rtosta.zapzap

# Installing Nvidia Drivers
sudo dnf install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf makecache
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda

# Make an Enterprise account
#### Set device hostname
sudo hostnamectl set-hostname [HOSTNAME]

#### Configure resolved
sudo echo "[Resolve]" >> /etc/systemd/resolved.conf
sudo echo "DNS=10.1.1.18 172.17.0.2 1.1.1.1 1.0.0.1" >> /etc/systemd/resolved.conf
sudo echo "Domains=home.local" >> /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved.service
resolvectl status
sleep 3

#### Configure kerberos
sudo nano /etc/krb5.conf
sudo realm join -v home.local

# Install Brave Browser
sudo dnf install dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser

# Install Nerd Fonts
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh
cd $HOME

# Install pyenv
curl https://pyenv.run | bash

# Installing LF terminal file manager
curl -L https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xzC ~/.local/bin

# Installing Zellij terminal multi plexer
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xzC ~/.local/bin


