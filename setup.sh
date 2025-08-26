#!/bin/bash

source ./func.sh

main () {
  check_os

  sudo apt update && sudo apt upgrade -y

  basic_packages=(curl wget unzip make gnome-tweaks gcc g++ build-essential)

  for package in "${basic_packages[@]}"; do
    safe_install "$package"
  done

  additional_packages=(tree fzf peco)

  for package in "${additional_packages[@]}"; do
    safe_install "$package"
  done

  packages=(git brave zsh homebrew vscode docker nvm node yarn tig pyenv bat fd
          protoc kubernetes gcloud golang postman java)

  for package in "${packages[@]}"; do
    "install_$package"
  done
}

check_os () {
  os=$(uname)
  if [ "$os" != "Linux" ]; then
    log error "OS not supported. Only Linux is supported"
    exit 1
  fi
  if ! [[ -f /etc/debian_version ]]; then
    log error "OS not supported. Only Debian-based distros are supported (like Ubuntu)"
    exit 1
  fi
}

main "$@"
