#!/bin/bash

if [[ $(uname) == 'Linux' ]]; then
  ansible-playbook -i inventory ubuntu.yml
else if [[ $(uname) == 'Darwin' ]]; then
  ansible-playbook -i inventory osx.yml
fi