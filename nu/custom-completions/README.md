# TAKEN FROM
https://github.com/nushell/nu_scripts/tree/main/custom-completions
Last commit used: dbf4586594a30eeec3e3a39977a397d5ea4b6be0

# Custom completions

This current directory provides custom completions. They can be used by importing their exported commands via:

```nushell
use path/to/<command>/<command>-completions.nu *
# or
source path/to/<command>/<command>-completions.nu
# without the `*` at the end
```

With `path/to/<command>` being either the relative path of the file to your current working directory or its absolute path.

Bear in mind that if you import the `use <path> *`, it is important that you don't name a function with the same name of the file

```nu
# file: rustup.nu 

export extern rustup [
    ...args
]
```
`use ./rustup.nu *` won't work here
