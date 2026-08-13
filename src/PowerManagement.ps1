function Set-AdapterPowerManagement {
    param([Parameter(Mandatory)]$Adapter)

    Write-Host ""
    Write-Status "Adapter power management" "Reading current setting"

    try {
        $power = Get-NetAdapterPowerManagement -Name $Adapter.Name -ErrorAction Stop
        Write-Host "      Current: $($power.AllowComputerToTurnOffDevice)"

        if ($PSCmdlet.ShouldProcess($Adapter.Name,"Disable Windows power-down of adapter")) {
            Set-NetAdapterPowerManagement `
                -Name $Adapter.Name `
                -AllowComputerToTurnOffDevice Disabled `
                -ErrorAction Stop

            Write-Status "Adapter power management" "Windows power-down disabled" "Success"
        }
    }
    catch {
        Write-Status "Adapter power management" $_.Exception.Message "Warning"
    }
}
