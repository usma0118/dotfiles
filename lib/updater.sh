#!/bin/bash
set -e
set -u
declare -r DOTFILES_DIR="$HOME/.dotfiles"
# Change to the repository directory
pushd "$DOTFILES_DIR" || { echo "Repository not found at $DOTFILES_DIR"; exit 1; }

# Fetch the latest changes from the remote repository
git fetch origin main -q
# Check if the local main branch is behind the remote main branch
LOCAL=$(git rev-parse main)
REMOTE=$(git rev-parse origin/main)
if [ "$LOCAL" != "$REMOTE" ]; then
    echo "There are new updates available for the repository."

    # Prompt the user to update
    read -p "Do you want to update? (Y/n) " -n 1 -r
    echo    # move to a new line
    RESPONSE=${REPLY:-Y}

    if [[ $RESPONSE =~ ^[Yy]$ ]]; then
        echo "Updating the repository..."
        git pull origin main &> /dev/null
        echo "Repository updated."
    fi
fi
popd || exit
