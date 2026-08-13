# Troubleshooting

## No adapter found

```powershell
Get-NetAdapter -Physical |
    Format-Table Name,InterfaceDescription,Status,LinkSpeed -AutoSize
```

More detail:

```powershell
Get-NetAdapter -Physical |
    Format-List Name,InterfaceDescription,PhysicalMediaType,NdisPhysicalMedium,Status
```

## Setting is not exposed

That is normal. Drivers expose different advanced properties.

Inspect them:

```powershell
Get-NetAdapterAdvancedProperty -Name "Wi-Fi" |
    Format-Table DisplayName,DisplayValue,RegistryKeyword,RegistryValue -AutoSize
```

Replace `Wi-Fi` with `Ethernet` as needed.

## Capture a before-state

```powershell
Get-NetAdapterAdvancedProperty -Name "Wi-Fi" |
    Export-Csv .\wifi-before.csv -NoTypeInformation
```

## Connection problems

Restart the adapter:

```powershell
Restart-NetAdapter -Name "Wi-Fi" -Confirm:$false
```

If needed, restore the previous advanced-property values using Device Manager or `Set-NetAdapterAdvancedProperty`.

## Reporting a compatibility issue

Include:

- Windows version
- Adapter model
- Driver version
- `Get-NetAdapter` output
- `Get-NetAdapterAdvancedProperty` output
- The property NetRocket failed to change
- Current property value
