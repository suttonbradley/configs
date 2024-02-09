# TODO: fix, Github issue here: https://github.com/ajeetdsouza/zoxide/issues/681
# source ~/.zoxide.nu # Generate this per-machine with: `zoxide init nushell | save -f ~/.zoxide.nu`

$env.EDITOR = code
$env.RUSTC_WRAPPER = sccache

# Add to path
$env.Path = $env.Path | append ';C:\Program Files\CMake\bin\;C:\Program Files\Vim\vim82' | append ($env.LOCALAPPDATA | path join "VPack")
