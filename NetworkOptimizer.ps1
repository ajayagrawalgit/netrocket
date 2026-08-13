#requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet("WiFi", "Wired", IgnoreCase = $true)]
    [string]$Type,
    [switch]$NoRestart
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$src = Join-Path $PSScriptRoot "src"

. (Join-Path $src "Output.ps1")
. (Join-Path $src "AdapterDiscovery.ps1")
. (Join-Path $src "AdapterProperties.ps1")
. (Join-Path $src "PowerManagement.ps1")
. (Join-Path $src "WiredOptimizer.ps1")
. (Join-Path $src "WiFiOptimizer.ps1")
. (Join-Path $src "Runner.ps1")

exit (Invoke-NetRocket -ConnectionType $Type -SkipRestart:$NoRestart)
