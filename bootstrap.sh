#!/bin/bash
set -e
set -u
# Define color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
# Function to log info messages
log_info() {
    echo -e "${GREEN}$1${NC}"
}

# Function to log error messages
abort() {
    echo -e "${RED}$1${NC}"
    exit 1
}

# Function to log warning messages
log_warning() {
    echo -e "${YELLOW}$1${NC}"
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
        abort "Error: $env_var is not set"
    fi
done

# Install dependencies based on OS
# shellcheck disable=SC1091
os_family=$(source /etc/os-release && echo "$ID")

if ! command -v ansible &>/dev/null ; then
    if [[ "$os_family" == 'debian' || "$os_family" == 'ubuntu' ]]; then
        if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            sudo apt-add-repository ppa:ansible/ansible -y
        fi
        sudo apt-get install direnv ansible software-properties-common git -y
    elif [[ "$os_family" != 'alpine' ]]; then
        log_warning "Missing ansible, installing now.."
        sudo apk add ansible
    elif [[ $(uname) == 'darwin' ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # xcode-select --install
        # brew install direnv git
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
log_info "running with commit id: $(git rev-parse HEAD)"
# shellcheck disable=SC1091
source "./install"
log_warning "Rollout completed"
popd

if [[ "$os_family" == 'alpine' ]]; then
    log_warning "Unset gpg.ssh.program"
    git config --global --unset gpg.ssh.program
fi
log_info "Rolling out playbooks"

# check and ensure omz is reloaded
if command -v omz &>/dev/null; then
    log_info "reloading Omz"
    omz reload
fi
