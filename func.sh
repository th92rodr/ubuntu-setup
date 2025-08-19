#!/bin/bash

log () {
  local level="$1"
  local msg="$2"
  local color=""
  case "$level" in
    info) color="\033[1;36m";;
    success) color="\033[1;32m";;
    warn) color="\033[1;33m";;
    error) color="\033[1;35m";;
    *) color="";;
  esac
  echo -e "${color}[$(date)] $msg\033[0m"
}

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

safe_install () {
  local pkg="$1"
  if dpkg --status "$pkg" &>/dev/null; then
    log info "$pkg already installed"
  else
    log info "Installing $pkg..."
    sudo apt install -y "$pkg"
  fi
}

install_git () {
  if ! command -v git &>/dev/null; then
    log info "Installing git"
    sudo apt install git -y

    log info "git username:"
    read git_config_user_name
    log info "git email:"
    read git_config_user_email

    cp ./config-files/gitconfig $HOME/.gitconfig
    git config --global user.name $git_config_user_name
    git config --global user.email $git_config_user_email
    git config --global core.editor "code --wait"
  else
    log info "git already installed"
  fi
}

install_brave () {
  # https://brave.com/linux/

  if ! command -v brave-browser &>/dev/null; then
    log info "Installing brave"
    curl -fsS https://dl.brave.com/install.sh | sh
  else
    log info "brave already installed"
  fi
}

install_homebrew () {
  # https://brew.sh/
  # Will be installed at /home/linuxbrew/.linuxbrew

  if ! command -v brew &>/dev/null; then
    log info "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo >> $HOME/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    log info "homebrew already installed"
  fi
}

install_vscode () {
  # https://code.visualstudio.com/docs/setup/linux
  # https://code.visualstudio.com/docs/editor/extension-gallery?pub=esbenp

  if ! command -v code &>/dev/null; then
    log info "Installing vscode"

    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https -y
    sudo apt update
    sudo apt install code -y

    log info "Installing vscode extensions"
    code --install-extension visualstudioexptteam.vscodeintellicode
    code --install-extension christian-kohler.path-intellisense
    code --install-extension streetsidesoftware.code-spell-checker
    # code --install-extension coenraads.bracket-pair-colorizer
    code --install-extension eamodio.gitlens
    code --install-extension golang.go
    code --install-extension biomejs.biome
    code --install-extension esbenp.prettier-vscode
    code --install-extension prisma.prisma
    code --install-extension mikestead.dotenv
    code --install-extension ms-python.python
    code --install-extension humao.rest-client
    code --install-extension alexcvzz.vscode-sqlite
    code --install-extension bradlc.vscode-tailwindcss
    code --install-extension beardedbear.beardedicons
    code --install-extension miguelsolorio.min-theme
    # code --install-extension azemoh.one-monokai

    cp ./config-files/vscode-settings.jsonc $HOME/.config/Code/User/settings.json
  else
    log info "vscode already installed"
  fi
}

install_docker () {
  # https://docs.docker.com/engine/install/ubuntu/
  # https://docs.docker.com/compose/install/
  # https://github.com/docker/compose/releases

  if ! command -v docker &>/dev/null; then
    log info "Installing docker"

    sudo apt update
    sudo apt install apt-transport-https ca-certificates gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y

    log info "Installing docker compose"

    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    log info "docker already installed"
  fi
}

install_nvm () {
  # https://github.com/nvm-sh/nvm

  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    log info "Installing nvm"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  else
    log info "nvm already installed"
  fi

  dotfiles=(.bashrc .zshrc)
  for dotfile in "${dotfiles[@]}"; do
    if ! grep -q 'export NVM_DIR' "$dotfile"; then
      cat <<-EOF >> "$dotfile"

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi
  done
}

install_node () {
  # https://nodejs.org/en/
  # https://github.com/nodesource/distributions/blob/master/README.md

  if ! command -v node &>/dev/null; then
    log info "Installing node"

    curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install nodejs -y
  else
    log info "node already installed"
  fi
}

