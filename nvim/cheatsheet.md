_Just commands we're trying to use, not an exhaustive list_

_NOTE ON PLUGINS_: In lazy.nvim lua setup scripts, pass `opts = {}` or `config = true` if possible, which calls the `setup` function, instead of using `config` (more [here](https://lazy.folke.io/spec#spec-setup))

## Standard vim motions
- `w`/`e`: jump forward word (beginning vs. end)
- `b`/`ge`: jump backward word (beginning vs. end)
- `y`/`d`: yank/delete (copy/cut)
  - `yy`/`dd` yank/delete line
- `u`: undo, `ctrl+r` redo
- `i`/`a`/`A`/`o`/`O`: insert (here, after cursor, end of line, after line, before line)
- `f`/`F`: goto next (backwards vs. fwds)
- `zz`: center screen on cursor
- `$` for end of line, `^` for beginning
  - use throughout, like `v$` selects cursor through end of line in visual mode
- `ctrl+y/h` for half page up/down + center the screen

## Visual mode
- `vi<char>` selects inside of pair of `<char>` (`'`, `"`, etc.). Shortcuts to this:
  - `vib` select inside of `()`
  - `viB` select inside of `{}`

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
- `:Lazy` to update plugins
- `:checkhealth` is generally useful

## neo-tree (file explorer)
Full guide [here](https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#longer-example-for-lazynvim)
- `ctrl+n`: toggle pane
- Basics: `m`ove(/rename), `d`elete, `y`ank, `a`dd(/create), `d`elete
- `backspace`: show parent dir
- `/`: fuzzy find

## Code modification and suggestions
- `<leader>ca` code actions
- `shift+k` to see docs for hovered
- `gcc` to toggle comment on this line
- `gc<num>[j/k]` to comment this line + `num` more lines up/down
  - or, visual (line) mode and gc within it
- `gd` to go to definition
- `gD` to go to declaration
- `gr` to go to references
- `gu` to "_g_o _u_p" (remapped from `ctrl+t`, which jumps back to previous jump point)

## Remapped
- `:qq` for `:qa`, `:qqq` for `:qa!`
- `ctrl+n` to toggle finder
- `<leader>ff` to find files (telescope)
  - For any telescope command, `shift+enter` creates a vertical split and `ctrl+enter` creates horizontal split
- `<leader>fg` to grep code (telescope)
- `<leader>fm` to format code
- `<leader>lg` for lazygit
  - _don't forget: `ctrl+c` to exit
- `<leader>ss` for to open session search window
- `<leader>tt` to open floating, persistent terminal
### Windows
- `alt+h/j/k/l` to move cursor between windows
- `alt+H/J/K/L` to resize windows
### Harpooon
- `<leader>ha` to add this file to harpoon
- `<leader>hp` to open harpoon menu (in telescope)
  - Within that, `dd` to delete an entry, then `:wq` to save the new list
- In normal mode `ctrl` + any of `jkluiop` are the file indexes
- `<leader>v` on a menu item to open in a vsplit to the right
- TODO: telescope integration didn't work to delete files. Bring that back?

## Macros
- Record with `q<reg>` where `<reg>` is the register the macro is recorded to
  - normally, `qq` for convenience
- `q` in normal mode to stop recording
- `@<reg>` to run the macro
  - make use of numbers - `5@q` runs the macro 5 times

## Misc
- for weirdness with terminal escape sequences, you can use `:echo getcharstr()` and then hit a key combo to see what vim actually receives 
