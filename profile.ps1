# ------------------------------------------
# This is a blanket profile that imports/runs other config scripts,
# but only after pulling the latest version.

# COPY THIS INTO YOUR PROFILE:  . $env:USERPROFILE\code\configs\profile.ps1

# Pull any updates
Write-Host "Pulling profile updates..."
pushd $env:USERPROFILE\code\configs
git pull | Out-Null
popd

# Set up prompt
Write-Host "Configuring prompt..."
. $env:USERPROFILE\code\configs\prompt.ps1

# Import utils
Write-Host "Importing utils..."
. $env:USERPROFILE\code\configs\utils.ps1
# ------------------------------------------
