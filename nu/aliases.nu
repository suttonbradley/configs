alias cat = open
alias cd = z
if (platform_is_windows) {
    def where [exe: string] { pwsh -NoProfile -c $"Get-Command ($exe)" }
}

# ---------- git aliases ----------
source ./custom-completions/git/git-completions.nu

alias gs = git status
alias gco = git checkout
alias gd = git diff
alias gdn = git diff --name-only
alias gl = git log
alias ga = git add
# alias gap = git add -p $args
# alias gcp = git checkout -p $args
alias gcn = git checkout -b
alias gpu = git push
alias gpuu = git push -u origin (git branch --show-current | str trim)
alias gpuf = git push -f
alias gpl = git pull
alias glo = git log
alias gb = git branch
alias gcom = git commit -am
alias gcam = git commit -am

# Find the last common ancestor of two refs
def gmb [
    rev_one?: string@"nu-complete git local branches" = "main"
    rev_two?: string@"nu-complete git local branches"
] {
    let rev_two = if $rev_two == null {
        git branch --show-current | str trim
    } else {
        $rev_two
    }
    git merge-base $rev_one $rev_two
}


# ----- Branch deletion/renaming -----

# Delete remote branch
def gdrb [
    branchName: string@"nu-complete git local branches" # TODO: fix
] {
    let conf = (input $"Are you sure you would like to delete branch ($branchName) on the remote \(y/n\)? ")
    if $conf == "y" {
        git push --delete origin $branchName
    } else {
        echo $"Did not delete remote branch $branchName"
    }
}
# Delete local branch
def gdlb [
    branchName: string@"nu-complete git local branches"
] {
    git branch -D $branchName
}

# Delete local and remote branch
def gdb [
    branchName: string@"nu-complete git local branches"
] {
    gdlb $branchName
    gdrb $branchName
}

# Rename remote branch
def grrb [
    branchName: string
] {
    let oldBranch = git branch --show-current | str trim
    git push origin $"origin/($oldBranch):refs/heads/($branchName)" $":($oldBranch)"
}

# Rename local branch
def grlb [
    branchName: string
] {
    git branch -m $branchName
    git branch -u $"origin/($branchName)"
}

# Rename local and remote branch
def grb [
    branchName: string
] {
    grrb $branchName
    grlb  $branchName
}
# ---------------------------------
