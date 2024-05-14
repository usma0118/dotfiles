# Dotfiles by usma0118

Hacking like a geek:

* the `playbooks` folder contains Ansible that provisions a machine with apps and configs
* I use the zsh shell
* my main machine is a Mac, I have a work dev Debian machine, and my server is running Ubuntu

## Setup for a new Mac machine

1. Install needed packages via bootstrap.sh
2. As a convention `~/dotfiles` should be this repo

  ```bash
  git clone https://github.com/usma0118/dotfiles.git ~/dotfiles
  ```

3. Run the Ansible playbook for Mac

  ```bash
  ./launch
  ```

## Setup for a new Linux machine

We need a version of Ansible greater than 2.0.

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible software-properties-common git
git clone https://github.com/palcu/dotfiles.git ~/dotfiles
cd ~/dotfiles/playbooks
./launch
```

## Sources of inspiration

Thank you for all the people who've published their useful configs.

* http://dotfiles.github.io
* https://github.com/holman/dotfiles
* https://github.com/mgax/dotfiles
* https://github.com/razvand/snippets
* https://github.com/pivotal/vim-config
* https://github.com/pivotal/dotfiles
