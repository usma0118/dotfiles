#!/usr/bin/env bash
podman image prune -f
podman system prune --volumes -af
