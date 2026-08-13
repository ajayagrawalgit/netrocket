# Contributing to NetRocket

Driver compatibility is the biggest challenge and the biggest opportunity for contribution.

## Before opening a PR

1. Test on the actual adapter.
2. Record Windows version.
3. Record adapter model.
4. Record driver version.
5. Record the exact property name.
6. Record current and desired values.
7. Add tests for logic changes.
8. Update docs when behavior changes.

## Useful commands

```powershell
Get-NetAdapter -Physical |
    Format-Table Name,InterfaceDescription,Status,LinkSpeed -AutoSize
```

```powershell
Get-NetAdapterAdvancedProperty -Name "Wi-Fi" |
    Format-Table DisplayName,DisplayValue,RegistryKeyword,RegistryValue -AutoSize
```

```powershell
Get-NetAdapterPowerManagement -Name "Wi-Fi"
```

Avoid direct registry writes when a supported NetAdapter cmdlet can perform the operation.

## Tests

```powershell
Install-Module Pester -Scope CurrentUser
Invoke-Pester .\tests
```

Tests must not modify a real network adapter.

## PR checklist

- [ ] Tested on Windows 10/11
- [ ] Adapter and driver documented
- [ ] Unsupported settings fail safely
- [ ] No unnecessary registry writes
- [ ] Tests pass
- [ ] Documentation updated
