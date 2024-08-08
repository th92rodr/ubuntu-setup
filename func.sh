#!/bin/bash

func_initial () {
  sudo apt update && sudo apt upgrade -y
  sudo apt install curl wget gnome-tweaks \
    gcc g++ make build-essential -y
}

func_final () {
  sudo apt autoremove -y
  sudo apt autoclean
  sudo apt clean
}

fn_git () {
  if [ $1 -eq 1 ]; then
    echo -e "\e[32mInstalling GIT\e[0m"
    sudo apt install git -y
    if [ $? -ne 0 ]; then
      echo "failed"
    fi
  fi

  # cp ./config-files/gitconfig /home/$USER/.gitconfig
  cp ./config-files/gitconfig /home/$USER/www/gitconfig
  if [ $? -ne 0 ]; then
    echo "failed"
  fi

  # echo -e "\e[32mwhat name do you want to use in GIT user.name?\e[0m"
  # read git_config_user_name
  # git config --global user.name $git_config_user_name

  # echo -e "\e[32mwhat email do you want to use in GIT user.email?\e[0m"
  # read git_config_user_email
  # git config --global user.email $git_config_user_email

  # git config --global core.editor "code --wait"
}

fn_node () {
  # https://nodejs.org/en/
  # https://github.com/nodesource/distributions/blob/master/README.md
  echo -e "\e[32mInstalling Node\e[0m"
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install nodejs -y

  # https://classic.yarnpkg.com/en/
  # https://classic.yarnpkg.com/en/docs/install#debian-stable
  echo -e "\e[32mInstalling Yarn\e[0m"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
  sudo apt install yarn -y
}

fn_homebrew () {
  # https://brew.sh/
  # Will be installed at /home/linuxbrew/.linuxbrew
  echo -e "\e[32mInstalling Homebrew\e[0m"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/$USER/.profile
  # echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/$USER/.bashrc
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  source /home/$USER/.profile
}

fn_vscode () {
  # https://code.visualstudio.com/docs/setup/linux
  echo -e "\e[32mInstalling VSCode\e[0m"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt install apt-transport-https -y
  sudo apt update
  sudo apt install code -y

  # https://code.visualstudio.com/docs/editor/extension-gallery?pub=esbenp
  echo -e "\e[32mInstalling VSCode Extensions\e[0m"
  code --install-extension VisualStudioExptTeam.vscodeintellicode
  code --install-extension christian-kohler.path-intellisense
  code --install-extension streetsidesoftware.code-spell-checker
  code --install-extension CoenraadS.bracket-pair-colorizer
  code --install-extension eamodio.gitlens
  code --install-extension esbenp.prettier-vscode
  code --install-extension arcticicestudio.nord-visual-studio-code
  code --install-extension azemoh.one-monokai

  cp ./config-files/vscode-settings.jsonc /home/$USER/.config/Code/User/settings.json
}

fn_golang () {
  # https://go.dev/doc/install
  # https://go.dev/dl/
  echo -e "\e[32mInstalling Golang\e[0m"

  wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz -O go.tar.gz
  tar -C /usr/local -xzf go.tar.gz

  echo "# Golang
export PATH=\$PATH:/usr/local/go/bin
export GOPATH=/home/$USER/golib
export PATH=\$PATH:\$GOPATH/bin
export GOPATH=\$GOPATH:/home/$USER/code" >> /home/$USER/.bashrc
  source /home/$USER/.bashrc

  echo "# Golang
export PATH=\$PATH:/usr/local/go/bin
export GOPATH=/home/$USER/golib
export PATH=\$PATH:\$GOPATH/bin
export GOPATH=\$GOPATH:/home/$USER/code" >> /home/$USER/.zshrc

  mkdir -p /home/$USER/code
  mkdir -p /home/$USER/golib

  go get -u golang.org/x/lint/golint
  go get -u github.com/golang/dep/cmd/dep
  go get -u github.com/mdempsky/gocode
  go get -u github.com/uudashr/gopkgs/v2/cmd/gopkgs
  go get -u github.com/ramya-rao-a/go-outline
  go get -u github.com/acroca/go-symbols
  go get -u golang.org/x/tools/cmd/guru
  go get -u golang.org/x/tools/cmd/gorename
  go get -u github.com/cweill/gotests/...
  go get -u github.com/fatih/gomodifytags
  go get -u github.com/josharian/impl
  go get -u github.com/davidrjenni/reftools/cmd/fillstruct
  go get -u github.com/haya14busa/goplay/cmd/goplay
  go get -u github.com/godoctor/godoctor
  go get -u github.com/go-delve/delve/cmd/dlv
  go get -u github.com/stamblerre/gocode
  go get -u github.com/rogpeppe/godef
}

