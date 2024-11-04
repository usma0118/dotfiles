#!/bin/bash
set -e
set -u

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  abort "Bash is required to interpret this script."
fi
# Define variables
DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"

GITHUB_USER=${GITHUB_USER:-usma0118}
declare -r DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"
# Ensure required environment variables are set
declare -r env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")
for env_var in "${env_variables[@]}"; do
    if [ -z "${!env_var}" ]; then
        abort "Error: $env_var is not set"
    fi
done

# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/log.sh"

# Check if dotfiles directory exists, clone repo if not
if [ ! -d "$DOTFILES_DIR" ]; then
    log_warning "Cloning $DOTFILES_REPO into $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules --depth=1
fi

# Install dependencies based on OS
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/utils.sh"

log_info "Running on OS: $os_family"
if ! command -v ansible &>/dev/null ; then
    if [[ "$os_family" == 'debian' || "$os_family" == 'ubuntu' ]]; then
        if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            suod apt-add-repository ppa:ansible/ansible -y && apt update -y
        fi
        sudo apt-get install direnv ansible software-properties-common git -y
    elif [[ "$os_family" != 'alpine' ]]; then
        log_warning "Missing ansible, installing now.."
        sudo apk add ansible
    elif [[ "$os_family" == 'darwin' ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/updater.sh"

# check and ensure direnv is hooked to shell
if ! command -v direnv &>/dev/null; then
    eval "$(direnv export "$0")"
fi

# shellcheck source=/dev/null
pushd "$DOTFILES_DIR/playbooks"
log_info "Running playbooks"
# shellcheck disable=SC1091
source "./install"
log_info "Rollout completed"
popd

if [[ "$os_family" == 'alpine' ]]; then
    log_info "Unset gpg.ssh.program"
    git config --global --unset gpg.ssh.program
fi

# check and ensure omz is reloaded
if command -v omz &>/dev/null; then
    log_info "reloading Omz"
    omz reload
fi
