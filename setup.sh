#!/bin/bash

source ./func.sh

main () {
  sudo apt update && sudo apt upgrade -y

  basic_packages=(curl wget unzip make gnome-tweaks gcc g++ build-essential tree)

  for package in "${basic_packages[@]}"; do
    safe_install "$package"
  done

  packages=(git brave zsh homebrew vscode docker nvm node yarn tig pyenv bat fd fzf
          protoc kubernetes gcloud golang postman java)

  for package in "${packages[@]}"; do
    "install_$package"
  done
}

main "$@"
