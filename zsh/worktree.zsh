# Git worktree helpers
# Source this from zshrc after oh-my-zsh is loaded (needs _git for compdef)
# Layout matches herdr's [worktrees] directory: ~/code/git-worktrees/<repo>/<branch-slug>

# Main checkout's repo name (works from inside any of its worktrees)
_gw_repo() { basename "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")" }

# Branch -> dir name: drop task/sutton/, / -> -
_gw_slug() { local b="${1#task/sutton/}"; echo "${b//\//-}" }

# Path of the worktree that has branch $1 checked out
_gw_path_for_branch() {
  git worktree list --porcelain | awk -v ref="refs/heads/$1" '
    /^worktree / { path = substr($0, 10) }
    $0 == "branch " ref { print path; exit }'
}

# fzf-pick a worktree path ($1 = initial query)
_gw_pick() { git worktree list | fzf --query "${1:-}" --select-1 --exit-0 | awk '{print $1}' }

# List worktrees
alias gwl='git worktree list'

# Prune stale worktree entries (dirs already deleted)
alias gwprune='git worktree prune -v'

# cd into a worktree (fzf, optional query)
gwcd() {
  local wt
  wt="$(_gw_pick "$1")" && [[ -n "$wt" ]] && cd "$wt"
}

# New worktree at ~/code/git-worktrees/<repo>/<slug>, then cd in
# Existing branch is checked out; otherwise created from $2 (default HEAD)
gwn() {
  [[ -z "$1" ]] && { echo "usage: gwn <branch> [base]"; return 1 }
  local wt=~/code/git-worktrees/"$(_gw_repo)"/"$(_gw_slug "$1")"
  if git show-ref --verify --quiet "refs/heads/$1"; then
    git worktree add "$wt" "$1"
  else
    git worktree add -b "$1" "$wt" "${2:-HEAD}"
  fi && cd "$wt"
}

# Free a branch (default: fzf pick) by detaching the worktree holding it
gwfree() {
  local wt
  if [[ -n "$1" ]]; then
    wt="$(_gw_path_for_branch "$1")"
    [[ -z "$wt" ]] && { echo "$1 isn't checked out in any worktree"; return 1 }
  else
    wt="$(_gw_pick)" || return
    [[ -z "$wt" ]] && return 1
  fi
  git -C "$wt" switch --detach && echo "Detached $wt"
}

# Remove a worktree (default: fzf pick). Refuses if dirty — rerun with git worktree remove --force
gwrm() {
  local wt
  wt="$(_gw_pick "$1")" && [[ -n "$wt" ]] || return 1
  local main="$(git worktree list | head -1 | awk '{print $1}')"
  [[ "$wt" == "$main" ]] && { echo "Won't remove the main checkout"; return 1 }
  [[ "$PWD/" == "$wt/"* ]] && cd "$main"
  git -C "$main" worktree remove "$wt" && echo "Removed $wt"
}

# ---------- Completions ----------
compdef _git gwn=git-checkout
compdef _git gwfree=git-branch
