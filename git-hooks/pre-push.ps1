# ----- CARGO FMT -----
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host -NoNewline "Git hook: cargo fmt check | "

# Use git root, take dirs with Cargo.toml from this repo only, not submodules
$git_root = git rev-parse --show-toplevel
$cargo_toml_dirs = git ls-files '**/Cargo.toml' 'Cargo.toml' | ForEach-Object { Join-Path $git_root (Split-Path -Parent $_) }

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

# Filter out parent directories to avoid multiple cargo fmt runs
$cargo_toml_dirs = $cargo_toml_dirs | Where-Object {
    $dir = $_
    -not ($cargo_toml_dirs | Where-Object { $_ -ne $dir -and $_ -like "$dir\*" })
}

Write-Host -NoNewline "formatting $($cargo_toml_dirs.Count) dirs | "

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

Write-Host "took $($stopwatch.Elapsed.TotalSeconds.ToString('F2')) seconds"
$stopwatch.Stop()
