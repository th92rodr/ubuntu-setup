#!/bin/bash

source ./func.sh

main () {
  sudo apt update && sudo apt upgrade -y

  basic_packages=(curl wget unzip make gnome-tweaks gcc g++ build-essential tree)

  for package in "${basic_packages[@]}"; do
    safe_install "$package"
  done
}

main "$@"
