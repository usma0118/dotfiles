# shellcheck disable=SC2148
# lib/log.sh
# Shared logging library. Source me; do not execute.

# Prevent double-loading (works whether sourced or executed)
if [ "${LOGGER_LOADED:-0}" = "1" ]; then
  # shellcheck disable=SC2317
  return 0 2>/dev/null || exit 0
fi
LOGGER_LOADED=1

# Do NOT set -e/-u in libraries.

# Color support (disabled if NO_COLOR is set or stderr is not a TTY)
if [ -t 2 ] && [ -z "${NO_COLOR:-}" ]; then
  RED="$(printf '\033[0;31m')"
  YELLOW="$(printf '\033[0;33m')"
  GREEN="$(printf '\033[0;32m')"
  NC="$(printf '\033[0m')"
else
  RED=""; YELLOW=""; GREEN=""; NC=""
fi

log_info()    { printf '%b%s%b\n'   "$GREEN"  "$*" "$NC" >&2; }
log_warning() { printf '%b%s%b\n'   "$YELLOW" "$*" "$NC" >&2; }
abort()       { printf '%bERROR:%b %s\n' "$RED" "$NC" "$*" >&2; exit 1; }
log_debug()   { [ "${DEBUG:-0}" = "1" ] && printf 'DEBUG: %s\n' "$*" >&2; }
