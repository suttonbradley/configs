# Source an environment from a batch file
def --env sourcebat [
  ...cmd: string # The batch command to run
] {
  let tmp = mktemp -t

  let cmd = ($cmd | append ["&&" "set" $">($tmp)"])
  let stdout = run-external cmd.exe /c ...$cmd | each { |line| print -n $line; $line } | str join

  let vars = open $tmp
  rm $tmp # Clean up the temp file.

  # Source: https://stackoverflow.com/questions/77383686/set-environment-variables-from-file-of-key-value-pairs-in-nu
  # Convert the output of `set` into a record.
  def "from env" []: string -> record {
    lines
      | split column '#'
      | get column1
      | filter {($in | str length) > 0} 
      | parse "{key}={value}"
      | update value {str trim -c '"'}
      | transpose -r -d
  }

  let vars = $vars | from env | transpose | filter { |in| $in.column0 != 'PWD' and $in.column0 != 'CURRENT_FILE' and $in.column0 != 'FILE_PWD' } | transpose -r -d;
  load-env $vars
}
