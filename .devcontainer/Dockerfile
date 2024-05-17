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

# RUN echo "Updating /etc/bash.bashrc and /etc/zsh/zshrc..." &&\
#     if [[ -f /etc/bash.bashrc ]]; then echo -e 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc fi  &&\
#     if [ -f "/etc/zsh/zshrc" ]; then echo -e 'eval "$(direnv hook zsh)"' >> /etc/zsh/zshrc fi
WORKDIR /workspaces
RUN eval "$(direnv export bash)"
RUN virtualenv /home/$USERNAME/.venv
ENV VIRTUAL_ENV /home/$USERNAME/.venv
ENV PATH $VIRTUAL_ENV:$PATH
RUN . $VIRTUAL_ENV/bin/activate && pip install --upgrade pip && pip install pre-commit
