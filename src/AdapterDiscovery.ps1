function Get-TargetAdapters {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("WiFi","Wired")]
        [string]$ConnectionType
    )

    $adapters = @(Get-NetAdapter -Physical -ErrorAction Stop)

    if ($ConnectionType -eq "Wired") {
        return @($adapters | Where-Object {
            $_.Status -ne "Disabled" -and (
                $_.PhysicalMediaType -eq "802.3" -or
                $_.NdisPhysicalMedium -eq 14 -or
                $_.InterfaceDescription -match "(?i)ethernet|gigabit|2\.5g|5g|10g|realtek.*pci|intel.*ethernet|broadcom.*ethernet"
            )
        })
    }

    return @($adapters | Where-Object {
        $_.Status -ne "Disabled" -and (
            $_.PhysicalMediaType -eq "Native 802.11" -or
            $_.NdisPhysicalMedium -eq 9 -or
            $_.Name -match "(?i)wi-?fi|wireless|wlan" -or
            $_.InterfaceDescription -match "(?i)wireless|wi-?fi|wifi|802\.11|wlan"
        )
    })
}

function Show-AvailableAdapters {
    Write-Host ""
    Write-Host "Available adapters:" -ForegroundColor Gray
    Get-NetAdapter |
        Select-Object Name,InterfaceDescription,Status,LinkSpeed |
        Format-Table -AutoSize
}
