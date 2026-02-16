#!/bin/bash

source ./func.sh
source ./utils.sh

set -o errexit -o errtrace -o nounset -o pipefail
trap error_handler ERR

main () {
  check_os
  # sudo_keep_alive

  log info "Starting..."

  sudo DEBIAN_FRONTEND=noninteractive apt-get update --quiet --quiet
  sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes --quiet --quiet

  configure_timezone

  local -r basic_packages=(curl wget unzip make gnome-tweaks gcc g++ build-essential)

  for package in "${basic_packages[@]}"; do
    safe_install "$package"
  done

  local -r additional_packages=(tree fzf peco)

  for package in "${additional_packages[@]}"; do
    safe_install "$package"
  done

  local -r packages=(git brave zsh homebrew vscode docker nvm node yarn tig pyenv bat fd
              protoc kubernetes gcloud golang postman java)

  for package in "${packages[@]}"; do
    "install_$package"
  done

  if [ -f "$HOME/.bashrc" ]; then
    /bin/bash <<-EOF
			source $HOME/.bashrc
		EOF
  fi

  if [ -f "$HOME/.zshrc" ]; then
    /bin/zsh <<-EOF
			source $HOME/.zshrc
		EOF
  fi

  log success "Finished"
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

sudo_keep_alive () {
  # Ask for the password once
  if ! sudo --validate; then
    log error "This script needs sudo access to continue"
    exit 1
  fi

  # Update existing `sudo` timestamp until script ends
  (
    while true; do
      sudo --non-interactive true
      sleep 60
    done
  ) </dev/null >/dev/null 2>&1 &

  SUDO_PID=$!
  # Clean up keep-alive on script exit
  trap 'kill "$SUDO_PID" 2>/dev/null' EXIT
}

usage () {
  cat <<-EOF
		USAGE:
		  $(basename "$0") [options]

		OPTIONS:
		  -h, --help    Show this help message and exit

		DESCRIPTION:
		  Installs and configures common development tools
		  on Debian-based Linux systems.
	EOF
}

parse_args () {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      *)
        log error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
    shift
  done
}

parse_args "$@"
main "$@"
