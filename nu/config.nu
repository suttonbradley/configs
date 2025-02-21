# [preferred] symlink this to $nu.config-path
# ----- OR -----
# Copy the next line into $nu.config-path (or just do `config nu`):
#   source ~/code/configs/nu/config.nu

# Completions
source ~/code/configs/nu/custom-completions/cargo/cargo-completions.nu
source ~/code/configs/nu/custom-completions/git/git-completions.nu
source ~/code/configs/nu/custom-completions/rustup/rustup-completions.nu
source ~/code/configs/nu/custom-completions/vscode/vscode-completions.nu
source ~/code/configs/nu/custom-completions/winget/winget-completions.nu

# Source other files
source ~/code/configs/nu/aliases.nu
source ~/code/configs/nu/ripgrep-open.nu
source ~/code/configs/nu/sourcebat.nu

# Functions for platform
def platform_is_windows [] {
    $nu.os-info.name == 'windows'
}
def platform_is_macos [] {
    $nu.os-info.name == 'macos'
}

# Avoid sccache on MacOS -- TODO: broken
if not (platform_is_macos) {
    $env.RUSTC_WRAPPER = 'sccache'
}

# PATH additions
if (platform_is_windows) {
    $env.Path = $env.Path | append ';C:\Program Files\CMake\bin\;C:\Program Files\Vim\vim82' | append ($env.LOCALAPPDATA | path join "VPack")
}

# Editor
$env.EDITOR = 'code'
