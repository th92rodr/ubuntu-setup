#!/bin/bash

error_handler () {
  local exit_code=$?

  log error "Error: command '${BASH_COMMAND}' failed with exit code ${exit_code}"
  log error "Location: ${BASH_SOURCE[1]}:${BASH_LINENO[0]} (function: ${FUNCNAME[1]})"
  log error "Stack trace:"

  for i in "${!FUNCNAME[@]}"; do
    if [ "$i" -gt 0 ]; then
      log error "  at ${FUNCNAME[$i]}() in ${BASH_SOURCE[$i]}:${BASH_LINENO[$((i-1))]}"
    fi
  done

  exit 1
}

soft_fail () {
  if ! "$@"; then
    log warn "Error: $*"
  fi
}

configure_timezone () {
  sudo ln --force --symbolic /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
}
