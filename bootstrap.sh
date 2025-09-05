#!/usr/bin/env bash
set -euo pipefail

# --- tiny prelude (needed BEFORE sourcing libs) ---
_abort(){ echo "ERROR: $*" >&2; exit 1; }
_have(){ command -v "$1" >/dev/null 2>&1; }

# Defaults / env
DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"
GITHUB_USER="${GITHUB_USER:-usma0118}"
DOTFILES_REPO="https://github.com/${GITHUB_USER}/dotfiles.git"
CODESPACES="${CODESPACES:-}"
CONTAINER_ENV="${container:-}"        # some envs export 'container'
export REMOTE_USER="${ANSIBLE_REMOTE_USER:-${SUDO_USER:-${USER}}}"

# Ensure required files exist before sourcing
[ -r "$DOTFILES_DIR/lib/log.sh" ]   || _abort "Missing $DOTFILES_DIR/lib/log.sh"
[ -r "$DOTFILES_DIR/lib/utils.sh" ] || _abort "Missing $DOTFILES_DIR/lib/utils.sh"

# --- libraries (define abort/have properly; will shadow the tiny ones) ---
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/log.sh"
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/utils.sh"

# sudo helper
SUDO=""
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  if have sudo; then SUDO="sudo"; else abort "This script needs root or sudo"; fi
fi

# utils.sh exports lowercase os_family
log_info "Running on OS: ${os_family:-unknown}"

# Install Ansible if missing
if ! have ansible || ! have ansible-playbook ; then
  case "$os_family" in
    ubuntu)
      $SUDO apt-get update -y
      $SUDO apt-get install -y software-properties-common git direnv
      if ! grep -Rqs "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
        $SUDO add-apt-repository -y ppa:ansible/ansible
        $SUDO apt-get update -y
      fi
      $SUDO apt-get install -y ansible-core
      ;;
    debian)
      $SUDO apt-get update -y
      $SUDO apt-get install -y ansible-core git direnv
      ;;
    alpine)
      log_warning "Installing Ansible on Alpine…"
      if apk info -e ansible-core >/dev/null 2>&1; then
        $SUDO apk add --no-cache ansible-core git direnv
      else
        $SUDO apk add --no-cache python3 py3-pip git direnv
        python3 -m pip install --upgrade --no-cache-dir pip
        python3 -m pip install --no-cache-dir ansible-core
      fi
      ;;
    darwin)
      if ! have brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      else
        log_info "Homebrew already installed"
      fi
      brew install ansible git direnv
      ;;
    *)
      abort "Unsupported OS family: ${os_family}"
      ;;
  esac
fi

# Point Ansible at project config if present
if [ -f "$DOTFILES_DIR/playbooks/ansible.cfg" ]; then
  export ANSIBLE_CONFIG="$DOTFILES_DIR/playbooks/ansible.cfg"
fi

# Load direnv for this shell only if present
if have direnv && [ -f "$DOTFILES_DIR/playbooks/.envrc" ]; then
  # shellcheck disable=SC1090
  eval "$(direnv export bash)"
fi

# Run the playbook installer
pushd "$DOTFILES_DIR/playbooks" >/dev/null || abort "cd failed: $DOTFILES_DIR/playbooks"
trap 'popd >/dev/null || true' EXIT

if [ -x ./install ]; then
  ./install
else
  # shellcheck disable=SC1091
  source ./install
fi

log_info "Rollout completed"
