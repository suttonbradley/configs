# Self-documenting help for these zsh configs
# Lists every top-level alias/function with the first line of the comment block above it
# (uncommented aliases and one-line functions show their body). Names starting with _ are hidden.

# List aliases/functions from these configs (optional file filter, e.g. `zhelp worktree`)
zhelp() {
  local files=(~/code/configs/zsh/zshrc ~/code/configs/zsh/*.zsh)
  [[ -n "$1" ]] && files=(${(M)files:#*$1*})
  (( ${#files} )) || { echo "no config file matches \"$1\""; return 1 }

  local c1= c2= c0=
  [[ -t 1 ]] && { c1=$'\e[1;34m'; c2=$'\e[32m'; c0=$'\e[0m' }

  awk -v q="'" -v c1="$c1" -v c2="$c2" -v c0="$c0" '
    function show(name, d) {
      if (name ~ /^_/) return
      if (!hdr) { printf "%s%s%s%s\n", (printed ? "\n" : ""), c1, label, c0; hdr = printed = 1 }
      printf "  %s%-16s%s %s\n", c2, name, c0, d
    }
    FNR == 1 { label = FILENAME; sub(/.*\//, "", label); sub(/\.zsh$/, "", label); hdr = 0; desc = ""; in_comment = 0 }
    /^# -+/ { desc = ""; in_comment = 0; next }
    /^#/ { if (!in_comment) { desc = $0; sub(/^# */, "", desc) } in_comment = 1; next }
    /^alias [^=]+=/ {
      name = $0; sub(/^alias /, "", name); sub(/=.*/, "", name)
      val = $0; sub(/^alias [^=]*=/, "", val); gsub("^" q "|" q "$", "", val)
      show(name, desc != "" ? desc : "→ " val)
    }
    /^[A-Za-z][A-Za-z0-9_-]* *\(\)/ {
      name = $0; sub(/ *\(.*/, "", name)
      # Uncommented one-liners show their body, like aliases
      if (desc == "" && $0 ~ /\{.*\} *$/) { val = $0; sub(/^[^{]*\{ */, "", val); sub(/ *\} *$/, "", val); desc = "→ " val }
      show(name, desc)
    }
    { desc = ""; in_comment = 0 }
  ' "${files[@]}"
}
