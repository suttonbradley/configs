# TODO: fix, Github issue here: https://github.com/ajeetdsouza/zoxide/issues/681
# source ~/.zoxide.nu # Generate this per-machine with: `zoxide init nushell | save -f ~/.zoxide.nu`

# Functions for platform
def platform_is_windows [] {
    $nu.os-info.name == 'windows'
}
def platform_is_macos [] {
    $nu.os-info.name == 'macos'
}

$env.EDITOR = code

# TODO: sccache breaking on macos
if not (platform_is_macos) {
    $env.RUSTC_WRAPPER = sccache
}

# Add to path
if (platform_is_windows) {
    $env.Path = $env.Path | append ';C:\Program Files\CMake\bin\;C:\Program Files\Vim\vim82' | append ($env.LOCALAPPDATA | path join "VPack")
}
