#!/bin/bash
if [[ $(uname) == 'Linux' ]]; then
    apt-add-repository ppa:ansible/ansible
    apt-get update
    apt-get install ansible software-properties-common git
elif [[ $(uname) == 'Darwin' ]]; then
    xcode-select --install
    brew install ansible
    git clone https://github.com/$(github.username)/dotfiles.git ~/dotfiles
fi
