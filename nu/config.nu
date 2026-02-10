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
if (platform_is_windows) {
    $env.PATH = $env.PATH | append ($env.LOCALAPPDATA | path join "VPack")
}
# PATH additions
# For some reason, nushell doesn't like the standard bash path 
if (platform_is_macos) {
    $env.PATH = $env.PATH | append '~/.cargo/bin'
}

# Editor
$env.EDITOR = 'code'

# THEME
source ~/code/configs/nu/catpuccin-mocha.nu
source $"($nu.home-dir)/.cargo/env.nu"