fn_docker () {
  # https://docs.docker.com/engine/install/ubuntu/
  echo -e "\e[32mInstalling Docker\e[0m"
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

  usermod -aG docker $USER

  # https://docs.docker.com/compose/install/
  # https://github.com/docker/compose/releases
  echo -e "\e[32mInstalling Docker Compose\e[0m"
  curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

fn_kubernetes () {
  # https://kubernetes.io/docs/tasks/tools/install-kubectl/
  echo -e "\e[32mInstalling Kubernetes CLI\e[0m"

  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x ./kubectl
  mv ./kubectl /usr/local/bin/kubectl

  # autocompletion
  sudo apt-get install bash-completion -y
  echo "source <(kubectl completion bash)" >> /home/$USER/.bashrc
  echo "source <(kubectl completion zsh)" >> /home/$USER/.zshrc

  # kubectx
  # https://github.com/ahmetb/kubectx
  wget https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx_v0.9.1_linux_x86_64.tar.gz
  wget https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens_v0.9.1_linux_x86_64.tar.gz
  tar -xzf kubectx_v0.9.1_linux_x86_64.tar.gz
  tar -xzf kubens_v0.9.1_linux_x86_64.tar.gz
  mv kubectx kubens /usr/local/bin
  rm -rf kubectx_v0.9.1_linux_x86_64.tar.gz kubens_v0.9.1_linux_x86_64.tar.gz

  # brew install kubectx
}

fn_gcs () {
  # https://cloud.google.com/sdk/docs/install#deb
  echo -e "\e[32mInstalling Google Cloud SDK\e[0m"

  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get install apt-transport-https ca-certificates gnupg -y
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  sudo apt-get update
  sudo apt-get install google-cloud-sdk -y

  # execute the following to configure
  # gcloud init
}

fn_protoc () {
  # https://google.github.io/proto-lens/installing-protoc.html
  PROTOC_ZIP=protoc-3.14.0-linux-x86_64.zip
  curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
  unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
  unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
  rm -f $PROTOC_ZIP
}

fn_postman () {
  # https://www.postman.com/downloads/
  echo -e "\e[32mInstalling Postman\e[0m"

  wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
  tar -xzf postman.tar.gz
  rm -rf /opt/Postman
  mv -f Postman /opt
  rm postman.tar.gz

  # create desktop shortcut
  touch /usr/share/applications/postman.desktop
  echo "[Desktop Entry]
Type=Application
Name=Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Exec="/opt/Postman/Postman"
Comment=Postman Desktop App
Categories=Development;Code;" > /usr/share/applications/postman.desktop
}

fn_java () {
  # https://openjdk.java.net/install/
  wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz -O jdk11.tar.gz
  mkdir /usr/lib/jvm
  tar -C /usr/lib/jvm -xvf jdk11.tar.gz
  rm jdk11.tar.gz

  echo "# JAVA
export PATH=\$PATH:/usr/lib/jvm/jdk-11/bin
export JAVA_HOME=/usr/lib/jvm/jdk-11" >> /home/$USER/.bashrc

  echo "# JAVA
export PATH=\$PATH:/usr/lib/jvm/jdk-11/bin
export JAVA_HOME=/usr/lib/jvm/jdk-11" >> /home/$USER/.zshrc

  # https://maven.apache.org/install.html
  wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O apache-maven.tar.gz
  tar -C /opt -xzvf apache-maven.tar.gz
  rm apache-maven.tar.gz
  mv /opt/apache-maven-3.6.3 /opt/apache-maven

  echo "export PATH=\$PATH:/opt/apache-maven/bin" >> /home/$USER/.bashrc
  echo "export PATH=\$PATH:/opt/apache-maven/bin" >> /home/$USER/.zshrc
}

fn_zsh () {
  # https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
  echo -e "\e[32m Installing ZSH\e[0m"
  sudo apt install zsh -y
  git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$USER/.oh-my-zsh
  cp /home/$USER/.oh-my-zsh/templates/zshrc.zsh-template /home/$USER/.zshrc

  # https://draculatheme.com/zsh/
  echo -e "\e[32mInstalling ZSH dracula theme\e[0m"
  git clone https://github.com/dracula/zsh.git /home/$USER/.dracula
  cp /home/$USER/.dracula/dracula.zsh-theme /home/$USER/.oh-my-zsh/themes/
  cp -r /home/$USER/.dracula/lib/ /home/$USER/.oh-my-zsh/themes/
  sed -i 's/ZSH_THEME=.*/ZSH_THEME="dracula"/g' /home/$USER/.zshrc

  # https://draculatheme.com/gnome-terminal/
  echo -e "\e[32mInstalling gnome terminal dracula theme\e[0m"
  sudo apt-get install dconf-cli -y
  git clone https://github.com/dracula/gnome-terminal /home/$USER/gnome-terminal
  (cd /home/$USER/gnome-terminal/ && ./install.sh)

  # https://github.com/zsh-users/zsh-autosuggestions
  # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  echo -e "\e[32mInstalling ZSH autosuggestions\e[0m"
  rm -rf /home/$USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions /home/$USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' /home/$USER/.zshrc
  sed -i 's/ZSH=$HOME/.oh-my-zsh/ZSH=/home/$USER/.oh-my-zsh/g' /home/$USER/.zshrc

  /bin/zsh << 'EOF'
source ~/.zshrc
chsh -s /bin/zsh
EOF
}

fn_bat () {
  # https://github.com/sharkdp/bat
  # https://github.com/sharkdp/bat/releases
  echo -e "\e[32mInstalling BAT\e[0m"
  wget https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-musl_0.15.4_amd64.deb -O bat.deb
  dpkg -i bat.deb
  rm bat.deb

  # apt install bat
}

fn_fd () {
  # https://github.com/sharkdp/fd
  # https://github.com/sharkdp/fd/releases
  echo -e "\e[32mInstalling FD\e[0m"
  wget https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-musl_8.1.1_amd64.deb -O fd.deb
  dpkg -i fd.deb
  rm fd.deb
}

fn_tig () {
  # https://github.com/jonas/tig
  # https://github.com/jonas/tig/blob/master/INSTALL.adoc
  echo -e "\e[32mInstalling TIG\e[0m"
  # git clone git://github.com/jonas/tig.git
  # (cd ./tig/ && make)
  # (cd ./tig/ && make install)
  # rm -rf tig/

  brew install tig
}

fn_fzf () {
  # https://github.com/junegunn/fzf
  sudo apt-get install fzf -y
}

fn_pyenv () {
  # https://github.com/pyenv/pyenv
  brew update
  brew install pyenv
}

clear_screen () {
  echo -e "\033c"
}
