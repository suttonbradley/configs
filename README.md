# configs
These are my configurations for terminals/shells and other dev environment things. They're pretty customized and include a lot of aliasing (git especially), custom commands, and prompt customization. Rip whatever you want at your own risk.

# Setup
## Installs for all shells
- `oh-my-posh`
    - [Install](https://ohmyposh.dev/docs/installation/windows)
- Cargo-installable utils
    ```
    cargo install git-delta
    cargo install ripgrep
    cargo install fd-find
    cargo install sccache
    cargo install cork
    cargo install tokei
    cargo install zoxide --locked
    ```
    - **Set up git** config (including git-delta, vscode, and hooks) by pasting [gitconfig](./gitconfig) into global git config (`git config --global --edit`)

### Powershell-specific
- Get posh-git for git auto-completion: `Install-Module posh-git`

### nushell-specific
- Generate nu script (saved to `~/.oh-my-posh.nu`) by doing `oh-my-posh init nu --config ~/code/configs/sutton.omp.json`
- Generate zoxide script: `zoxide init nushell | save -f ~/.zoxide.nu` (source'ing is taken care of in [config.nu from this repo](./nu/config.nu))

## Using the configs/profiles in this repo
### nushell
`config nu` then replace contents with `source ~/code/configs/nu/shim.nu`

`config env` then replace contents with `source ~/code/configs/nu/env.nu`

### powershell
`code $profile` then paste `. $env:USERPROFILE\code\configs\pwsh\profile.ps1`

### zsh
copy this into your `.zshrc`: `. ~/code/configs/zshrc.zsh`

# Non-shell setup

## VSCode Snippets
To incorporate `vscode-snippets`, you can create a symlink from the location VSCode expects to the `vscode-snippets` dir here by doing the following:
1. Remove the old `snippets` dir, **after making sure there's nothing valuable there**
2. Create the symlink
### Windows
```
Remove-Item -Recurse -Force $env:USERPROFILE\AppData\Roaming\Code\User\snippets
```
From **Admin Powershell**:
```
New-Item -ItemType SymbolicLink -Path (Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\snippets") -Value (Join-Path $env:USERPROFILE "code\configs\vscode-snippets")
```
### Mac/Linux
```
rm -rf `~/Library/Application Support/Code/User/snippets`
```
```
ln -s ~/code/configs/vscode-snippets `~/Library/Application Support/Code/User/snippets`
```

## erdtree config
Create a symbolic link from the location erdtree expects to the the `.erdtree.toml` here:
### Windows
```
if(Test-Path $env:APPDATA\erdtree) {
    Remove-Item -Recurse $env:APPDATA\erdtree
}
New-Item -ItemType Directory $env:APPDATA\erdtree
New-Item -ItemType SymbolicLink -Path $env:APPDATA\erdtree\.erdtree.toml -Value (Join-Path $env:USERPROFILE "code\configs\.erdtree.toml")
```
### Mac/Linux
TODO

## [Windows] Disabling web search on start menu
Write a reg key `BingSearchEnabled` (DWord w/ value 0) under `Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search`:

```
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
```
