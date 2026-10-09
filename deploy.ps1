# Copies the built plugin into a vault so it can be tested in Obsidian.
# Usage:  ./deploy.ps1                          deploy to ./dev_vault
#         ./deploy.ps1 -Vault "C:\Path\To\Vault"
#         npm run deploy -- -Vault "C:\Path\To\Vault"   (build first)
param(
	[string]$Vault = (Join-Path $PSScriptRoot "dev_vault")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path (Join-Path $Vault ".obsidian"))) {
	throw "Not an Obsidian vault (no .obsidian folder): $Vault"
}

$root = $PSScriptRoot
$dest = Join-Path $Vault ".obsidian\plugins\metal-image-viewer"

New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($file in @("main.js", "manifest.json", "styles.css")) {
	$src = Join-Path $root $file
	if (Test-Path $src) {
		Copy-Item $src -Destination $dest -Force
		Write-Host "copied $file -> $dest"
	} else {
		Write-Warning "missing $file (run the build first)"
	}
}

Write-Host "Done. Reload Obsidian (or toggle the plugin) to pick up changes."
