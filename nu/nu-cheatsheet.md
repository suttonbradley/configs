# Nu Cheatsheet
- Official cheat sheet [here](https://www.nushell.sh/book/cheat_sheet.html)
- `help commands` for all commands
- `help <command>` for specific command

## Commands
- `sys` for system info
- `ps` for processes
- `path <subcmd>` for path ops
- `glob <flags> <glob>` for fetching a list of matching paths
  - flags [here](https://www.nushell.sh/commands/docs/glob.html#flags)

## Pass-throughs
- `save` for saving to a file (use `--append` to append)
- `$in` variable to directly reference what was passed in
- `where <closure>` for filtering
- `sort-by <attr>` for sorting
- `reverse` for ordering
- `any <closure>`/`all <closure>` for predicate testing
- `get` for getting a sub-table
- `enumerate` for making the iteration variable of a list have `index` and `item` members
  - `ls | enumerate | each { |i| $"Item ($i.index) is named ($i.item.name)" }`
- `reduce` for reducing a list using a closure (use `--fold` to provide initial value)
  - `[1 2 3 4] | reduce { |item, total| $item + $total }` yields 10
  - `[1 2 3 4] | reduce --fold 10 { |item, total| $item + $total }` yields 20
- TODO: && powershell equivalent

## Logging and exit codes
- `complete` for gathering stdout, stderr, and exit code into one table
- `$env.LAST_EXIT_CODE` for last exit code
- `out>`, `err>`, and `out+err>` for output redirection

# Misc
- `^<string>` to execute string as command
  - `let a = 'cargo'; ^$a` runs cargo
