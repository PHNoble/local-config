# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/bin:$PATH"
ZSH_THEME="robbyrussell" # prompt is replaced by starship below
ENABLE_CORRECTION="true"
plugins=(git wt zsh-autosuggestions zsh-syntax-highlighting) # syntax-highlighting must be last
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# after nvm so ~/.config/scripts and ~/.local/bin win over node bins
export PATH="$HOME/.config/scripts:$HOME/.local/bin:$PATH:$HOME/.cargo/bin"
alias python="python3"
eval "$(pyenv init -)"

# machine-specific / work config (not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
