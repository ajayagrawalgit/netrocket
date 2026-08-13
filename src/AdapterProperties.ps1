function Get-AdvancedPropertiesSafe {
    param([Parameter(Mandatory)][string]$AdapterName)

    try {
        return @(Get-NetAdapterAdvancedProperty -Name $AdapterName -ErrorAction Stop)
    }
    catch {
        Write-Status "Advanced properties" $_.Exception.Message "Warning"
        return @()
    }
}

function Find-AdvancedProperties {
    param(
        [Parameter(Mandatory)][object[]]$Properties,
        [Parameter(Mandatory)][string[]]$Patterns
    )

    $matches = foreach ($pattern in $Patterns) {
        $Properties | Where-Object { $_.DisplayName -match $pattern }
    }

    return @($matches | Sort-Object DisplayName -Unique)
}

function Set-AdapterProperty {
    param(
        [Parameter(Mandatory)]$Adapter,
        [Parameter(Mandatory)]$Property,
        [Parameter(Mandatory)][string[]]$CandidateValues,
        [Parameter(Mandatory)][string]$SettingName
    )

    Write-Host ""
    Write-Status $SettingName "Current value: $($Property.DisplayValue)"

    foreach ($value in $CandidateValues) {
        if ($PSCmdlet.ShouldProcess("$($Adapter.Name) / $($Property.DisplayName)","Set to '$value'")) {
            try {
                Set-NetAdapterAdvancedProperty `
                    -Name $Adapter.Name `
                    -DisplayName $Property.DisplayName `
                    -DisplayValue $value `
                    -NoRestart `
                    -ErrorAction Stop

                Write-Status $SettingName "Set to '$value'" "Success"
                return $true
            }
            catch {}
        }
    }

    Write-Status $SettingName "No compatible value accepted by this driver" "Warning"
    return $false
}

function Set-PropertiesByPattern {
    param(
        [Parameter(Mandatory)]$Adapter,
        [Parameter(Mandatory)][object[]]$Properties,
        [Parameter(Mandatory)][string]$SettingName,
        [Parameter(Mandatory)][string[]]$Patterns,
        [Parameter(Mandatory)][string[]]$Values
    )

    $matches = Find-AdvancedProperties -Properties $Properties -Patterns $Patterns

    if (-not $matches) {
        Write-Status $SettingName "Not exposed by this driver" "Warning"
        return
    }

    foreach ($property in $matches) {
        [void](Set-AdapterProperty -Adapter $Adapter -Property $property -CandidateValues $Values -SettingName $SettingName)
    }
}
