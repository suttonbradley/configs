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

# ----- Cargo installs -----
# Add git-delta
which delta > /dev/null
if [ $? -ne 0 ]; then
    echo "git-delta not found. Installling..."
    cargo install git-delta
fi

# Add ripgrep
which rg > /dev/null
if [ $? -ne 0 ]; then
    echo "ripgrep not found. Installling..."
    cargo install ripgrep
fi

# Add ripgrep
which fd > /dev/null
if [ $? -ne 0 ]; then
    echo "fd not found. Installling..."
    cargo install fd-find
fi

# Add cork
which cork > /dev/null
if [ $? -ne 0 ]; then
    echo "cork not found. Installling..."
    cargo install cork
fi

# Add tokei
which tokei > /dev/null
if [ $? -ne 0 ]; then
    echo "tokei not found. Installling..."
    cargo install tokei
fi

# Add zoxide
which zoxide > /dev/null
if [ $? -ne 0 ]; then
    echo "zoxide not found. Installling..."
    cargo install zoxide --locked
fi
# ------------------------------

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
