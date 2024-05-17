#!/bin/bash
set -ex

set -u

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi
# Define variables
declare -r DOTFILES_DIR="$HOME/.dotfiles"

GITHUB_USER=${GITHUB_USER:-usma0118}
declare -r DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"

# Ensure required environment variables are set
declare -r env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")
for env_var in "${env_variables[@]}"; do
    if [ -z "${!env_var}" ]; then
        echo "Error: $env_var is not set"
        exit 1
    fi
done

# Install dependencies based on OS
# shellcheck disable=SC1091
os_family=$(source /etc/os-release && echo "$ID")

if ! command -v ansible &>/dev/null && [[ "$os_family" != 'alpine' ]]; then
    if [[ "$os_family" == 'debian' || "$os_family" == 'ubuntu' ]]; then
        if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            sudo apt-add-repository ppa:ansible/ansible -y
        fi
        sudo apt-get install direnv ansible software-properties-common git -y
    elif [[ $(uname) == 'darwin' ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        xcode-select --install
        brew install direnv git
    fi
fi

# check and ensure direnv is hooked to shell
if ! command -v direnv &>/dev/null; then
    eval "$(direnv export "$0")"
fi

# Check if dotfiles directory exists, clone repo if not
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning $DOTFILES_REPO into $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules --depth=1
fi

# shellcheck source=/dev/null
pushd "$DOTFILES_DIR/playbooks"
# shellcheck disable=SC1091
source "./install"
# Reset git config if needed
# git config --global --unset commit.gpgsign
# git config --global --unset gpg.format
# git config --global --unset gpg.ssh.allowedsignersfile
if [[ "$os_family" != 'alpine' ]]; then
    git config --global --unset gpg.ssh.program
fi
# git config --global --unset user.email
# git config --global --unset user.name
# git config --global --unset user.signingkey
popd

if [ "$(basename "$0")" != "zsh" ]; then
    # Change default shell to zsh
    chsh -s "$(which zsh)"
    echo "Changed default shell to zsh."
else
    omz reload
    echo "Already using zsh as default shell."
fi
