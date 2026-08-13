function Optimize-WiredAdapter {
    param([Parameter(Mandatory)]$Adapter)

    Write-Header "Optimizing wired Ethernet"
    Show-AdapterSummary $Adapter

    $properties = Get-AdvancedPropertiesSafe $Adapter.Name

    Set-PropertiesByPattern $Adapter $properties "Energy Efficient Ethernet" @(
        "^Energy Efficient Ethernet$","^Energy-Efficient Ethernet$","^EEE$","^Advanced EEE$","Energy Efficient"
    ) @("Disabled")

    Set-PropertiesByPattern $Adapter $properties "Interrupt Moderation" @(
        "^Interrupt Moderation$"
    ) @("Disabled")

    Set-PropertiesByPattern $Adapter $properties "Flow Control" @(
        "^Flow Control$","Flow Control"
    ) @("Disabled","Off")

    Set-AdapterPowerManagement $Adapter
}
