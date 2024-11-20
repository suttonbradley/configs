# ----- CARGO FMT -----
$cargo_toml_dirs = Get-ChildItem -Path . -Recurse -Filter "Cargo.toml" -File | ForEach-Object { Split-Path -Parent $_ }
if ($cargo_toml_dirs.Count -gt 0) {
    Write-Host "Git hook: running cargo fmt"
}

# Filter out parent directories to avoid multiple cargo fmt runs
$filtered = @()
foreach ($dir in $cargo_toml_dirs) {
    # Ensure there's no child directory before adding to filtered list
    if (-not ($cargo_toml_dirs | Where-Object { $_ -ne $dir -and $_ -like "$dir\*" })) {
        $filtered += $dir
    }
}

# Cargo fmt check each and look for errors
$no_errors = $true
$filtered | ForEach-Object {
    Push-Location $_
    cargo fmt --check
    $no_errors = $no_errors -and $?
    Pop-Location
}
if (-not $no_errors) {
    Write-Host "Git hook: not committing due to failed cargo fmt"
    exit 1
}
