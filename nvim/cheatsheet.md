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
- `:SessionSearch` to search auto-session sessions. See all commands [here](https://github.com/rmagatti/auto-session?tab=readme-ov-file#-commands)

## neo-tree (file explorer)
Full guide [here](https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#longer-example-for-lazynvim)
- `ctrl+n`: toggle pane
- Basics: `m`ove(/rename), `d`elete, `y`ank, `a`dd(/create), `d`elete
- `backspace`: show parent dir
- `/`: fuzzy find

## Code modification and suggestions
- `<leader>ca` code actions
- `<leader>gc` to toggle comment
- `shift+k` to see docs for hovered

## Remapped
- `:qq` for `:qa`, `:qqq` for `:qa!`
- `ctrl+n` to toggle finder
- `<leader>ff` to find files (telescope)
  - For any telescope command, `shift+enter` creates a vertical split and `ctrl+enter` creates horizontal split
- `<leader>fg` to grep code (telescope)
- `<leader>lg` for lazygit
  - _don't forget: `ctrl+c` to exit
- `<leader>ss` for to open session search window
- `<leader>sc` to create a session for the current working dir
