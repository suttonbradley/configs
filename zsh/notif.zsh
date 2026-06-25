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
    # NOTE: Must install burnt toast within powershell for this to work
    "$pwsh" -NoProfile -Command "Import-Module BurntToast; New-BurntToastNotification -Text '$title', '$message'" >/dev/null 2>&1
  else
    # TODO: notification system for linux/macos
    echo "(notif: no notification backend for this platform)"
  fi

  return $exit_code
}

# Prefix any command with `push-notif` to get a push notification on the Pushover app
# Requires: PUSHOVER_TOKEN (application API token), PUSHOVER_USER (user key)
push-notif() {
  if [[ -z "$*" ]]; then
    echo "Usage: push-notif <command>"
    return 1
  fi

  if [[ -z "$PUSHOVER_TOKEN" || -z "$PUSHOVER_USER" ]]; then
    echo "push-notif: PUSHOVER_TOKEN and PUSHOVER_USER must be set"
    return 1
  fi

  eval "$@"
  local exit_code=$?

  curl -s \
    --form-string "token=$PUSHOVER_TOKEN" \
    --form-string "user=$PUSHOVER_USER" \
    --form-string "message=$(if [[ $exit_code -eq 0 ]]; then echo "Success: $*"; else echo "Failed (code $exit_code): $*"; fi)" \
    https://api.pushover.net/1/messages.json >/dev/null

  return $exit_code
}
