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

# Enable posh git to get branch auto-complete
$env:POSH_GIT_ENABLED = $true
# Init oh-my-posh
oh-my-posh init pwsh --config $env:USERPROFILE\code\configs\sutton.omp.json | Invoke-Expression

# Set rustc to use sccache
$env:RUSTC_WRAPPER="sccache"

# Set PSReadLine history options
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Hook zoxide and replace cd with it
Invoke-Expression (& { (zoxide init powershell | Out-String) })
