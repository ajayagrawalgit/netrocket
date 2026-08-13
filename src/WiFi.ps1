function Optimize-WiFi {
    param(
        [Parameter(Mandatory)]
        $Adapter
    )

    Write-Host "Optimizing Wi-Fi..." -ForegroundColor Cyan
    Write-Host ""

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Transmit Power$",
            "^Tx Power$"
        ) `
        -Values @(
            "Highest",
            "5. Highest",
            "4. Highest"
        )

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Roaming Aggressiveness$",
            "^Roaming Sensitivity$"
        ) `
        -Values @(
            "Medium",
            "3. Medium"
        )

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Preferred Band$",
            "Preferred Band"
        ) `
        -Values @(
            "Prefer 5GHz band",
            "Prefer 5 GHz band",
            "5GHz",
            "5 GHz"
        )

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "Channel Width.*5",
            "^Channel Width for 5GHz$"
        ) `
        -Values @(
            "Auto"
        )
}
