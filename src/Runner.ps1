function Restart-TargetAdapters {
    param([Parameter(Mandatory)][object[]]$Adapters)

    Write-Header "Applying changes"

    foreach ($adapter in $Adapters) {
        if ($PSCmdlet.ShouldProcess($adapter.Name,"Restart network adapter")) {
            try {
                Restart-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
                Start-Sleep -Seconds 3
                Write-Status $adapter.Name "Restarted successfully" "Success"
            }
            catch {
                Write-Status $adapter.Name $_.Exception.Message "Warning"
            }
        }
    }
}

function Show-FinalState {
    param(
        [Parameter(Mandatory)][object[]]$Adapters,
        [Parameter(Mandatory)][ValidateSet("WiFi","Wired")][string]$ConnectionType
    )

    Write-Header "Final adapter state"

    foreach ($adapter in $Adapters) {
        $current = Get-NetAdapter -Name $adapter.Name -ErrorAction SilentlyContinue

        if (-not $current) {
            Write-Status $adapter.Name "Adapter could not be read after changes" "Warning"
            continue
        }

        Write-Host $current.Name -ForegroundColor White
        Write-Host "  Status     : $($current.Status)"
        Write-Host "  Link Speed : $($current.LinkSpeed)"
        Write-Host ""

        $properties = Get-AdvancedPropertiesSafe $adapter.Name
        $pattern = if ($ConnectionType -eq "Wired") {
            "Energy|EEE|Interrupt|Flow Control"
        } else {
            "Transmit|Roaming|Preferred Band|Preferred Frequency|Channel Width|Wireless Mode|802\.11"
        }

        $properties |
            Where-Object { $_.DisplayName -match $pattern } |
            Select-Object DisplayName,DisplayValue |
            Format-Table -AutoSize
    }
}

function Invoke-NetRocket {
    param(
        [Parameter(Mandatory)]
        [ValidateSet("WiFi","Wired")]
        [string]$ConnectionType,
        [switch]$SkipRestart
    )

    Write-Header "NetRocket"
    Write-Host "Mode: $($ConnectionType.ToUpperInvariant())"
    Write-Host ""

    $adapters = @(Get-TargetAdapters $ConnectionType)

    if (-not $adapters) {
        Write-Status "Adapter discovery" "No active $ConnectionType adapter found" "Error"
        Show-AvailableAdapters
        return 1
    }

    Write-Host "Detected adapter(s):" -ForegroundColor Green
    foreach ($adapter in $adapters { Show-AdapterSummary $adapter })

    foreach ($adapter in $adapters) {
        if ($ConnectionType -eq "Wired") {
            Optimize-WiredAdapter $adapter
        } else {
            Optimize-WiFiAdapter $adapter
        }
    }

    if (-not $SkipRestart -and -not $WhatIfPreference) {
        $answer = Read-Host "Restart adapter(s) now? [Y/N]"
        if ($answer -match "^[Yy]$") {
            Restart-TargetAdapters $adapters
        }
    } elseif ($WhatIfPreference) {
        Write-Status "Adapter restart" "Skipped because -WhatIf was supplied"
    } else {
        Write-Status "Adapter restart" "Skipped because -NoRestart was supplied"
    }

    Show-FinalState $adapters $ConnectionType

    Write-Header "Done"
    Write-Host "Run a speed test and compare the before/after result."
    Write-Host ""

    return 0
}
