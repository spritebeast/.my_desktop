#!/bin/bash

set -e

echo ">>> system update"
sudo apt update && sudo apt upgrade -y

echo ">>> install overall programs"
sudo apt install -y curl wget unzip

echo ">>> install git & settings"
sudo apt install -y git
read -p "user.name: " git_username
if [ -n "$git_username" ]; then
    git config --global user.name "$git_username"
    echo "added user.name"
else
    echo "error: user.name is empty"
fi
read -p "user.email: " git_email
if [ -n "$git_email" ]; then
    git config --global user.email "$git_email"
    echo "added user.email"
else
    echo "error: user.email is empty"
fi
git config --global credential.helper store
echo "git token saved for next pushing"

echo ">>> install graphics drivers"
sudo apt install -y firmware-linux firmware-intel-graphics intel-media-va-driver-non-free

echo ">>> install codecs"
sudo apt install -y ffmpeg libavcodec-extra libdvdread4 libdvdcss2

echo ">>> install node.js + npm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24

echo ">>> install python + pip"
sudo apt install -y python3 python3-pip python3-venv python3-dev

echo ">>> install love2d"
sudo apt install -y love

echo ">>> install directories"
mkdir -p ~/dev/js-dev
mkdir -p ~/dev/love-dev
mkdir -p ~/dev/py-dev

echo ">>> install vscode"
sudo apt install -y wget gpg apt-transport-https
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | \
sudo tee /usr/share/keyrings/vscode.gpg >/dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | \
sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update -y
sudo apt install -y code

echo ">>> install terminal"
sudo apt install -y alacritty zsh

echo ">>> copy alacritty .config"
cp -r /.config/alacritty ~/.config/alacritty

echo ">>> install catppuccin theme"
git clone https://github.com/orangci/walls-catppuccin-mocha catppuccin-wallpapers
git clone https://github.com/catppuccin/alacritty catppuccin-alacritty-themes
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde-theme

echo ">>> install jetbrains fonts"
cp -r .fonts/ ~/.local/share/fonts/jetbrains/

echo ">>> install flatpak & flathub repo"
sudo apt install -y flatpak plasma-discover-backend-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo ">>> install flathub programs"
sudo flatpak install -y flathub com.google.Chrome com.spotify.Client com.discordapp.Discord com.jetbrains.PyCharm-Professional com.prusa3d.PrusaSlicer io.mrarm.mcpelauncher com.mojang.Minecraft

echo ">>> cleaning"
sudo apt autoremove -y
sudo apt clean

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
