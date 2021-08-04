# ----- PROMPT SETUP -----
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme $env:USERPROFILE\code\configs\sutton.omp.json

function Show-PoshThemes {
    Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Programs\oh-my-posh\themes\*" -Include '*.omp.json' | Sort-Object Name | ForEach-Object -Process {
        $esc = [char]27
        Write-Host ""
        Write-Host "$esc[1m$($_.BaseName)$esc[0m"
        Write-Host ""
        oh-my-posh --config $($_.FullName) --pwd $PWD
        Write-Host ""
    }
}

function Open-PoshThemes {
    code $env:USERPROFILE\AppData\Local\Programs\oh-my-posh\themes
}

function Open-MyPoshTheme {
    code $env:USERPROFILE\code\configs\sutton.omp.json
}

function Open-MyPs {
    code $env:USERPROFILE\code\configs\ps-profile-common.ps1
}

# Update prompt
function upd-pro {
    # Pull new code
    pushd $env:USERPROFILE\code\configs
    git pull | Out-Null
    popd

    # Reload profile, don't call update again
    . $profile -no_update
}

# ----- GIT ALIASES -----
function gs { git status $args }
function gd { git diff $args }
function gdn { git diff --name-only $args }
function gg { git log }
function ga { git add $args }
function gau { git add -u $args }
function gap { git add -p $args }
function gco { git checkout $args }
function gcp { git checkout -p $args }
function gcn { git checkout -b $args }
function gpu { git push }
function gpuu { git push -u origin (git branch --show-current) }
function glo { git log $args }
function gb { git branch }
function gcom { param ([Parameter(Mandatory)] [string]$msg)git commit -m $msg }
function gcam { param ([Parameter(Mandatory)] [string]$msg)git commit -am $msg }
function gas { git add * }

# Aliases for deleting local and remote branches
function gdrb {
    param (
        [string]$branchName=(git branch --show-current)
    )
    Write-Host "Deleting remote branch $branchName..."
    git push --delete origin $branchName
}

function gdlb {
    param (
        [string]$branchName
    )
    Write-Host "Deleting local branch  $branchName..."
    git branch -D $branchName
}

function gdb {
    param (
        [string]$branchName
    )
    gdrb $branchName
    gdlb $branchName
}


# Aliases for renaming local and remote branches
function grrb {
    param (
        [string]$branchName
    )
    Write-Host "Renaming remote branch..."
    $oldBranch = git branch --show-current
    git push origin origin/$($oldBranch):refs/heads/$branchName :$oldBranch
}

function grlb {
    param (
        [string]$branchName
    )
    Write-Host "Renaming local branch..."
    git branch -m $branchName
    git branch -u origin/$branchName
}

function grb {
    param (
        [string]$branchName
    )
    grrb $branchName
    grlb  $branchName
}


# ----- MISC ALIASES -----
function hist { param ([int]$num=25 ) Get-Content -Last $num (Get-PSReadlineOption).HistorySavePath }
