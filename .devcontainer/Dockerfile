FROM mcr.microsoft.com/devcontainers/base:alpine-3.19

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode

RUN apk add --no-cache \
    zsh \
    ca-certificates curl wget gettext sshpass \
    jq git openssh-client \
    go-task \
    python3 py3-pip \
    git direnv \
    ansible &&\
    apk add --no-cache \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
        age helm kubectl sops &&\
    apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        lsd
#pre-commit
USER $USERNAME

# Add direnv whitelist for the workspace directory
RUN mkdir -p /home/$USERNAME/.config/direnv &&\
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.config &&\
tee /home/$USERNAME/.config/direnv/direnv.toml > /dev/null <<EOF
[whitelist]
prefix = [ "/workspaces" ]
EOF
