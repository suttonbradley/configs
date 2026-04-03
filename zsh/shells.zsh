# Nushell-style directory shell switching
# Ported from pwsh/utils.ps1, originally from nushell's `shells` builtin

# State: array of dirs + current index
_SHELLS=("$PWD")
_SHELLS_IDX=1

# Enter a directory as a new shell (or switch to it if already tracked)
e() {
  local dir
  if [[ -d "$1" ]]; then
    dir="$(cd "$1" && pwd)"
  else
    # Try zoxide
    dir="$(zoxide query "$1" 2>/dev/null)"
    if [[ -z "$dir" ]]; then
      echo "no match for \"$1\""
      return 1
    fi
  fi

  # If already in list, switch to it
  local i
  for i in {1..${#_SHELLS[@]}}; do
    if [[ "${_SHELLS[$i]}" == "$dir" ]]; then
      echo "Already in shells. Switching..."
      _SHELLS[$_SHELLS_IDX]="$PWD"
      _SHELLS_IDX=$i
      cd "$dir"
      return
    fi
  done

  # Append new shell
  _SHELLS[$_SHELLS_IDX]="$PWD"
  _SHELLS+=("$dir")
  _SHELLS_IDX=${#_SHELLS[@]}
  cd "$dir"
}

# Exit current shell
dexit() {
  if (( ${#_SHELLS[@]} <= 1 )); then
    echo "Can't exit last shell"
    return 1
  fi

  # Remove current entry
  _SHELLS[$_SHELLS_IDX]=()
  _SHELLS=("${_SHELLS[@]}")

  # Clamp index
  if (( _SHELLS_IDX > ${#_SHELLS[@]} )); then
    _SHELLS_IDX=${#_SHELLS[@]}
  fi
  (( _SHELLS_IDX < 1 )) && _SHELLS_IDX=1

  cd "${_SHELLS[$_SHELLS_IDX]}"
}

# Next shell
n() {
  _SHELLS[$_SHELLS_IDX]="$PWD"
  _SHELLS_IDX=$(( (_SHELLS_IDX % ${#_SHELLS[@]}) + 1 ))
  cd "${_SHELLS[$_SHELLS_IDX]}"
}

# Previous shell
p() {
  _SHELLS[$_SHELLS_IDX]="$PWD"
  _SHELLS_IDX=$(( ((_SHELLS_IDX - 2 + ${#_SHELLS[@]}) % ${#_SHELLS[@]}) + 1 ))
  cd "${_SHELLS[$_SHELLS_IDX]}"
}

# Go to shell by index (displayed as 0-based, stored as 1-based)
g() {
  local idx=$(( $1 + 1 ))
  if (( idx >= 1 && idx <= ${#_SHELLS[@]} )); then
    _SHELLS[$_SHELLS_IDX]="$PWD"
    _SHELLS_IDX=$idx
    cd "${_SHELLS[$_SHELLS_IDX]}"
  else
    echo "Shell index out of range"
  fi
}

# List all shells (update current entry with pwd first)
shells() {
  _SHELLS[$_SHELLS_IDX]="$PWD"
  echo "Shell locations (\e[34mactive in blue\e[0m):"
  local i
  for i in {1..${#_SHELLS[@]}}; do
    local display_idx=$(( i - 1 ))
    if (( i == _SHELLS_IDX )); then
      echo "\e[34m${display_idx}: \e[0m\e[32m${_SHELLS[$i]}\e[0m"
    else
      echo "${display_idx}: \e[32m${_SHELLS[$i]}\e[0m"
    fi
  done
}
