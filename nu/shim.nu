# ------------------------------------------
# This is a blanket profile that imports/runs other config scripts,
# but only after pulling the latest version.

# Copy the next line into $nu.config-path (or just do `config nu`):
#   source ~\code\configs\nu\shim.nu

# Pull configs (this file should just source other files so that changes can be pulled here)
git -C ~/code/configs pull | null

# Completions
source ./custom-completions/cargo/cargo-completions.nu
source ./custom-completions/git/git-completions.nu
source ./custom-completions/rustup/rustup-completions.nu
source ./custom-completions/vscode/vscode-completions.nu
# source ./custom-completions/winget/winget-completions.nu

# Source other files
source ./config.nu
source ./default-config.nu
source ./aliases.nu
source ./sourcebat.nu

# ------------------------------------------
