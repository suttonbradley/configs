# This script consists of functions and aliases that can be reused.
# Importing it should not run any code.

function Enter-DevPowershell {
    # Find vswhere
    $vswhere_path = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe"
    if(!(Test-Path $vswhere_path)) {
        Write-Host "ERROR: Could not find vswhere at `"$vswhere_path`""
        return
    }

    # Find vs dev shell powershell script
    $version_range = "[16.7.2, 18.0)"
    $vs_devshell_rel = "Common7\Tools\Launch-VsDevShell.ps1"
    $vs_devshell_abs = & $vswhere_path -nologo -latest -products 'Microsoft.VisualStudio.Product.BuildTools' -version $version_range `
        -products Microsoft.VisualStudio.Product.Enterprise Microsoft.VisualStudio.Product.BuildTools `
        -find $vs_devshell_rel
    if($null -eq $vs_devshell_abs) {
        Write-Host "ERROR: Could not find `"$vs_devshell_rel`" in VS install matching version range `"$version_range`""
        return
    }

    & $vs_devshell_abs
}

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

function Get-HistPath {
    return (Get-PSReadlineOption).HistorySavePath
}

# Executes the command following it and notifies when complete
# Usage: `notif <command>`, e.g. `notif git push -f`
function notif {
    if($args) {
        $args_string = $args -Join " "
        Invoke-Expression $args_string
    } else {
        $args_string = ""
    }

    New-BurntToastNotification -Text "Command completed", $args_string
}

# Brings up a notification with the message parameter(s)
# Usage: `<command> && notif-msg "Success" || notif-msg "Failure"
function notif-msg {
    param (
        [Parameter(Mandatory, Position=0)]
        $header,
        [Parameter(Position=1)]
        $footer=""
    )

    New-BurntToastNotification -Text $header, $footer
}

# ----- nushell-style dir switch -----
# Init if new session
if(!(Test-Path variable:SHELL_SWITCHER)) {
    $SHELL_SWITCHER = @{
        shells = @()
        idx = 0
    }
    $SHELL_SWITCHER.shells += $(Get-Location)
}
# See if n alias exists (notepad) and remove if so
Get-Alias n *>&1 | Out-Null
if($?) {
    Remove-Item alias:n -Force
}

# Enter shell
function e {
    param (
        [Parameter(Mandatory)]
        [string]$dir
    )
    # Check and resolve path
    if(!(Test-Path -Path $dir -PathType Container)) {
        Write-Host "Directory `"$dir`" does not exist"
        return
    }
    $dir = Resolve-Path $dir
    # If already in list, go to it
    $index = $SHELL_SWITCHER.shells.IndexOf($dir)
    if($index -ne -1) {
        Write-Host "Already in shells. Switching..."
        $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] = $(Get-Location)
        $SHELL_SWITCHER.idx = $index
        Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
        return
    }

    # Else, append new, go to new, set index
    $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] = $(Get-Location)
    $SHELL_SWITCHER.shells += $dir
    $SHELL_SWITCHER.idx = $SHELL_SWITCHER.shells.Count - 1
    Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
}

# Exit shell
function shellexit {
    # Remove current, go to previous
    $SHELL_SWITCHER.shells = $SHELL_SWITCHER.shells | Where-Object -FilterScript { $_ -ne $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] }
    # Dumb powershell behavior where if there's only one element, it's not an array
    if($SHELL_SWITCHER.shells.GetType().FullName -eq "System.Management.Automation.PathInfo") {
        $SHELL_SWITCHER.shells = @($SHELL_SWITCHER.shells)
    }
    $SHELL_SWITCHER.idx = [Math]::Max(0, $SHELL_SWITCHER.idx - 1) % $SHELL_SWITCHER.shells.Count
    Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
}

# Go to next shell location
function n {
    # Save current, go to next
    $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] = $(Get-Location)
    $SHELL_SWITCHER.idx = ($SHELL_SWITCHER.idx + 1) % $SHELL_SWITCHER.shells.Count
    Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
}

# Go to previous shell location
function p {
    # Save current, go to previous
    $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] = $(Get-Location)
    $SHELL_SWITCHER.idx = ($SHELL_SWITCHER.idx - 1) % $SHELL_SWITCHER.shells.Count
    Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
}

# Go to index
function g {
    param (
        [Parameter(Mandatory)]
        [int]$idx
    )
    if($idx -ge 0 -and $idx -lt $SHELL_SWITCHER.shells.Count) {
        $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx] = $(Get-Location)
        $SHELL_SWITCHER.idx = $idx
        Set-Location $SHELL_SWITCHER.shells[$SHELL_SWITCHER.idx]
    } else {
        Write-Host "Shell index out of range"
    }
}

# List all shell locations
function shells {
    Write-Host -NoNewline "Shell locations ("
    Write-Host -NoNewline -ForegroundColor Blue "active in blue"
    Write-Host "):"
    foreach ($index in 0..($SHELL_SWITCHER.shells.Count - 1)) {
        $dir = $SHELL_SWITCHER.shells[$index]
        if ($index -eq $SHELL_SWITCHER.idx) {
            Write-Host -NoNewline -ForegroundColor Blue "$index`: "
        } else {
            Write-Host -NoNewline "$index`: "
        }
        Write-Host -ForegroundColor Green $dir
    }
}

