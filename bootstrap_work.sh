#!/bin/bash
set -e
set -u
# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  echo "Bash is required to interpret this script."
  exit 1
fi
#declare -r DOTFILES_DIR=${DOTFILES_DIR:-"$HOME/.dotfiles"}
# # shellcheck disable=SC1091
# source "$DOTFILES_DIR/lib/log.sh"
# # Install dependencies based on OS
# # shellcheck disable=SC1091
# source "$DOTFILES_DIR/lib/utils.sh"

# # shellcheck disable=SC2154
# if [[ "$os_family" != 'Darwin' ]]; then
#     echo "Setup script is only for macOS."
#     abort 1
# fi

# shellcheck disable=SC2034
export OS_FAMILY_OVERRIDE="setup_mac_work"

# shellcheck disable=SC1091
source "bootstrap.sh"
