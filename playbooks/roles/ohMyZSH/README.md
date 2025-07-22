# ohMyZSH Role

Installs and configures Oh My Zsh, Powerlevel10k, and useful plugins for supported platforms.

## Role Variables

- `user`: User to configure (default: current user)
- `ohmyzsh_theme`: Zsh theme (default: powerlevel10k)
- `ohmyzsh_plugins`: List of plugins

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: ohMyZSH
```
