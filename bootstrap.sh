#!/usr/bin/env bash
set -e
set -x
# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
# Define variables
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"

# Ensure required environment variables are set
env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")
for env_var in "${env_variables[@]}"; do
    if [ -z "${!env_var}" ]; then
        echo "Error: $env_var is not set"
        exit 1
    fi
done

# Install dependencies based on OS
if [[ $(uname) == 'Linux' ]]; then
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt-get update -y
    sudo apt-get install ansible software-properties-common git -y
elif [[ $(uname) == 'Darwin' ]]; then
    xcode-select --install
    brew install ansible
fi

# Check if dotfiles directory exists, clone repo if not
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning $DOTFILES_REPO into $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules --depth=1
    # shellcheck source=/dev/null
    source "$DOTFILES_DIR/playbooks/install"
    # Reset git config if needed
    # git config --global --unset commit.gpgsign
    # git config --global --unset gpg.format
    # git config --global --unset gpg.ssh.allowedsignersfile
    # git config --global --unset gpg.ssh.program
    # git config --global --unset user.email
    # git config --global --unset user.name
    # git config --global --unset user.signingkey
fi
