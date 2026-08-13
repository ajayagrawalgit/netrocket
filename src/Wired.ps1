function Optimize-Wired {
    param(
        [Parameter(Mandatory)]
        $Adapter
    )

    Write-Host "Optimizing wired Ethernet..." -ForegroundColor Cyan
    Write-Host ""

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Energy Efficient Ethernet$",
            "^Energy-Efficient Ethernet$",
            "^EEE$",
            "Energy Efficient"
        ) `
        -Values @(
            "Disabled"
        )

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Interrupt Moderation$"
        ) `
        -Values @(
            "Disabled"
        )

    Set-AdapterProperty `
        -AdapterName $Adapter.Name `
        -PropertyNames @(
            "^Flow Control$"
        ) `
        -Values @(
            "Disabled",
            "Off"
        )
}
