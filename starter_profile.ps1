# This is a starter profile that imports ps-profile-common.ps1 from configs.
# The no_update parameter and associated conitional allow for
#   the profile to be reloaded after an update and
#   and update to occur on profile load
#   without an infinite loop.

# --- IMPORT COMMON, UPDATE IF NECESSARY ---
param (
    [switch]$no_update
)

# Import common
. $env:USERPROFILE\code\configs\ps-profile-common.ps1

# Update if necessary
if(!$no_update) {
    upd-pro
}
# ------------------------------------------