install_yarn () {
  # https://classic.yarnpkg.com/en/
  # https://classic.yarnpkg.com/en/docs/install#debian-stable

  if ! command -v yarn &>/dev/null; then
    log info "Installing yarn"

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt install yarn -y
  else
    log info "yarn already installed"
  fi
}

install_tig () {
  # https://github.com/jonas/tig
  # https://github.com/jonas/tig/blob/master/INSTALL.adoc

  if ! command -v tig &>/dev/null; then
    log info "Installing tig"

    brew install tig
    # git clone git://github.com/jonas/tig.git
    # (cd ./tig/ && make)
    # (cd ./tig/ && make install)
    # rm -rf tig/
  else
    log info "tig already installed"
  fi
}

install_pyenv () {
  # https://github.com/pyenv/pyenv

  if ! command -v pyenv &>/dev/null; then
    log info "Installing pyenv"
    brew update
    brew install pyenv
  else
    log info "pyenv already installed"
  fi
}

install_bat () {
  # https://github.com/sharkdp/bat
  # https://github.com/sharkdp/bat/releases

  if ! command -v bat &>/dev/null; then
    log info "Installing bat"

    wget https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-musl_0.15.4_amd64.deb -O bat.deb
    sudo dpkg -i bat.deb
    rm bat.deb
  else
    log info "bat already installed"
  fi
}

install_fd () {
  # https://github.com/sharkdp/fd
  # https://github.com/sharkdp/fd/releases

  if ! command -v fd &>/dev/null; then
    log info "Installing fd"

    wget https://github.com/sharkdp/fd/releases/download/v8.1.1/fd-musl_8.1.1_amd64.deb -O fd.deb
    sudo dpkg -i fd.deb
    rm fd.deb
  else
    log info "fd already installed"
  fi
}

install_fzf () {
  # https://github.com/junegunn/fzf

  if ! command -v fzf &>/dev/null; then
    log info "Installing fzf"
    sudo apt install fzf -y
  else
    log info "fzf already installed"
  fi
}

install_protoc () {
  # https://google.github.io/proto-lens/installing-protoc.html

  if ! command -v protoc &>/dev/null; then
    log info "Installing protoc"

    PROTOC_ZIP=protoc-3.14.0-linux-x86_64.zip
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
    sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
    sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
    rm -f $PROTOC_ZIP
  else
    log info "protoc already installed"
  fi
}

install_kubernetes () {
  # https://kubernetes.io/docs/tasks/tools/install-kubectl/
  # https://github.com/ahmetb/kubectx

  if ! command -v kubectl &>/dev/null; then
    log info "Installing kubernetes cli"

    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    # autocompletion
    sudo apt install bash-completion -y
    echo >> $HOME/.bashrc
    echo "source <(kubectl completion bash)" >> $HOME/.bashrc
    echo >> $HOME/.zshrc
    echo "source <(kubectl completion zsh)" >> $HOME/.zshrc

    # kubectx
    wget https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx_v0.9.1_linux_x86_64.tar.gz
    wget https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens_v0.9.1_linux_x86_64.tar.gz
    tar -xzf kubectx_v0.9.1_linux_x86_64.tar.gz
    tar -xzf kubens_v0.9.1_linux_x86_64.tar.gz
    sudo mv kubectx kubens /usr/local/bin
    rm -rf kubectx_v0.9.1_linux_x86_64.tar.gz kubens_v0.9.1_linux_x86_64.tar.gz

    # brew install kubectx
  else
    log info "kubernetes cli already installed"
  fi
}

install_gcloud () {
  # https://cloud.google.com/sdk/docs/install#deb

  if ! command -v gcloud &>/dev/null; then
    log info "Installing google cloud sdk"

    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt install apt-transport-https ca-certificates gnupg -y
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt update
    sudo apt install google-cloud-sdk -y

    # execute the following to configure
    # gcloud init
  else
    log info "google cloud sdk already installed"
  fi
}

