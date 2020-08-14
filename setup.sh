#!/bin/bash

apt update
apt upgrade -y

echo -e "\e[32m \n installing curl \e[0m"
apt install curl -y
echo -e "\e[32m \n installing wget \e[0m"
apt install wget -y
echo -e "\e[32m \n installing gnome-tweaks \e[0m"
apt install gnome-tweaks -y

############
# GIT

echo -e "\e[32m installing git \e[0m"
sudo apt install git -y

echo "\e[32m what name do you want to use in GIT user.name? \e[0m"
read git_config_user_name
git config --global user.name "$git_config_user_name"

echo "\e[32m what email do you want to use in GIT user.email? \e[0m"
read git_config_user_email
git config --global user.email $git_config_user_email

git config --global core.editor "code --wait"

clear

############
# VS CODE

# https://code.visualstudio.com/docs/setup/linux
echo -e "\e[32m installing vscode \e[0m"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y

# https://code.visualstudio.com/docs/editor/extension-gallery?pub=esbenp
echo -e "\e[32m installing vscode extensions \e[0m"
code --install-extension VisualStudioExptTeam.vscodeintellicode
code --install-extension christian-kohler.path-intellisense
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension CoenraadS.bracket-pair-colorizer
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension arcticicestudio.nord-visual-studio-code

############
# ZSH

# https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
echo -e "\e[32m installing zsh \e[0m"
sudo apt install zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# https://draculatheme.com/zsh/
echo -e "\e[32m installing zsh dracula theme \e[0m"
git clone https://github.com/dracula/zsh.git ~/.dracula
cp .dracula/dracula.zsh-theme .oh-my-zsh/themes/
cp -r .dracula/lib/ .oh-my-zsh/themes/
sed -i 's/ZSH_THEME=.*/ZSH_THEME="dracula"/g' ~/.zshrc

# https://draculatheme.com/gnome-terminal/
echo -e "\e[32m installing gnome terminal dracula theme \e[0m"
sudo apt-get install dconf-cli
git clone https://github.com/dracula/gnome-terminal
(cd gnome-terminal/ && install.sh)

# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
echo -e "\e[32m installing zsh autosuggestions \e[0m"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc

source ~/.zshrc
chsh -s /bin/zsh

############

# https://github.com/sharkdp/bat
# https://github.com/sharkdp/bat/releases
echo -e "\e[32m installing bat \e[0m"
curl https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-musl_0.15.4_amd64.deb -o bat.deb
dpkg -i bat.deb

# https://github.com/sharkdp/fd
# https://github.com/sharkdp/fd/releases
echo -e "\e[32m installing fd \e[0m"
curl https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-musl_8.1.1_amd64.deb -o fd.deb
dpkg -i fd.deb

# https://github.com/jonas/tig
# https://github.com/jonas/tig/blob/master/INSTALL.adoc
echo -e "\e[32m installing tig \e[0m"
git clone git://github.com/jonas/tig.git ~/Downloads
(cd ~/Downloads/tig/ && make)
(cd ~/Downloads/tig/ && make install)

############
# DOCKER

echo -e "\e[32m installing docker \e[0m"
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

############

# https://nodejs.org/en/
# https://github.com/nodesource/distributions/blob/master/README.md
echo -e "\e[32m installing node \e[0m"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y nodejs

# https://classic.yarnpkg.com/en/
# https://classic.yarnpkg.com/en/docs/install#debian-stable
echo -e "\e[32m installing yarn \e[0m"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt install yarn
