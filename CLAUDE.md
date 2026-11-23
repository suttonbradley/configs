# CLAUDE.md

Personal dotfiles. Most files are symlinked into place (see README.md for each tool's link command), so edits here are live after reloading the tool (`exec zsh`, `herdr server reload-config`, etc.).

## Zsh (`zsh/`)

- `zshrc` sources each `zsh/*.zsh` file explicitly. A new file needs a `source ~/code/configs/zsh/<file>.zsh` line in `zshrc`, after oh-my-zsh if it uses `compdef`.
- `zhelp` (`help.zsh`) is the docs: it lists every top-level alias/function with the first line of the comment block directly above it. When adding one:
  - Put a one-line `# description` directly above it (no blank line between). Extra comment lines below that first one are ignored by `zhelp`.
  - Uncommented aliases and one-line functions fall back to showing their body, so only skip the comment when the body says it all.
  - Prefix internal helpers with `_` to hide them.
  - Define at column 0 (`name() {` or `alias name=`); indented definitions aren't listed.
  - Check with `zhelp <file-filter>`.
- `git-aliases.zsh` mirrors `nu/aliases.nu` and `pwsh/utils.ps1`; keep the three in sync when changing a shared alias. Other zsh files are zsh-only.
- `worktree.zsh` uses the same worktree root as `[worktrees] directory` in `herdr.toml` (`~/code/git-worktrees/<repo>/<branch-slug>`); change both together.

## Commits

Short lowercase subject, no body needed. Pushing straight to `main` is fine.
