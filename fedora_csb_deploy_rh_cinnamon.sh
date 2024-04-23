#!/bin/bash

# Check if the script is run as root (sudo)
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Function to add extra repositories for RPM Applications
add_repositories() {
  echo "Adding repositories..."
  echo "Installing RPMFusion..."
  dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  echo "Adding Microsoft repository..."
  rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  echo "Adding Slack repository..."
  rpm --import https://slack.com/gpg/slack_pubkey_20230710.gpg
  dnf copr enable -y jdoss/slack-repo
}

# Function to install Flatpak apps from FlatHub
install_flatpak_apps() {
  read -p "Do you want to install Flatpak apps? These include Bitwarden, Obsidian and Spotify. (Y/N): " choice
  case "$choice" in
    [Yy]*)
      echo "Installing Flatpak apps..."
      flatpak install flathub -y com.bitwarden.desktop com.spotify.Client md.obsidian.Obsidian
      echo "Applying automatic theme selection for Flatpak apps"
      flatpak override --filesystem=xdg-config/gtk-3.0:ro
      ;;
    [Nn]*)
      echo "No Flatpak apps will be installed."
      ;;
    *)
      echo "Invalid choice. No Flatpak apps will be installed."
      ;;
  esac
}

# Running pre-requisite upgrades
echo "Improving DNF performance..."
echo -e "#Improve DNF download speed and performance\nmax_parallel_downloads=10\nfastestmirror=True\ninstallonly_limit=2" >> /etc/dnf/dnf.conf
echo "Running initial Fedora updates..."
dnf update -y

# Add repositories and run commands before package selection
add_repositories
dnf install --nogpgcheck -y slack-repo

# Initial installation
echo "Updating package repository and installing initial packages..."
dnf update -y
dnf install -y https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm https://zoom.us/client/5.17.11.3835/zoom_x86_64.rpm
dnf update -y
dnf group install --best --allowerasing -y "KDE Plasma Workspaces" "KDE (K Desktop Environment)"
systemctl disable gdm
systemctl enable sddm
dnf install --best --allowerasing -y arj cabextract code @development-tools dnf-utils dpkg dragon elisa-player fprintd-devel gimp gimp-data-extras gimp-*-plugin gimp-elsamuko gimp-*-filter gimp-help gimp-help-es gimp-layer* gimp-lensfun gimp-*-masks gimp-resynthesizer gimp-save-for-web gimp-separate+ gimp-*-studio gimp-wavelet* gimpfx-foundry gwenview go htop hunspell-es info innoextract kamoso kate kcalc kdiskmark kget kommit konversation ksystemlog lha libcurl-devel libfprint-devel libreoffice-draw libreoffice-langpack-es libreoffice-help-es libxml2-devel lzma mozilla-ublock-origin neofetch nodejs-bash-language-server okular perl pstoedit pycharm-community pycharm-community-doc pycharm-community-plugins redhat-lsb-core slack thunderbird unace unrar wireshark xkill

# Check if the initial installation was successful
if [ $? -eq 0 ]; then
  echo "Initial installation successful."
else
  echo "Initial installation failed."
  exit 1
fi

# Install Flatpak apps
install_flatpak_apps