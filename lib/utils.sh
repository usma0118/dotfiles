#!/bin/bash
set -e
set -u
# utils.sh - Shared library

# Source the file only if it hasn't been sourced already
if [ "${utils_loaded+x}" ]; then
return 0
fi

declare -r utils_loaded=true

# Check OS using /etc/os-release
if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release  # Source the file to access variables
    export os_family="$ID"
else
    # Fallback to uname if /etc/os-release is not available
    # shellcheck disable=SC2155
    export os_family="$(uname -s)"
fi
