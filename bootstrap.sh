#!/usr/bin/env bash
set -e
set -x
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"

env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")

for env_var in "${env_variables[@]}"; do
    # Check if the variable is set
    if [ -z "${!env_var}" ]; then
        echo "Error: $env_var is not set"
        exit 1
    fi
done

if [[ $(uname) == 'Linux' ]]; then
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update -y
    sudo apt-get install ansible software-properties-common git -y
elif [[ $(uname) == 'Darwin' ]]; then
    xcode-select --install
    brew install ansible
fi


# First we need to check and see if the original dotfiles repo structure is in
# place. If it is, back it up and clone the new structure and setup.
if [ ! -d "$DOTFILES_DIR" ]; then
	git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules
	# shellcheck source=/dev/null
	source "$DOTFILES_DIR/playbooks/install"
	# git config --global --unset commit.gpgsign
	# git config --global --unset gpg.format
	# git config --global --unset gpg.ssh.allowedsignersfile
	# git config --global --unset gpg.ssh.program
	# git config --global --unset user.email
	# git config --global --unset user.name
	# git config --global --unset user.signingkey
fi
