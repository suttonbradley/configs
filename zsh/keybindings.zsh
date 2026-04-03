# Key bindings for Windows Terminal escape sequences
# Modifier encoding: 2=Shift, 5=Ctrl, 6=Ctrl+Shift

if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop || -n "$WSL_DISTRO_NAME" ]]; then
  # Home / End
  bindkey '^[[H'    beginning-of-line       # Home
  bindkey '^[[F'    end-of-line             # End

  # Word navigation
  bindkey '^[[1;5D' backward-word           # Ctrl+Left
  bindkey '^[[1;5C' forward-word            # Ctrl+Right

  # Delete / Backspace word
  bindkey '^[[3;5~' kill-word               # Ctrl+Delete
  bindkey '^H'      backward-kill-word      # Ctrl+Backspace

  # Shift selection — create ZLE widgets that activate the region then move
  for key widget seq in \
      left    backward-char      '^[[1;2D' \
      right   forward-char       '^[[1;2C' \
      home    beginning-of-line  '^[[1;2H' \
      end     end-of-line        '^[[1;2F' \
      cleft   backward-word      '^[[1;6D' \
      cright  forward-word       '^[[1;6C'
  do
    eval "shift-select-$key() {
      ((\$REGION_ACTIVE)) || zle set-mark-command
      zle $widget
    }"
    zle -N "shift-select-$key"
    bindkey "$seq" "shift-select-$key"
  done

  # Delete/Backspace: kill region if active, otherwise normal behavior
  delete-char-or-region() {
    if (($REGION_ACTIVE)); then
      zle kill-region
    else
      zle delete-char
    fi
  }
  zle -N delete-char-or-region
  bindkey '^[[3~' delete-char-or-region     # Delete

  backward-delete-or-region() {
    if (($REGION_ACTIVE)); then
      zle kill-region
    else
      zle backward-delete-char
    fi
  }
  zle -N backward-delete-or-region
  bindkey '^?' backward-delete-or-region    # Backspace
fi
