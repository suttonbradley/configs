# Prefix any command with `notif` to get a toast notification on completion

notif() {
  if [[ -z "$*" ]]; then
    echo "Usage: notif <command>"
    return 1
  fi

  eval "$@"
  local exit_code=$?

  # Check for WSL signals to call into pwsh on Windows side
  if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop || -n "$WSL_DISTRO_NAME" ]]; then
    local pwsh="/mnt/c/Program Files/PowerShell/7/pwsh.exe"
    local title="Complete: $*"
    local message="Exit code: $exit_code"
    # Escape single quotes for PowerShell
    title="${title//\'/\'\'}"
    message="${message//\'/\'\'}"
    "$pwsh" -NoProfile -Command "Import-Module BurntToast; New-BurntToastNotification -Text '$title', '$message'" >/dev/null 2>&1
  else
    # TODO: notification system for linux/macos
    echo "(notif: no notification backend for this platform)"
  fi

  return $exit_code
}
