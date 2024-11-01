#!/usr/bin/env bash

# Default kubeconfig file
DEFAULT_KUBECONFIG_FILE="$HOME/.kube/config"
if test -f "${DEFAULT_KUBECONFIG_FILE}"; then
  export KUBECONFIG="${DEFAULT_KUBECONFIG_FILE}"
else
  export KUBECONFIG=""
fi

# Directory for additional kubeconfig files
ADD_KUBECONFIG_FILES="$HOME/.kube/config.d"
mkdir -p "${ADD_KUBECONFIG_FILES}"

# Find and append additional kubeconfig files
find "${ADD_KUBECONFIG_FILES}" -type f \( -name "*.yml" -o -name "*.yaml" \) -exec sh -c '
  for kubeconfigFile; do
    if [ -n "$KUBECONFIG" ]; then
      KUBECONFIG="$kubeconfigFile:$KUBECONFIG"
    else
      KUBECONFIG="$kubeconfigFile"
    fi
  done
  export KUBECONFIG
' sh {} +

# Export final KUBECONFIG for the current session
export KUBECONFIG
