_Just commands we're trying to use, not an exhaustive list_

_NOTE ON PLUGINS_: In lazy.nvim lua setup scripts, pass `opts = {}` or `config = true` if possible, which calls the `setup` function, instead of using `config` (more [here](https://lazy.folke.io/spec#spec-setup))

## Standard vim motions
- `w`/`e`: jump forward word (beginning vs. end)
- `b`/`ge`: jump backward word (beginning vs. end)
- `y`/`d`: yank/delete (copy/cut)
  - `yy`/`dd` yank/delete line
- `u`: undo
- `i`/`a`/`o`: insert (here, after cursor, after line)
- `f`/`F`: goto next (backwards vs. fwds)
- `zz`: center screen on cursor

## Visual mode
- `vi<char>` selects inside of pair of `<char>` (`'`, `"`, etc.). Shortcuts to this:
  - `vib` select inside of `()`
  - `viB` select inside of `()`

## Commands
- Search: `/<query>` + enter, then `n`/`N` to seek
- Find/replace: `:%s/<query>/<replacement>/<flags>`
  - `%` is the _range_ of all lines. Omit for this line or do `:1,5%` for lines 1-5
  - Flags:
    - `g`: replace all occurrances on each line (default is first occurrance)
    - `c`: confirm before changing
- Toggle relative/abs line numbers: `:set rnu!`
- By default, config will show abs for current line, relative for rest
### Plugin Commands
- `:Mason`: open mason for LSPs
- `:LspInfo`: get diagnostics on LSPs
- `:Gitsigns`: actions for stuff like `:Gitsigns blame` to show blame in gutter

## neo-tree (file explorer)
Full guide [here](https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#longer-example-for-lazynvim)
- `ctrl+n`: toggle pane
- Basics: `m`ove(/rename), `d`elete, `y`ank, `a`dd(/create), `d`elete
- `backspace`: show parent dir
- `/`: fuzzy find

## Remapped
- `:qq` for `:qa`, `:qqq` for `:qa!`
- `ctrl+n` to toggle finder
- `ctrl+p` to open telescope (fuzzy finder)
- `<leader>lg` for lazygit
  - _don't forget: `ctrl+c` to exit

- `ctrl+u`/`ctrl+d` for scroll half page
  - remapped to center cursor using `zz`
  - FIXME: `ctrl+d` kinda sucks for the left hand
