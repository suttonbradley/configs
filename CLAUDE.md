# CLAUDE.md

Personal dotfiles, symlinked into place (see README.md). Only zsh carries the full feature set; the nushell and PowerShell configs aren't in use right now.

## Zsh (`zsh/`)

- `zshrc` sources each `zsh/*.zsh` file explicitly; add a `source` line for new files (after oh-my-zsh if they use `compdef`).
- `zhelp` lists every top-level alias/function with the first line of the comment directly above it. Give new ones a one-line `# description`, define them at column 0, and prefix internal helpers with `_`.
- `worktree.zsh` hardcodes `~/code/git-worktrees` as the worktree root, matching `[worktrees] directory` in `herdr.toml`; change both together.

## Commits

Short lowercase subject. Pushing straight to `main` is fine.
