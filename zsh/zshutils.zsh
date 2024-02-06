# ----- GIT ALIASES -----
# TODO make this common with powershell git aliases
function gs { git status $@ }
function gd { git diff $@ }
function gdn { git diff --name-only $@ }
function gg { git log }
function ga { git add $@ }
function gau { git add -u $@ }
function gap { git add -p $@ }
function gco { git checkout $@ }
function gcp { git checkout -p $@ }
function gcn { git checkout -b $@ }
function gpu { git push }
function gpuu { git push -u origin (git branch --show-current) }
function gpuf { git push -f }
function gpl { git pull }
function glo { git log $@ }
function gb { git branch }
function gcom { git commit -m $1 }
function gcam { git commit -am $1 }

# TODO convert these to zsh
# function gmb {
#     param (
#         [string]$rev_one="main",
#         [string]$rev_two=(git branch --show-current)
#     )
#     Write-Host "Common ancestor between $rev_one and ${rev_two}:"
#     return (git merge-base $rev_one $rev_two)
# }

# # Aliases for deleting local and remote branches
# function gdrb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     Write-Host "Deleting remote branch $branchName..."
#     git push --delete origin $branchName
# }

# function gdlb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     Write-Host "Deleting local branch  $branchName..."
#     git branch -D $branchName
# }

# function gdb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     gdrb $branchName
#     gdlb $branchName
# }

# # Aliases for renaming local and remote branches
# function grrb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     Write-Host "Renaming remote branch..."
#     $oldBranch = git branch --show-current
#     git push origin origin/$($oldBranch):refs/heads/$branchName :$oldBranch
# }

# function grlb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     Write-Host "Renaming local branch..."
#     git branch -m $branchName
#     git branch -u origin/$branchName
# }

# function grb {
#     param (
#         [Parameter(Mandatory)] [string]$branchName
#     )
#     grrb $branchName
#     grlb  $branchName
# }
