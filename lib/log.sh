#!/bin/bash
set -e
set -u
# log.sh - Shared logging library

# Source the file only if it hasn't been sourced already
if [ "${logger_loaded+x}" ]; then
return 0
fi

declare -r logger_loaded=true

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
