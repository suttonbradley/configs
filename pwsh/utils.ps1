# This script consists of functions and aliases that can be reused.
# Importing it should not run any code.

# FOR USE WITH ERD COMPLETIONS
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function lg { lazygit $args}
# Remove 'nv' alias if it exists
Get-Alias nv *>&1 | Out-Null
if($?) {
    Remove-Item alias:nv -Force
}
function nv { nvim $args }

function rr { rustrover64 $args }

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
        New-BurntToastNotification -Text "Complete: $args_string", "Exit code: $lastexitcode"
    }
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
function dexit {
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
function gdi {
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
function gdim {
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
function gdin {
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
function gcn { param([Parameter(Mandatory, Position=0)]$ref, [Parameter(Mandatory=$false, Position=1)]$root) Invoke-Expression "git switch -c $ref $root" }
function gpu { git push }
function gpuu { git push -u origin (git branch --show-current) }
function gpuf { git push -f }
function gf { git fetch $args }
function gpl { git pull $args }
function glo { param([Parameter(Position=0)]$ref) git log $ref }
function gb { git branch }
# Remove existing gcm command
Get-Alias gcm *>&1 | Out-Null
if($?) {
    Remove-Item alias:gcm -Force
}
function gcm { param ([Parameter(Mandatory)] [string]$msg) git commit -m $msg }
function gcam { param ([Parameter(Mandatory)] [string]$msg) git commit -am $msg }
function gca { git commit --amend $args }
function gcaa { git commit --amend -a $args }
function grb { param ([Parameter(Mandatory)] [string]$ref) git rebase $ref $args }
function grbi { git rebase -i $args }
function grbc { git rebase --continue $args }
function grba { git rebase --abort $args }
function grs { git reset $args }
function grsh { git reset --hard $args }
function grshh { git reset --hard head $args }
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
function gder {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    Write-Host "Deleting remote branch $ref..."
    git push --no-verify --delete origin $ref
}

function gdel {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    Write-Host "Deleting local branch  $ref..."
    git branch -D $ref
}

function gde {
    param (
        [Parameter(Mandatory, Position=0)] [string]$ref
    )
    gdrb $ref
    gdlb $ref
}

function gclean {
    $branches = git branch --format='%(refname:short)' | Where-Object {
        -not (git ls-remote --heads origin $_ 2>$null)
    }

    if (-not $branches) {
        Write-Host "Clean! No local branches without remotes found"
        return
    }

    $branches | ForEach-Object {
        $confirm = Read-Host - "Delete branch '$_'? (y/n)"
        if ($confirm -eq 'y') {
            gdlb $_ | Out-Null
            Write-Host "Deleted"
        } else {
            Write-Host "Not deleted"
        }
    }
}

# Aliases for renaming branches
function grnl {
    param (
        [Parameter(Mandatory)] [string]$branchName
    )
    Write-Host "Renaming local branch..."
    git branch -m $branchName
}

function grn {
    param (
        [Parameter(Mandatory)] [string]$branchName
    )
    Write-Host "Renaming remote branch..."
    $oldBranch = git branch --show-current
    git push origin origin/$($oldBranch):refs/heads/$branchName :$oldBranch

    grnl  $branchName
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

Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitLocalBranches -ParameterName 'ref' -CommandName gc,gdel,gde,gdi,gdim,gdin,glo
Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitRemoteBranches -ParameterName 'ref' -CommandName gder
Register-ArgumentCompleter -ScriptBlock $COMPLETER_GetGitAllBranches -ParameterName 'ref' -CommandName grb,grbi

# AUTO-GENERATED BY ERDTREE
Register-ArgumentCompleter -Native -CommandName 'erd' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'erd'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'erd' {
            [CompletionResult]::new('-c', '-c', [CompletionResultType]::ParameterName, 'Use configuration of named table rather than the top-level table in .erdtree.toml')
            [CompletionResult]::new('--config', '--config', [CompletionResultType]::ParameterName, 'Use configuration of named table rather than the top-level table in .erdtree.toml')
            [CompletionResult]::new('-C', '-C ', [CompletionResultType]::ParameterName, 'Mode of coloring output')
            [CompletionResult]::new('--color', '--color', [CompletionResultType]::ParameterName, 'Mode of coloring output')
            [CompletionResult]::new('-d', '-d', [CompletionResultType]::ParameterName, 'Print physical or logical file size')
            [CompletionResult]::new('--disk-usage', '--disk-usage', [CompletionResultType]::ParameterName, 'Print physical or logical file size')
            [CompletionResult]::new('-L', '-L ', [CompletionResultType]::ParameterName, 'Maximum depth to display')
            [CompletionResult]::new('--level', '--level', [CompletionResultType]::ParameterName, 'Maximum depth to display')
            [CompletionResult]::new('-p', '-p', [CompletionResultType]::ParameterName, 'Regular expression (or glob if ''--glob'' or ''--iglob'' is used) used to match files')
            [CompletionResult]::new('--pattern', '--pattern', [CompletionResultType]::ParameterName, 'Regular expression (or glob if ''--glob'' or ''--iglob'' is used) used to match files')
            [CompletionResult]::new('-t', '-t', [CompletionResultType]::ParameterName, 'Restrict regex or glob search to a particular file-type')
            [CompletionResult]::new('--file-type', '--file-type', [CompletionResultType]::ParameterName, 'Restrict regex or glob search to a particular file-type')
            [CompletionResult]::new('-s', '-s', [CompletionResultType]::ParameterName, 'How to sort entries')
            [CompletionResult]::new('--sort', '--sort', [CompletionResultType]::ParameterName, 'How to sort entries')
            [CompletionResult]::new('--dir-order', '--dir-order', [CompletionResultType]::ParameterName, 'Sort directories before or after all other file types')
            [CompletionResult]::new('-T', '-T ', [CompletionResultType]::ParameterName, 'Number of threads to use')
            [CompletionResult]::new('--threads', '--threads', [CompletionResultType]::ParameterName, 'Number of threads to use')
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Report disk usage in binary or SI units')
            [CompletionResult]::new('--unit', '--unit', [CompletionResultType]::ParameterName, 'Report disk usage in binary or SI units')
            [CompletionResult]::new('-y', '-y', [CompletionResultType]::ParameterName, 'Which kind of layout to use when rendering the output')
            [CompletionResult]::new('--layout', '--layout', [CompletionResultType]::ParameterName, 'Which kind of layout to use when rendering the output')
            [CompletionResult]::new('--completions', '--completions', [CompletionResultType]::ParameterName, 'Print completions for a given shell to stdout')
            [CompletionResult]::new('-f', '-f', [CompletionResultType]::ParameterName, 'Follow symlinks')
            [CompletionResult]::new('--follow', '--follow', [CompletionResultType]::ParameterName, 'Follow symlinks')
            [CompletionResult]::new('-H', '-H ', [CompletionResultType]::ParameterName, 'Print disk usage in human-readable format')
            [CompletionResult]::new('--human', '--human', [CompletionResultType]::ParameterName, 'Print disk usage in human-readable format')
            [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Do not respect .gitignore files')
            [CompletionResult]::new('--no-ignore', '--no-ignore', [CompletionResultType]::ParameterName, 'Do not respect .gitignore files')
            [CompletionResult]::new('-I', '-I ', [CompletionResultType]::ParameterName, 'Display file icons')
            [CompletionResult]::new('--icons', '--icons', [CompletionResultType]::ParameterName, 'Display file icons')
            [CompletionResult]::new('--glob', '--glob', [CompletionResultType]::ParameterName, 'Enables glob based searching')
            [CompletionResult]::new('--iglob', '--iglob', [CompletionResultType]::ParameterName, 'Enables case-insensitive glob based searching')
            [CompletionResult]::new('-P', '-P ', [CompletionResultType]::ParameterName, 'Remove empty directories from output')
            [CompletionResult]::new('--prune', '--prune', [CompletionResultType]::ParameterName, 'Remove empty directories from output')
            [CompletionResult]::new('-x', '-x', [CompletionResultType]::ParameterName, 'Prevent traversal into directories that are on different filesystems')
            [CompletionResult]::new('--one-file-system', '--one-file-system', [CompletionResultType]::ParameterName, 'Prevent traversal into directories that are on different filesystems')
            [CompletionResult]::new('-.', '-.', [CompletionResultType]::ParameterName, 'Show hidden files')
            [CompletionResult]::new('--hidden', '--hidden', [CompletionResultType]::ParameterName, 'Show hidden files')
            [CompletionResult]::new('--no-git', '--no-git', [CompletionResultType]::ParameterName, 'Disable traversal of .git directory when traversing hidden files')
            [CompletionResult]::new('--dirs-only', '--dirs-only', [CompletionResultType]::ParameterName, 'Only print directories')
            [CompletionResult]::new('--no-config', '--no-config', [CompletionResultType]::ParameterName, 'Don''t read configuration file')
            [CompletionResult]::new('--no-progress', '--no-progress', [CompletionResultType]::ParameterName, 'Hides the progress indicator')
            [CompletionResult]::new('--suppress-size', '--suppress-size', [CompletionResultType]::ParameterName, 'Omit disk usage from output')
            [CompletionResult]::new('--truncate', '--truncate', [CompletionResultType]::ParameterName, 'Truncate output to fit terminal emulator window')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help (see more with ''--help'')')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
