#!/bin/bash
if [[ $(uname) == 'Linux' ]]; then
    apt-add-repository ppa:ansible/ansible
    apt-get update -y
    apt-get install ansible software-properties-common git -y
elif [[ $(uname) == 'Darwin' ]]; then
    xcode-select --install
    brew install ansible
    git clone https://github.com/$(github.username)/dotfiles.git ~/dotfiles
fi
