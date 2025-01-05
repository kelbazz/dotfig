#!/bin/bash

# Function to install pacman packages
install_pacman_packages() {
    echo "Installing pacman packages..."
    sudo pacman -S - < ./package-lists/pacman.txt
}

# Function to install paru packages
install_paru_packages() {
    echo "Installing paru packages..."
    paru -S - < ./package-lists/paru.txt
}

# Function to install flatpak packages
install_flatpak_packages() {
    echo "Installing flatpak packages..."
    xargs -I {} flatpak install -y {} < package-lists/flatpak.txt
}

# Function to set up stow configurations
setup_stow() {
    echo "Setting up symbolic links with stow..."
    cd ~/dotfiles
    stow helix
    stow nushell
    stow ghostty
}

# Check for pacman and install if necessary
if ! command -v pacman &> /dev/null; then
    echo "pacman is not installed. Exiting."
    exit 1
fi

# Check and install paru if not installed
if ! command -v paru &> /dev/null; then
    echo "paru is not installed. Installing paru..."
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

# Check and install flatpak if not installed
if ! command -v flatpak &> /dev/null; then
    echo "flatpak is not installed. Installing flatpak..."
    sudo pacman -S flatpak
fi

# Install packages
install_pacman_packages
install_paru_packages
install_flatpak_packages

# Set up configurations with stow
setup_stow

echo "All packages and configurations installed!"

