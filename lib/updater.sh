#!/bin/bash
set -e
set -u

declare -r DOTFILES_DIR="$HOME/.dotfiles"

# Source the logging library
# shellcheck disable=SC1091
source "$DOTFILES_DIR/lib/log.sh"

# Fetch the latest changes from the remote repository
git --git-dir="$DOTFILES_DIR/.git" --work-tree="$DOTFILES_DIR" fetch origin main -q
# Check if the local main branch is behind the remote main branch
LOCAL=$(git --git-dir="$DOTFILES_DIR/.git" --work-tree="$DOTFILES_DIR" rev-parse main)
REMOTE=$(git --git-dir="$DOTFILES_DIR/.git" --work-tree="$DOTFILES_DIR" rev-parse origin/main)
if [ "$LOCAL" != "$REMOTE" ]; then
    log_info "There are new updates available for the repository."

    # Prompt the user to update
    read -t 30 -p "Do you want to update? (Y/n) " -n 1 -r
    echo    # move to a new line
    RESPONSE=${REPLY:-Y}

    if [[ $RESPONSE =~ ^[Yy]$ ]]; then
        log_info "Updating the repository..."
        git --git-dir="$DOTFILES_DIR/.git" --work-tree="$DOTFILES_DIR" pull origin main -q
    fi
    # shellcheck disable=SC1091
    source "$DOTFILES_DIR/bootstrap.sh"
fi
