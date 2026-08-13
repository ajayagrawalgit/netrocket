#requires -RunAsAdministrator

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("WiFi", "Wired")]
    [string]$Type
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\src\Adapter.ps1"
. "$PSScriptRoot\src\WiFi.ps1"
. "$PSScriptRoot\src\Wired.ps1"

$adapter = Get-NetworkAdapter -Type $Type

if (-not $adapter) {
    Write-Host "No $Type adapter found." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "NetRocket" -ForegroundColor Cyan
Write-Host "Adapter: $($adapter.Name)"
Write-Host "Device : $($adapter.InterfaceDescription)"
Write-Host "Speed  : $($adapter.LinkSpeed)"
Write-Host ""

if ($Type -eq "WiFi") {
    Optimize-WiFi -Adapter $adapter
}
else {
    Optimize-Wired -Adapter $adapter
}

Write-Host ""
Write-Host "Restarting adapter..." -ForegroundColor Yellow
Restart-NetAdapter -Name $adapter.Name -Confirm:$false

Write-Host ""
Write-Host "Done. Run a speed test and compare the result." -ForegroundColor Green
