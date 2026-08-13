function Optimize-WiFiAdapter {
    param([Parameter(Mandatory)]$Adapter)

    Write-Header "Optimizing Wi-Fi"
    Show-AdapterSummary $Adapter

    $properties = Get-AdvancedPropertiesSafe $Adapter.Name

    Set-PropertiesByPattern $Adapter $properties "Transmit Power" @(
        "^Transmit Power$","^Tx Power$","Transmit Power"
    ) @("Highest","5. Highest","4. Highest")

    Set-PropertiesByPattern $Adapter $properties "Roaming Aggressiveness" @(
        "^Roaming Aggressiveness$","^Roaming Sensitivity$","Roaming Aggressiveness"
    ) @("Medium","3. Medium")

    Set-PropertiesByPattern $Adapter $properties "Preferred Band" @(
        "^Preferred Band$","Preferred Band","Preferred Frequency"
    ) @(
        "Prefer 6GHz band","Prefer 6 GHz band","6GHz","6 GHz",
        "Prefer 5GHz band","Prefer 5 GHz band","5GHz","5 GHz"
    )

    Set-PropertiesByPattern $Adapter $properties "5 GHz Channel Width" @(
        "^Channel Width for 5GHz$","Channel Width.*5\s*GHz","Channel Width.*5"
    ) @("Auto")

    Set-PropertiesByPattern $Adapter $properties "Wireless Mode" @(
        "^802\.11.*Wireless Mode","^Wireless Mode$","^WiFi Mode$"
    ) @("802.11ax","802.11ax/ac/n","802.11a/b/g/n/ac/ax","Auto")

    Set-AdapterPowerManagement $Adapter
}
