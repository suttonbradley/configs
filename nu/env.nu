# [preferred] symlink this to $nu.env-path
# ----- OR -----
# Copy the next line into $nu.env-path (or just do `config env`):
#   source ~/code/configs/nu/env.nu

# Pull configs (this file should just source other files so that changes can be pulled here)
git -C ~/code/configs pull | null

$env.config.show_banner = false
source ~/.zoxide.nu # Generate this per-machine with: `zoxide init nushell | save -f ~/.zoxide.nu`

$env.RUSTC_WRAPPER = 'sccache'
$env.EDITOR = 'nvim'
