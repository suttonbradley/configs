alias cat = open
if (platform_is_windows) {
    def where [exe: string] { pwsh -NoProfile -c $"Get-Command ($exe)" }
}

alias lg = lazygit
alias nv = nvim

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

alias gs = git status
alias gd = git diff
alias gds = git diff --staged
alias gdm = git diff --merge-base
alias gdn = git diff --name-only
alias gl = git log
alias ga = git add
alias gap = git add -p $args
# alias gcp = git checkout -p $args
alias gc = git switch
alias gcn = git switch -c
alias gpu = git push
alias gpuu = git push -u origin (git branch --show-current | str trim)
alias gpuf = git push -f
alias gf = git fetch
alias gpl = git pull
alias glo = git log
alias gb = git branch
alias gca = git commit --amend
alias gcaa = git commit -a --amend
alias gco = git commit --amend
alias gr = git rebase

def gcom [msg: string] {
    git commit -m $msg
}

def gcam [msg: string] {
    git commit -am $msg
}

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

# ADD-ON Yield local branches + remote branches nonlocal without prefix
def "nu-complete git remote branches local and nonlocal without prefix" [] {
  mut result = nu-complete git local branches
  $result ++ (nu-complete git remote branches nonlocal without prefix)
}
# Delete remote branch
def gdrb [
    branchName: string@"nu-complete git remote branches local and nonlocal without prefix"
    no_fail: bool = false
] {
    let conf = (input $"Are you sure you would like to delete branch ($branchName) on the remote \(y/n\)? ")
    if $conf == "y" {
        if $no_fail {
            git push --delete origin $branchName | complete
        } else {
            git push --delete origin $branchName
        }
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
    gdrb $branchName true #no_fail so that local deletion still works
    gdlb $branchName
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
