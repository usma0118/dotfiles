#!/bin/bash
set -e
set -u
set -o pipefail
# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  echo "Bash is required to interpret this script."
  exit 1
fi
# Use default value if DOTFILES_DIR is not set
declare -r DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/log.sh"
# Install dependencies based on OS
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/utils.sh"
# shellcheck disable=SC2154
log_info "Running on OS: $os_family"
declare -r GITHUB_USER=${GITHUB_USER:-usma0118}
export DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"
declare -r CODESPACES=${CODESPACES:-}
declare -r container=${container:-}

# Ensure required environment variables are set
declare -r env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")
export REMOTE_USER="${ANSIBLE_REMOTE_USER:-${SUDO_USER:-${USER}}}"
for env_var in "${env_variables[@]}"; do
    if [ -z "${!env_var}" ]; then
        abort "Error: $env_var is not set"
    fi
done


# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/updater.sh"

if ! command -v ansible &>/dev/null ; then
    if [ -n "$CODESPACES" ] || [ -n "$container" ]; then
        abort "Make sure code space includes ansible"
    elif [[ "$os_family" == 'debian' || "$os_family" == 'ubuntu' ]]; then
        if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            apt-add-repository ppa:ansible/ansible -y && apt update -y
        fi
        apt-get install direnv ansible-core software-properties-common git -y
    elif [[ "$os_family" == 'alpine' ]]; then
        log_warning "Missing ansible, installing now.."
        apk add ansible-core
    elif [[ "$os_family" == 'Darwin' ]]; then
        if ! command -v brew &>/dev/null ; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            log_info "Home brew is already installed"
        fi
        brew install ansible-core git
    fi
fi

# check and ensure direnv is hooked to shell
if ! command -v direnv &>/dev/null ; then
    eval "$(direnv export "$0")"
else
 ANSIBLE_CONFIG=$(realpath ansible.cfg)
 export ANSIBLE_CONFIG
fi

#TODO: Install ansible requirements

# shellcheck source=/dev/null
pushd "$DOTFILES_DIR/playbooks"

# shellcheck disable=SC1091
source "./install"
log_info "Rollout completed"
popd

if [[ "$os_family" == 'alpine' ]]; then
    log_info "Unset gpg.ssh.program"
    git config --global --unset gpg.ssh.program
fi
