# ------------------------------------------
# This is a blanket profile that imports/runs other config scripts,
# but only after pulling the latest version.

# COPY THIS INTO YOUR .zshrc:  . ~/code/configs/zshrc.zsh

# Pull any updates
echo "Pulling profile updates..."
git -C ~/code/configs pull > /dev/null

# Import env
echo "Importing env..."
. ~/code/configs/zsh/zshenv.zsh

# Set up prompt
echo "Configuring prompt..."
. ~/code/configs/zsh/zshprompt.zsh

# Import utils
echo "Importing utils..."
. ~/code/configs/zsh/zshutils.zsh
# ------------------------------------------
