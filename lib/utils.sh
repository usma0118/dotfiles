# shellcheck disable=SC2148
# lib/utils.sh
# Shared helpers. Source me; do not execute.

# Prevent double-loading
if [ "${UTILS_LOADED:-0}" = "1" ]; then
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
UTILS_LOADED=1

# Do NOT set -e/-u in libraries.

# Helper: is cmd available?
have() { command -v "$1" >/dev/null 2>&1; }

# Detect OS family and export a lowercase identifier
_detect_os_family() {
  local id
  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    id="${ID:-}"
  else
    id="$(uname -s 2>/dev/null || echo unknown)"
  fi
  printf '%s' "$id" | tr '[:upper:]' '[:lower:]'
}

declare -r os_family="$(_detect_os_family)"
export os_family
# Note: use 'os_family' (lowercase) in scripts for consistency
