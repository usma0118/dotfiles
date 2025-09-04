#!/bin/bash
set -e
set -u

# shellcheck disable=SC2034
export OS_FAMILY_OVERRIDE="setup_mac_work"

# shellcheck disable=SC1091
source "bootstrap.sh"
