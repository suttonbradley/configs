# ------------------------------------------
# This is a blanket profile that imports/runs other config scripts,
# but only after pulling the latest version.

# Copy the next line into $nu.config-path (or just do `config nu`):
#   source ~\code\configs\nu\shim.nu

echo "Pulling profile updates..."
git -C ($env.USERPROFILE | path join "code/configs") pull | null

# Completions
source ./custom-completions/cargo/cargo-completions.nu
source ./custom-completions/git/git-completions.nu
source ./custom-completions/rustup/rustup-completions.nu
source ./custom-completions/vscode/vscode-completions.nu
source ./custom-completions/winget/winget-completions.nu

# Source other files
source ./config.nu
source ./default-config.nu
source ./aliases.nu

# ------------------------------------------

# TODO: (in order-ish):
# Make it so ctrl+c copies when text is selected (Windows terminal)
# Command for notifying when command complete
# Check for installs like in ../pwsh/prompt.ps1
