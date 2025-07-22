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

# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/log.sh"
# Install dependencies based on OS
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/utils.sh"
# shellcheck disable=SC2154
log_info "Running on OS: $os_family"
# Use default value if DOTFILES_DIR is not set
declare -r DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"

declare -r CODESPACES=${CODESPACES:-}
declare -r container=${container:-}

GITHUB_USER=${GITHUB_USER:-usma0118}
declare -r DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"
# Ensure required environment variables are set
declare -r env_variables=("GITHUB_USER" "DOTFILES_REPO" "DOTFILES_DIR")

for env_var in "${env_variables[@]}"; do
    if [ -z "${!env_var}" ]; then
        abort "Error: $env_var is not set"
    fi
done


# Ensure dotfiles directory exists and is up to date
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Cloning $DOTFILES_REPO into $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" --recurse-submodules --depth=1
else
    echo "Checking if remote $DOTFILES_REPO is newer than local $DOTFILES_DIR"
    LOCAL_HASH=$(git -C "$DOTFILES_DIR" rev-parse @)
    REMOTE_HASH=$(git ls-remote "$DOTFILES_REPO" HEAD | awk '{print $1}')
    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "Remote repo is newer. Updating $DOTFILES_DIR from $DOTFILES_REPO"
        git -C "$DOTFILES_DIR" pull --rebase --autostash
        git -C "$DOTFILES_DIR" submodule update --init --recursive
    else
        echo "Local repo is up to date."
    fi
fi

if ! command -v ansible &>/dev/null ; then
    if [ -n "$CODESPACES" ] || [ -n "$container" ]; then
        abort "Make sure code space includes ansible"
    elif [[ "$os_family" == 'debian' || "$os_family" == 'ubuntu' ]]; then
        if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            apt-add-repository ppa:ansible/ansible -y && apt update -y
        fi
        apt-get install direnv ansible software-properties-common git -y
    elif [[ "$os_family" != 'alpine' ]]; then
        log_warning "Missing ansible, installing now.."
        apk add ansible
    elif [[ "$os_family" == 'Darwin' ]]; then
        if ! command -v brew &>/dev/null ; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            log_info "Home brew is already installed"
        fi
        brew install ansible
    fi
fi

# shellcheck disable=SC1091
#source "$DOTFILES_DIR/lib/updater.sh"

# check and ensure direnv is hooked to shell
if ! command -v direnv &>/dev/null ; then
    eval "$(direnv export "$0")"
else
 ANSIBLE_CONFIG=$(realpath ansible.cfg)
 export ANSIBLE_CONFIG
fi

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
