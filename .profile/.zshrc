# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.exports ] && source ~/.exports
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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

source $ZSH/oh-my-zsh.sh
unsetopt share_history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
autoload -U compinit; compinit