# ----- GIT ALIASES -----
# See if gc alias exists (Get-Content) and remove if so
Get-Alias gc *>&1 | Out-Null
if($?) {
    Remove-Item alias:gc -Force
}
# Standard git aliases
function gs { git status $args }
function gd {
    param(
        [Parameter(Position=0)]$ref,
        [Parameter(Position=1)]$ref2
    )
    if($ref2) {
        git diff $ref $ref2
    } else {
        git diff $ref
    }
}
function gdm {
    param(
        [Parameter(Position=0)]$ref,
        [Parameter(Position=1)]$ref2
    )
    if($ref2) {
        git diff --merge-base $ref $ref2
    } else {
        git diff --merge-base $ref
    }
}
function gdn {
    param(
        [Parameter(Position=0)]$ref,
        [Parameter(Position=1)]$ref2
    )
    if($ref2) {
        git diff --name-only $ref $ref2
    } else {
        git diff --name-only $ref
    }
}
function ga { git add $args }
function gap { git add -p $args }
function gc { param([Parameter(Mandatory, Position=0)]$ref) git checkout $ref }
function gsw { param([Parameter(Mandatory, Position=0)]$ref) Invoke-Expression "git switch --merge $ref" }
function gcn { param([Parameter(Mandatory, Position=0)]$ref) Invoke-Expression "git switch -c $ref" }
function gpu { git push }
function gpuu { git push -u origin (git branch --show-current) }
function gpuf { git push -f }
function gf { git fetch $args }
function gpl { git pull $args }
function glo { param([Parameter(Position=0)]$ref) git log $ref }
function gb { git branch }
function gcom { param ([Parameter(Mandatory)] [string]$msg) git commit -m $msg }
function gcam { param ([Parameter(Mandatory)] [string]$msg) git commit -am $msg }
function gca { git commit --amend $args }
function gcaa { param ([Parameter(Mandatory)] [string]$msg) git commit --amend -a $args }
function gre { param ([Parameter(Mandatory)] [string]$ref) git rebase $ref $args }
function gsu { git submodule update $args }

# function gbs {
#     param (
#         [Parameter(Mandatory)]
#         [string]$search,
#         [Alias('r')]
#         [switch]$remote
#     )

#     $remote_arg = $remote ? "-r" : "" # Pass this switch on
#     # Search git branches for anything containing the search (regex "*<search>*")
#     git branch --list "*$search*" --format='%(refname:short)' $remote_arg
# }

function gmb {
    param (
        [string]$rev_one="main",
        [string]$rev_two=(git branch --show-current)
    )
    Write-Host "Common ancestor between $rev_one and ${rev_two}:"
    return (git merge-base $rev_one $rev_two)
}

# Aliases for deleting local and remote branches
function gdrb {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    Write-Host "Deleting remote branch $ref..."
    git push --delete origin $ref
}

function gdlb {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    Write-Host "Deleting local branch  $ref..."
    git branch -D $ref
}

function gdb {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    gdrb $ref
    gdlb $ref
}

# Aliases for renaming branches
function grlb {
    param (
        [Parameter(Mandatory)] [string]$branchName
    )
    Write-Host "Renaming local branch..."
    git branch -m $branchName
}

function grb {
    param (
        [Parameter(Mandatory)] [string]$branchName
    )
    Write-Host "Renaming remote branch..."
    $oldBranch = git branch --show-current
    git push origin origin/$($oldBranch):refs/heads/$branchName :$oldBranch

    grlb  $branchName
}

# ----- MISC ALIASES -----
function hist { param ([int]$num=25 ) Get-Content -Tail $num (Get-PSReadlineOption).HistorySavePath }

function tail {
    param (
        [Parameter(Mandatory)] [string]$file,
        [int]$tail_num=0
    )
    if($tail_num -eq 0) {
        Get-Content $file -Tail $tail_num -Wait
    } else {
        Get-Content $file -Tail $tail_num
    }
}

function rmrf {
    param (
        [string]$dir
    )
    Remove-Item -force -recurse $dir
}

# Alias code-insiders to codei
function codei { code-insiders $args }

# ----- Argument completion -----
# TODO: filter out current branch from these?
$COMPLETER_GetGitLocalBranches = {
    param($commandName, $parameterName, $wordsToComplete, $commandAst, $fakeBoundParameter)
    (git branch --list "*$wordsToComplete*" --format='%(refname:short)').ForEach({
        [System.Management.Automation.CompletionResult]::new($_)
    })
}
$COMPLETER_GetGitRemoteBranches = {
    param($commandName, $parameterName, $wordsToComplete, $commandAst, $fakeBoundParameter)
    (git branch --remotes --list "*$wordsToComplete*" --format='%(refname:short)').ForEach({
        [System.Management.Automation.CompletionResult]::new($_)
    })
}
$COMPLETER_GetGitAllBranches = {
    param($commandName, $parameterName, $wordsToComplete, $commandAst, $fakeBoundParameter)
    Out-File -Append -InputObject "$wordsToComplete" -FilePath (Join-Path $env:userprofile "debug.txt") | Out-Null
    (git branch --all --list "*$wordsToComplete*" --format='%(refname:short)').ForEach({
        [System.Management.Automation.CompletionResult]::new($_)
    })
}

Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitLocalBranches -ParameterName 'ref' -CommandName gc,gsw,gdlb,gdb,gd,gdm,gdn,glo
Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitRemoteBranches -ParameterName 'ref' -CommandName gdrb
Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitAllBranches -ParameterName 'ref' -CommandName gre
