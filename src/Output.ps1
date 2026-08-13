function Write-Header {
    param([Parameter(Mandatory)][string]$Message)

    Write-Host ""
    Write-Host ("=" * 64) -ForegroundColor Cyan
    Write-Host " $Message" -ForegroundColor Cyan
    Write-Host ("=" * 64) -ForegroundColor Cyan
    Write-Host ""
}

function Write-Status {
    param(
        [Parameter(Mandatory)][string]$Label,
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet("Info","Success","Warning","Error")]
        [string]$Level = "Info"
    )

    $prefix = @{Info="[i]";Success="[+]";Warning="[!]";Error="[x]"}[$Level]
    $color  = @{Info="Gray";Success="Green";Warning="Yellow";Error="Red"}[$Level]

    Write-Host "  $prefix $Label" -ForegroundColor $color -NoNewline
    Write-Host ": $Message"
}

function Show-AdapterSummary {
    param([Parameter(Mandatory)]$Adapter)

    Write-Host "Adapter       : $($Adapter.Name)"
    Write-Host "Description   : $($Adapter.InterfaceDescription)"
    Write-Host "Status        : $($Adapter.Status)"
    Write-Host "Link speed    : $($Adapter.LinkSpeed)"
    Write-Host ""
}
