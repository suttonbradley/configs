# This script consists of anything that should be run on powershell startup.
# Making sure binaries are there, 

# Import PSReadLine
Import-Module PSReadLine

# Ignore commands that start with space
Set-PSReadLineOption -AddToHistoryHandler {
    param($command)
    $ignore_commands_regex = @(" *", "gcam *", "gdb *", "gdrb *", "gdlb *")
    foreach($ignore_command in $ignore_commands_regex) {
        if($command -like $ignore_command) {
            return $false
        }
    }
    return $true
}

# List oh-my-posh install, install it if not already, upgrade it otherwise
winget list --id JanDeDobbeleer.OhMyPosh | Out-Null
if($lastexitcode -lt 0) {
    Write-Host "Installing oh-my-posh. Remove old PS module installs!"
    winget install JanDeDobbeleer.OhMyPosh
}
oh-my-posh init pwsh --config $env:USERPROFILE\code\configs\sutton.omp.json | Invoke-Expression

# Enable posh git to get branch auto-complete
Install-Module posh-git
$env:POSH_GIT_ENABLED = $true

# Add git-delta
if(!(Get-Command delta -ErrorAction Ignore)) {
    Write-Host "git-delta not found. Installing..."
    cargo install git-delta
}
# Add ripgrep
if(!(Get-Command rg -ErrorAction Ignore)) {
    Write-Host "ripgrep not found. Installing..."
    cargo install ripgrep
}
# Add fd
if(!(Get-Command fd -ErrorAction Ignore)) {
    Write-Host "fd not found. Installing..."
    cargo install fd-find
}
# Add sccache and set RUSTC_WRAPPER to use it
if(!(Get-Command sccache -ErrorAction Ignore)) {
    Write-Host "sccache not found. Installing..."
    cargo install sccache
}
$env:RUSTC_WRAPPER="sccache"
# Add cork
if(!(Get-Command cork -ErrorAction Ignore)) {
    Write-Host "cork not found. Installing..."
    cargo install cork
}
# Add tokei
if(!(Get-Command tokei -ErrorAction Ignore)) {
    Write-Host "tokei not found. Installing..."
    cargo install tokei
}
# Add zoxide (https://github.com/ajeetdsouza/zoxide)
if(!(Get-Command zoxide -ErrorAction Ignore)) {
    Write-Host "zoxide not found. Installing..."
    cargo install zoxide --locked
}
# Hook zoxide and replace cd with it
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --cmd cd --hook $hook powershell) -join "`n"
})

# Adjust path
$env:PATH += ";C:\Program Files\CMake\bin\;C:\Program Files\Vim\vim82;"

# Set PSReadLine history options
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
