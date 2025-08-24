# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

plugins=(git
	 direnv
 	 zsh-syntax-highlighting
	 zsh-autosuggestions
  	#  zsh-ssh
     kubectl
	 z
	 fzf
	 git
	 brew
	 docker
)

# unsetopt share_history 

autoload -U compinit; compinit

[[ ! -f ~/scripts/initk8-configs.sh ]] || source ~/scripts/initk8-configs.sh

command -v flux >/dev/null && . <(flux completion zsh)

[[ ! -d $HOME/.dotfiles/lib/dotfiles_updater.sh ]] || source $HOME/.dotfiles/lib/updater.sh
