# ----- CARGO FMT -----

# Use git root, take dirs with Cargo.toml from this repo only, not submodules
$git_root = git rev-parse --show-toplevel
$submodules = git config --file (Join-Path $git_root .gitmodules) --get-regexp path | ForEach-Object { Join-Path $git_root ($_ -split ' ')[1] }
$cargo_toml_dirs = Get-ChildItem -Path $git_root -Recurse -Filter "Cargo.toml" -File | Where-Object { 
    $file = $_
    $file.FullName -notmatch '\.git\\' -and -not ($submodules | Where-Object { $file.FullName -like "$_\*" })
} | ForEach-Object { Split-Path -Parent $_ }

# Filter out dirs that haven't changed since last push
$upstream = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
if ($upstream) {
    $changed_files = git diff --name-only "$upstream..HEAD"
} else {
    $merge_base = git merge-base HEAD origin/HEAD 2>$null
    if ($merge_base) {
        $changed_files = git diff --name-only "$merge_base..HEAD"
    }
}
if ($changed_files) {
    $git_root_abs = (Resolve-Path $git_root).Path
    $cargo_toml_dirs = $cargo_toml_dirs | Where-Object {
        $dir = $_
        $rel_dir = $dir.Replace($git_root_abs, '').TrimStart('\').Replace('\', '/')
        $changed_files | Where-Object { $_ -like "$rel_dir/*" }
    }
}

# Guaranteed to have something to format now
if ($cargo_toml_dirs.Count -gt 0) {
    Write-Host "Git hook: running cargo fmt"
}

# Filter out parent directories to avoid multiple cargo fmt runs
$cargo_toml_dirs = $cargo_toml_dirs | Where-Object {
    $dir = $_
    -not ($cargo_toml_dirs | Where-Object { $_ -ne $dir -and $_ -like "$dir\*" })
}

# Cargo fmt check each and look for errors
$no_errors = $true
$cargo_toml_dirs | ForEach-Object {
    Push-Location $_
    cargo fmt --check
    $no_errors = $no_errors -and $?
    Pop-Location
}
if (-not $no_errors) {
    Write-Host "Git hook: not committing due to failed cargo fmt"
    exit 1
}
