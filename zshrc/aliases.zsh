# Make core utils better
alias grep='grep --color=auto'
alias ls='ls --color=auto -h'
export TIME_STYLE=long-iso # makes YYYY-MM-DD in the ls output
export BLOCK_SIZE="'1" # makes 1,000,000 for big sizes

# Common commands
alias reload='source ~/.zshrc'
alias hgrep='history -fd 0 | grep'

# Important files
alias zshrc="nano ~/.zshrc"

# Shorthands
alias e="exit"
alias h='history -fd -500'

# Analyze history data
analyze_history(){
    cut -f2 -d";" ~/.zsh_history | sort | uniq -c | sort -nr | head -n 30
}
analyze_commands(){
    cut -f2 -d";" ~/.zsh_history | cut -d' ' -f1 | sort | uniq -c | sort -nr | head -n 30
}

# kubernetes configuration
alias k="kubectl"
