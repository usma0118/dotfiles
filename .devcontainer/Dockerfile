FROM mcr.microsoft.com/devcontainers/base:alpine-3.19

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED 1
ARG USERNAME=vscode

RUN apk add --no-cache \
    zsh \
    ca-certificates curl wget gettext sshpass \
    fzf jq git openssh-client \
    go-task \
    python3 py3-pip py3-virtualenv\
    git direnv shellcheck\
    ansible ansible-lint &&\
    apk add --no-cache \
        --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
        age helm kubectl sops &&\
    apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing \
        lsd
USER $USERNAME

# Add direnv whitelist for the workspace directory
RUN mkdir -p /home/$USERNAME/.config/direnv &&\
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.config &&\
tee /home/$USERNAME/.config/direnv/direnv.toml > /dev/null <<EOF
[whitelist]
prefix = [ "/workspaces" ]
EOF
WORKDIR /workspaces
RUN virtualenv /home/$USERNAME/.venv
ENV VIRTUAL_ENV /home/$USERNAME/.venv
ENV PATH $VIRTUAL_ENV:$PATH
RUN . $VIRTUAL_ENV/bin/activate && pip install --upgrade pip && pip install pre-commit
