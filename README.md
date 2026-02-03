# About
These are my configurations for terminals/shells and other dev environment things. They're pretty customized and include a lot of aliasing (git especially), custom commands, and prompt customization. Rip whatever you want at your own risk.

# Basic Installs
- [VS build tools](https://visualstudio.microsoft.com/downloads/)
- [CaskaydiaCove nerd font](https://www.nerdfonts.com/font-downloads)
- [PowerToys](https://aka.ms/installpowertoys)
- Powershell 7 (`winget install Microsoft.Powershell`)

## oh-my-posh

### Windows
```powershell
winget install JanDeDobbeleer.OhMyPosh
```

In Powershell: `Install-Module posh-git`

### Linux/WSL
```bash
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### Nushell Setup (All Platforms)
1. Generate oh-my-posh script:
   ```bash
   oh-my-posh init nu --config ~/code/configs/sutton.omp.json > ~/.oh-my-posh.nu
   ```
2. Install and generate zoxide script:
   ```bash
   # Install zoxide
   curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
   # Generate config
   zoxide init nushell > ~/.zoxide.nu
   ```
3. Link nushell config (see [Nushell Config Setup](#nushell-config-setup) below)

Note: `source`ing of these files is done in `env.nu`

## Rust and Rust-based utils
- Install Rust toolchain (don't forget to install [VS Build Tools](https://visualstudio.microsoft.com/))
    ```powershell
    Invoke-WebRequest -Uri https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe -OutFile $env:USERPROFILE\rustup-init.exe
    . $env:USERPROFILE\rustup-init.exe
    ```
- Cargo-installable utils
    ```
    cargo install erdtree
    cargo install git-delta
    cargo install ripgrep
    cargo install fd-find
    cargo install sccache
    cargo install cork
    cargo install tokei
    cargo install zoxide --locked
    ```

## Git Config
- **Set up git** config (including git-delta, vscode, and hooks) by pasting [gitconfig](./gitconfig) into global git config (`git config --global --edit`)

## Nushell Config Setup
Link the nushell config files from this repo to the expected nushell config location:

### Linux/WSL
```bash
mkdir -p ~/.config/nushell
ln -sf ~/code/configs/nu/env.nu ~/.config/nushell/env.nu
ln -sf ~/code/configs/nu/config.nu ~/.config/nushell/config.nu
```

### Windows
```powershell
New-Item -ItemType SymbolicLink -Path (Join-Path $env:APPDATA "nushell\env.nu") -Value (Join-Path $env:USERPROFILE "code\configs\nu\env.nu") -Force
New-Item -ItemType SymbolicLink -Path (Join-Path $env:APPDATA "nushell\config.nu") -Value (Join-Path $env:USERPROFILE "code\configs\nu\config.nu") -Force
```

## VSCode Snippets
To incorporate `vscode-snippets`, you can create a symlink from the location VSCode expects to the `vscode-snippets` dir here by doing the following:
1. Remove the old `snippets` dir, **after making sure there's nothing valuable there**
2. Create the symlink
### Windows
From **Admin Powershell**:
```
Remove-Item -Recurse -Force $env:USERPROFILE\AppData\Roaming\Code\User\snippets
New-Item -ItemType SymbolicLink -Path (Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\snippets") -Value (Join-Path $env:USERPROFILE "code\configs\vscode-snippets")
```
### Mac/Linux
```bash
rm -rf `~/Library/Application Support/Code/User/snippets`
ln -s ~/code/configs/vscode-snippets `~/Library/Application Support/Code/User/snippets`
```

## erdtree config
Create a symbolic link from the location erdtree expects to the `.erdtree.toml` here:
### Windows
```powershell
if(Test-Path $env:APPDATA\erdtree) {
    Remove-Item -Recurse $env:APPDATA\erdtree
}
New-Item -ItemType Directory $env:APPDATA\erdtree
New-Item -ItemType SymbolicLink -Path $env:APPDATA\erdtree\.erdtree.toml -Value (Join-Path $env:USERPROFILE "code\configs\.erdtree.toml")
```
### Linux/WSL
```bash
mkdir -p ~/.config/erdtree
ln -sf ~/code/configs/.erdtree.toml ~/.config/erdtree/.erdtree.toml
```


## espanso
[Install espanso](https://espanso.org/install/), then:

### Windows
For home:
```powershell
cp -Force $home/code/configs/espanso/config/default.yml $env:appdata/espanso/config/
"imports:`n  - `"$($home -replace '\\', '\\')\\code\\configs\\espanso\\match\\base.yml`"" | Out-File -Force $env:appdata/espanso/match/base.yml
```
(Note the replace looks like it does nothing here but the first one you're escaping the regex sequence so it's really replacing '\' with '\\')

For work:
```powershell
cp -Force $home/code/configs/espanso/config/default.yml $env:appdata/espanso/config/
"imports:`n  - `"$($home -replace '\\', '\\')\\code\\configs\\espanso\\match\\base.yml`"`n  - `"$($home -replace '\\', '\\')\\<path-from-home-to>\\espanso.yaml`"" | Out-File -Force $env:appdata/espanso/match/base.yml
```

### Mac
To set up espanso via in nushell, do:
```nushell
cp -f $"($env.home)/code/configs/espanso/config/default.yml" $"($env.home)/Library/Application Support/espanso/config"
echo $"imports:\n  - \"($env.home)/code/configs/espanso/match/base.yml\"\n  - \"($env.home)/espanso.yml\"\n" | save -f $"($env.home)/Library/Application Support/espanso/match/base.yml"
```

## [Windows] Disabling web search on start menu
Write a reg key `BingSearchEnabled` (DWord w/ value 0) under `Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search`:

```powershell
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 -Type DWord
```

# nvim
## Get nvim
```powershell
winget install Neovim.Neovim
```

## symlink nvim config to this repo
(Windows)
```powershell
New-Item -ItemType SymbolicLink -Path (Join-Path $env:LOCALAPPDATA "nvim") -Value (Join-Path $env:USERPROFILE "code\configs\nvim")
```
(MacOS/Linux)
```bash
rm -rf ~/.config/nvim
ln -s ~/code/configs/nvim ~/.config/nvim
```

## Manual VIM setup:
- rustaceanvim plugin:
    - Install codelldb (not auto-installable by `Mason`): `:MasonInstall codelldb`
    - Add rust-analyzer (`Mason` doesn't install at expected path): `rustup component add rust-analyzer`

## Get LLVM
From [Github releases](https://github.com/llvm/llvm-project/releases) (winget doesn't add to path)
