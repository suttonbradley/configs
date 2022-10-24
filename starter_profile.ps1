# ------------------------------------------
# This is a starter profile that imports ps-profile-common.ps1 from configs,
# but only after pulling the latest version.

# Pull any updates
Write-Host "Pulling profile updates..."
pushd $env:USERPROFILE\code\configs
git pull | Out-Null
popd

# Import common
Write-Host "Applying profile updates..."
. $env:USERPROFILE\code\configs\ps-profile-common.ps1
# ------------------------------------------
