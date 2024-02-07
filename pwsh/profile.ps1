# ------------------------------------------
# This is a blanket profile that imports/runs other config scripts,
# but only after pulling the latest version.

# COPY THIS INTO YOUR PROFILE:  . $env:USERPROFILE\code\configs\pwsh\profile.ps1

# Pull any updates
Write-Host "Pulling profile updates..."
git -C $env:USERPROFILE\code\configs pull | Out-Null

# Set up prompt
Write-Host "Configuring prompt..."
. $env:USERPROFILE\code\configs\pwsh\prompt.ps1

# Import utils
Write-Host "Importing utils..."
. $env:USERPROFILE\code\configs\pwsh\utils.ps1
# ------------------------------------------
