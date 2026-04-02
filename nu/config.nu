# [preferred] symlink this to $nu.config-path
# ----- OR -----
# Copy the next line into $nu.config-path (or just do `config nu`):
#   source ~/code/configs/nu/config.nu

# Enable dir switching via 'shells' aliases (shells, g, n, p, e/enter, dexit)
use std/dirs shells-aliases *

# Completions
source ~/code/configs/nu/nu_scripts/custom-completions/cargo/cargo-completions.nu
source ~/code/configs/nu/nu_scripts/custom-completions/git/git-completions.nu
source ~/code/configs/nu/nu_scripts/custom-completions/rustup/rustup-completions.nu
source ~/code/configs/nu/nu_scripts/custom-completions/vscode/vscode-completions.nu
source ~/code/configs/nu/nu_scripts/custom-completions/winget/winget-completions.nu

# Source other files
source ~/code/configs/nu/aliases.nu
source ~/code/configs/nu/ripgrep-open.nu
source ~/code/configs/nu/sourcebat.nu

# PATH additions
# For some reason, nushell doesn't like the standard bash path
# Apply to both Linux (including WSL) and macOS
if not (platform_is_windows) {
    $env.PATH = $env.PATH | append '~/.cargo/bin'
    $env.PATH = $env.PATH | append '~/.local/bin'
    $env.PATH = $env.PATH | append '/opt/nvim-linux-x86_64/bin'
}

# THEME
source ~/code/configs/nu/catpuccin-mocha.nu

# Machine-specific add-on — not tracked in configs repo, lives only on this machine
# Create an empty ~/config.nu on machines that don't need it
source ~/config.nu

# ----- PROMPT -----
# oh-my-posh: https://ohmyposh.dev/docs/installation/prompt?shell=nu
oh-my-posh init nu -c ~/code/configs/sutton.omp.json

