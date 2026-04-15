# Git aliases — mirrors nu/aliases.nu and pwsh/utils.ps1
# Source this from zshrc after oh-my-zsh is loaded (needs _git for compdef)

# ---------- Simple aliases (flags pass through naturally) ----------
alias gs='git status'
alias ga='git add -u'
alias gA='git add'
alias gap='git add -p'
alias gpu='git push'
alias gpuf='git push -f'
alias gf='git fetch'
alias gpl='git pull'
alias gb='git branch'
alias gca='git commit --amend'
alias gcaa='git commit --amend -a'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grs='git reset'
alias grshh='git reset --hard HEAD'
alias gsu='git submodule update'

# ---------- Functions (need branch args or special logic) ----------

# Push current branch and set upstream
gpuu() { git push -u origin "$(git branch --show-current)" }
gpuuf() { git push --force -u origin "$(git branch --show-current)" }

# Checkout
gc() { git checkout "$@" }

# New branch (optionally from a root ref)
gcn() {
  if [[ -n "$2" ]]; then
    git switch -c "$1" "$2"
  else
    git switch -c "$1"
  fi
}

# Diff (0, 1, or 2 refs)
gd() { git diff "$@" }

# Log (optionally for a specific ref)
glo() { git log "$@" }

# Commit with message
gcm() { git commit -m "$1" }
gcam() { git commit -am "$1" }

# Rebase
grb() { git rebase "$@" }

# Reset --hard (optionally to a ref)
grsh() {
  if [[ -n "$1" ]]; then
    git reset --hard "$1"
  else
    git reset --hard
  fi
}

# Merge base (defaults: main vs current branch)
gmb() {
  local rev_one="${1:-main}"
  local rev_two="${2:-$(git branch --show-current)}"
  echo "Common ancestor between $rev_one and $rev_two:"
  git merge-base "$rev_one" "$rev_two"
}

# Delete remote branch
gder() {
  echo "Deleting remote branch $1..."
  git push --no-verify --delete origin "$1"
}

# Delete local branch
gdel() {
  echo "Deleting local branch  $1..."
  git branch -D "$1"
}

# Delete local and remote branch
gde() {
  gder "$1"
  gdel "$1"
}

# Rename local branch
grnl() {
  echo "Renaming local branch..."
  git branch -m "$1"
}

# Rename remote and local branch
grn() {
  echo "Renaming remote branch..."
  local old_branch
  old_branch="$(git branch --show-current)"
  git push origin "origin/$old_branch:refs/heads/$1" ":$old_branch"
  grnl "$1"
}

# ---------- Completions (branch name tab-completion) ----------
compdef _git gd=git-diff
compdef _git gc=git-checkout
compdef _git glo=git-log
compdef _git grb=git-rebase
compdef _git grs=git-reset
compdef _git grsh=git-reset
compdef _git gmb=git-merge-base
compdef _git gdel=git-branch
compdef _git gde=git-branch
compdef _git gder=git-branch
