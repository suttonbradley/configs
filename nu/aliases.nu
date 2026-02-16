# Functions for platform
def platform_is_windows [] {
    $nu.os-info.name == 'windows'
}

alias cat = open
if (platform_is_windows) {
    def where [exe: string] { pwsh -NoProfile -c $"Get-Command ($exe)" }
}

alias k = kiro-cli
alias lg = lazygit
alias nv = nvim
alias python = python3

# Sorted ripgrep for aliases that process ripgrep output.
# Include line numbers in ACTUAL ripgrep output (normally doesn't go through pipe)
# https://github.com/BurntSushi/ripgrep/issues/796
alias rgs = rg -n --sort-files

# ---------- dir changes ----------
# NOTE: $env.DIRS_LIST is used by nushell to track w.r.t. enter/exit commands

alias cd = z

# Alias for "enter" but use zoxide for matching to common dirs.
# The "def --env" is needed for doing these ops *in the current environment*,
# rather than cd'ing in the function and then returning to original dir in the scope above.
def --env e [dir: string] {
    if ($dir | path exists) {
        # Literal path exists, go to it
        enter $dir
    } else {
        # Try to use zoxide, printing but otherwise no-op'ing if unsuccessful
        let res = zoxide query -l $dir | lines
        if not ($res | is-empty) {
            enter $res.0
        } else {
            echo $"no match for \"($dir)\""
        }
    }
}

# ---------- git aliases ----------
source ~/code/configs/nu/nu_scripts/custom-completions/git/git-completions.nu

def gs [...args] { git status ...$args }
def gd [ref?: string@"nu-complete git refs", ref2?: string@"nu-complete git refs"] {
    if $ref2 != null {
        git diff $ref $ref2
    } else if $ref != null {
        git diff $ref
    } else {
        git diff
    }
}
def ga [...args] { git add ...$args }
def gap [...args] { git add -p ...$args }
def gc [ref: string@"nu-complete git checkout"] { git checkout $ref }
def gcn [ref: string, root?: string] {
    if $root != null {
        git switch -c $ref $root
    } else {
        git switch -c $ref
    }
}
alias gpu = git push
alias gpuu = git push -u origin (git branch --show-current | str trim)
alias gpuf = git push -f
alias gf = git fetch
alias gpl = git pull
def glo [ref?: string@"nu-complete git local branches"] {
    if $ref != null {
        git log $ref
    } else {
        git log
    }
}
alias gb = git branch
def gcm [msg: string] { git commit -m $msg }
def gcam [msg: string] { git commit -am $msg }
alias gca = git commit --amend
alias gcaa = git commit --amend -a
def grb [ref: string@"nu-complete git mergable sources"] { git rebase $ref }
alias grbi = git rebase -i
alias grbc = git rebase --continue
alias grba = git rebase --abort
def grs [...args: string@"nu-complete git refs"] { git reset ...$args }
def grsh [ref?: string@"nu-complete git refs"] {
    if $ref != null {
        git reset --hard $ref
    } else {
        git reset --hard
    }
}
alias grshh = git reset --hard HEAD
alias gsu = git submodule update

def gmb [
    rev_one: string@"nu-complete git local branches" = "main"
    rev_two?: string@"nu-complete git local branches"
] {
    let rev_two = if $rev_two == null {
        git branch --show-current | str trim
    } else {
        $rev_two
    }
    print $"Common ancestor between ($rev_one) and ($rev_two):"
    git merge-base $rev_one $rev_two
}

# Delete remote branch
def gder [ref: string@"nu-complete git remote branches with prefix"] {
    print $"Deleting remote branch ($ref)..."
    git push --no-verify --delete origin $ref
}

# Delete local branch
def gdel [ref: string@"nu-complete git local branches"] {
    print $"Deleting local branch  ($ref)..."
    git branch -D $ref
}

# Delete local and remote branch
def gde [ref: string@"nu-complete git local branches"] {
    gder $ref
    gdel $ref
}

# Rename local branch
def grnl [branchName: string] {
    print "Renaming local branch..."
    git branch -m $branchName
}

# Rename remote and local branch
def grn [branchName: string] {
    print "Renaming remote branch..."
    let oldBranch = git branch --show-current | str trim
    git push origin $"origin/($oldBranch):refs/heads/($branchName)" $":($oldBranch)"
    grnl $branchName
}
