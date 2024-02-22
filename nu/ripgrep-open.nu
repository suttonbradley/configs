# Takes the piped-in ripgrep input and opens vscode at result i (file and line).
# ripgrep output should be sorted with --show-lines in order to be predictable.
# Only works with rg -n since normal rg output does not include line numbers in the pipe.
def rgol [i: int] {
    let res = $in | lines | get $i | split row ':'
    code -g $"($res.0):($res.1)"
}

# Takes the piped-in ripgrep input and opens vscode at file i (*not* result).
# ripgrep output should be sorted with --show-lines in order to be predictable.
def rgof [i: int] {
    let res = $in | lines | each { |l| split row ':' | get 0 } | uniq | get $i
    code $res
}