install_zsh () {
  # https://dev.to/mskian/install-z-shell-oh-my-zsh-on-ubuntu-1804-lts-4cm4
  # https://draculatheme.com/zsh/
  # https://draculatheme.com/gnome-terminal/
  # https://github.com/zsh-users/zsh-autosuggestions
  # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

  if ! command -v zsh &>/dev/null; then
    log info "Installing zsh"

    ZSH_PATH=$HOME/.oh-my-zsh

    sudo apt install zsh -y
    git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH_PATH
    cp $ZSH_PATH/templates/zshrc.zsh-template $HOME/.zshrc

    log info "Installing zsh dracula theme"

    git clone https://github.com/dracula/zsh.git $HOME/.dracula
    cp $HOME/.dracula/dracula.zsh-theme $ZSH_PATH/themes/
    cp -r $HOME/.dracula/lib/ $ZSH_PATH/themes/
    rm -rf $HOME/.dracula
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="dracula"/g' $HOME/.zshrc

    log info "Installing gnome terminal dracula theme"

    sudo apt install dconf-cli -y
    git clone https://github.com/dracula/gnome-terminal $HOME/gnome-terminal
    (cd $HOME/gnome-terminal/ && ./install.sh)
    rm -rf $HOME/gnome-terminal

    log info "Installing zsh autosuggestions"

    rm -rf $ZSH_PATH/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PATH/custom/plugins/zsh-autosuggestions
    sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' $HOME/.zshrc

    /bin/zsh << 'EOF'
source $HOME/.zshrc
sudo chsh -s /bin/zsh
EOF

  else
    log info "zsh already installed"
  fi
}

install_golang () {
  # https://go.dev/doc/install
  # https://go.dev/dl/

  if ! command -v go &>/dev/null; then
    log info "Installing golang"

    wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz -O go.tar.gz
    sudo tar -C /usr/local -xzf go.tar.gz
    rm -rf go.tar.gz

    dotfiles=(.bashrc .zshrc)
    for dotfile in "${dotfiles[@]}"; do
      if ! grep -q "/usr/local/go/bin" "$HOME/$dotfile"; then
        echo "
# Golang
export PATH=\$PATH:/usr/local/go/bin
export GOPATH=\$HOME/golib
export PATH=\$PATH:\$GOPATH/bin
export GOPATH=\$GOPATH:\$HOME/gocode" >> $HOME/$dotfile
      fi
    done

    mkdir -p $HOME/gocode
    mkdir -p $HOME/golib

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
  else
    log info "golang already installed"
  fi
}

install_postman () {
  # https://www.postman.com/downloads/

  if ! command -v postman &>/dev/null; then
    log info "Installing postman"

    wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
    tar -xzf postman.tar.gz
    sudo rm -rf /opt/Postman
    sudo mv -f Postman /opt
    rm postman.tar.gz

    sudo ln -sf /opt/Postman/Postman /usr/local/bin/postman

    # create desktop shortcut
    echo "[Desktop Entry]
Type=Application
Name=Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Exec="/opt/Postman/Postman"
Comment=Postman Desktop App
Categories=Development;Code;" > postman.desktop
    sudo mv postman.desktop /usr/share/applications/
  else
    log info "postman already installed"
  fi
}

install_java () {
  # https://openjdk.java.net/install/
  # https://maven.apache.org/install.html

  if ! command -v java &>/dev/null; then
    log info "Installing java"

    wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz -O jdk11.tar.gz
    sudo rm -rf /usr/lib/jvm
    sudo mkdir /usr/lib/jvm
    sudo tar -C /usr/lib/jvm -xvf jdk11.tar.gz
    rm jdk11.tar.gz

    dotfiles=(.bashrc .zshrc)
    for dotfile in "${dotfiles[@]}"; do
      echo "
# JAVA
export PATH=\$PATH:/usr/lib/jvm/jdk-11/bin
export JAVA_HOME=/usr/lib/jvm/jdk-11" >> $HOME/$dotfile
    done

    # wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O apache-maven.tar.gz
    # sudo tar -C /opt/apache-maven -xzvf apache-maven.tar.gz
    # rm apache-maven.tar.gz

    # echo "export PATH=\$PATH:/opt/apache-maven/bin" >> $HOME/.bashrc
    # echo "export PATH=\$PATH:/opt/apache-maven/bin" >> $HOME/.zshrc
  else
    log info "java already installed"
  fi
}
