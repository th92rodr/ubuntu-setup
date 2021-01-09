#!/bin/bash

echo -e "\e[32m \nWhat is your user name? \e[0m"
read user_name

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

read -p $'\e[34m \nDo you want to install GIT ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  echo -e "\e[32m \n installing... \e[0m"
  apt install git -y

  echo -e "\e[32m \n what name do you want to use in GIT user.name? \e[0m"
  read git_config_user_name
  git config --global user.name $git_config_user_name

  echo -e "\e[32m \n what email do you want to use in GIT user.email? \e[0m"
  read git_config_user_email
  git config --global user.email $git_config_user_email

  git config --global core.editor "code --wait"

  echo -e "\e[34m \nGIT done \e[0m"
fi

############
# VSCODE

read -p $'\e[34m \nDo you want to install VSCode ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://code.visualstudio.com/docs/setup/linux
  echo -e "\e[32m \n installing... \e[0m"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  apt-get install apt-transport-https -y
  apt-get update
  apt-get install code -y

  # https://code.visualstudio.com/docs/editor/extension-gallery?pub=esbenp
  echo -e "\e[32m \n installing VSCode extensions \e[0m"
  sudo -u thiago code --install-extension VisualStudioExptTeam.vscodeintellicode
  sudo -u thiago code --install-extension christian-kohler.path-intellisense
  sudo -u thiago code --install-extension streetsidesoftware.code-spell-checker
  sudo -u thiago code --install-extension CoenraadS.bracket-pair-colorizer
  sudo -u thiago code --install-extension eamodio.gitlens
  sudo -u thiago code --install-extension esbenp.prettier-vscode
  sudo -u thiago code --install-extension arcticicestudio.nord-visual-studio-code

  cp ./config-files/vscode-settings.jsonc /home/$user_name/.config/Code/User/settings.json

  echo -e "\e[34m \nVSCode done \e[0m"
fi

############
# ZSH

read -p $'\e[34m \nDo you want to install ZSH ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
  echo -e "\e[32m \n installing... \e[0m"
  apt install zsh -y
  git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$user_name/.oh-my-zsh
  cp /home/$user_name/.oh-my-zsh/templates/zshrc.zsh-template /home/$user_name/.zshrc

  # https://draculatheme.com/zsh/
  echo -e "\e[32m \n installing ZSH dracula theme \e[0m"
  git clone https://github.com/dracula/zsh.git /home/$user_name/.dracula
  cp /home/$user_name/.dracula/dracula.zsh-theme /home/$user_name/.oh-my-zsh/themes/
  cp -r /home/$user_name/.dracula/lib/ /home/$user_name/.oh-my-zsh/themes/
  sed -i 's/ZSH_THEME=.*/ZSH_THEME="dracula"/g' /home/$user_name/.zshrc

  # https://draculatheme.com/gnome-terminal/
  echo -e "\e[32m \n installing gnome terminal dracula theme \e[0m"
  apt-get install dconf-cli
  git clone https://github.com/dracula/gnome-terminal /home/$user_name/gnome-terminal
  (cd /home/$user_name/gnome-terminal/ && ./install.sh)

  # https://github.com/zsh-users/zsh-autosuggestions
  # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  echo -e "\e[32m \n installing ZSH autosuggestions \e[0m"
  rm -rf /home/$user_name/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions /home/$user_name/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' /home/$user_name/.zshrc
  sed -i 's/ZSH=$HOME/.oh-my-zsh/ZSH=/home/$user_name/.oh-my-zsh/g' /home/$user_name/.zshrc

  exec zsh
  source /home/$user_name/.zshrc
  chsh -s /bin/zsh
  exec bash

  echo -e "\e[34m \nZSH done \e[0m"
fi

############

read -p $'\e[34m \nDo you want to install bat ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://github.com/sharkdp/bat
  # https://github.com/sharkdp/bat/releases
  echo -e "\e[32m \n installing... \e[0m"
  wget https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-musl_0.15.4_amd64.deb -O bat.deb
  dpkg -i bat.deb
  rm bat.deb

  echo -e "\e[34m \nbat done \e[0m"
fi

read -p $'\e[34m \nDo you want to install fd ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://github.com/sharkdp/fd
  # https://github.com/sharkdp/fd/releases
  echo -e "\e[32m \n installing... \e[0m"
  wget https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-musl_8.1.1_amd64.deb -O fd.deb
  dpkg -i fd.deb
  rm fd.deb

  echo -e "\e[34m \nfd done \e[0m"
fi

read -p $'\e[34m \nDo you want to install tig ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://github.com/jonas/tig
  # https://github.com/jonas/tig/blob/master/INSTALL.adoc
  echo -e "\e[32m \n installing... \e[0m"
  git clone git://github.com/jonas/tig.git
  apt-get install build-essential -y
  (cd ./tig/ && make)
  (cd ./tig/ && make install)
  rm -rf tig/

  echo -e "\e[34m \ntig done \e[0m"
fi

############
# DOCKER

read -p $'\e[34m \nDo you want to install Docker ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://docs.docker.com/engine/install/ubuntu/
  echo -e "\e[32m \n installing... \e[0m"
  apt-get remove docker docker-engine docker.io containerd runc
  apt-get update
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io -y

  usermod -aG docker $user_name

  echo -e "\e[34m \nDocker done \e[0m"

  # https://docs.docker.com/compose/install/
  # https://github.com/docker/compose/releases
  echo -e "\e[32m \n installing docker compose... \e[0m"
  curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  echo -e "\e[34m \nDocker Compose done \e[0m"
fi

############
# NODE

read -p $'\e[34m \nDo you want to install Node ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://nodejs.org/en/
  # https://github.com/nodesource/distributions/blob/master/README.md
  echo -e "\e[32m installing... \e[0m"
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  apt-get install -y nodejs

  echo -e "\e[34m \nNode done \e[0m"
fi

read -p $'\e[34m \nDo you want to install yarn ? [y,n] \e[0m' answer
if [[ $answer = y ]] ; then
  # https://classic.yarnpkg.com/en/
  # https://classic.yarnpkg.com/en/docs/install#debian-stable
  echo -e "\e[32m installing... \e[0m"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
  apt install yarn -y

  echo -e "\e[34m \nyarn done \e[0m"
fi

echo -e "\e[32m \n All set \e[0m"
