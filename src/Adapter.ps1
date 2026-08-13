function Get-NetworkAdapter {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("WiFi", "Wired")]
        [string]$Type
    )

    $adapters = Get-NetAdapter -Physical |
        Where-Object { $_.Status -ne "Disabled" }

    if ($Type -eq "WiFi") {
        return $adapters |
            Where-Object {
                $_.Name -match "Wi-?Fi|Wireless|WLAN" -or
                $_.InterfaceDescription -match "Wi-?Fi|Wireless|802\.11|WLAN"
            } |
            Select-Object -First 1
    }

    return $adapters |
        Where-Object {
            $_.PhysicalMediaType -eq "802.3" -or
            $_.InterfaceDescription -match "Ethernet|Gigabit|2\.5G|5G|10G"
        } |
        Select-Object -First 1
}

function Get-AdapterProperties {
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    Get-NetAdapterAdvancedProperty -Name $Name
}

function Set-AdapterProperty {
    param(
        [Parameter(Mandatory)]
        [string]$AdapterName,

        [Parameter(Mandatory)]
        [string[]]$PropertyNames,

        [Parameter(Mandatory)]
        [string[]]$Values
    )

    $properties = Get-AdapterProperties -Name $AdapterName

    foreach ($name in $PropertyNames) {
        $property = $properties |
            Where-Object { $_.DisplayName -match $name } |
            Select-Object -First 1

        if (-not $property) {
            continue
        }

        Write-Host "  $($property.DisplayName): $($property.DisplayValue)" -ForegroundColor Gray

        foreach ($value in $Values) {
            try {
                Set-NetAdapterAdvancedProperty `
                    -Name $AdapterName `
                    -DisplayName $property.DisplayName `
                    -DisplayValue $value `
                    -NoRestart `
                    -ErrorAction Stop

                Write-Host "    -> $value" -ForegroundColor Green
                break
            }
            catch {
                # Try the next driver-specific value.
            }
        }
    }
}
