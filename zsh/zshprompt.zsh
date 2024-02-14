# point at history file
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# never beep
setopt NO_BEEP

# Better tab completion
autoload -Uz compinit && compinit

# oh-my-posh setup
eval "$(oh-my-posh init zsh --config ~/code/configs/sutton.omp.json)"

# Install fzf for zoxide
which fzf > /dev/null
if [ $? -ne 0 ]; then
    echo "fzf not found. Installling..."
    brew install fzf
    sudo $(brew --prefix)/opt/fzf/install
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Init zoxide
eval "$(zoxide init zsh)"
