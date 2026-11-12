#Requires -Version 7.0

[CmdletBinding()]
param(
    [string]$OutputFolder = $PSScriptRoot,
    [switch]$IncludeUnassigned,
    [switch]$IncludeStale,
    [int]$StaleDays = 90
)

$ErrorActionPreference = 'Stop'
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

try {
    foreach ($module in @('Microsoft.Graph.Authentication','Microsoft.Graph.DeviceManagement')) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-Host "Installing missing module: $module" -ForegroundColor Yellow
            Install-Module -Name $module -Scope CurrentUser -Repository PSGallery -Force -AllowClobber
        }
        Import-Module $module -ErrorAction Stop
    }

    $requiredScopes = @('DeviceManagementManagedDevices.Read.All','User.Read.All')
    $context = Get-MgContext
    $missingScopes = @($requiredScopes | Where-Object { -not $context -or $_ -notin $context.Scopes })
    if ($missingScopes.Count -gt 0) {
        Connect-MgGraph -Scopes $requiredScopes -NoWelcome
        $context = Get-MgContext
    }
    if (-not $context -or -not $context.TenantId) { throw 'No valid Microsoft Graph connection.' }
    Write-Host "Connected to tenant: $($context.TenantId)" -ForegroundColor Cyan

    Write-Host 'Retrieving Intune managed devices...' -ForegroundColor Cyan
    $devices = @(Get-MgDeviceManagementManagedDevice -All -Property @(
        'id','deviceName','operatingSystem','manufacturer','model','serialNumber',
        'userId','userPrincipalName','userDisplayName','managedDeviceOwnerType',
        'lastSyncDateTime','enrolledDateTime','managementAgent','azureADDeviceId'
    ))

    $cutoff = (Get-Date).AddDays(-$StaleDays)
    $laptops = @($devices | Where-Object {
        $_.OperatingSystem -in @('Windows','macOS') -and
        ($IncludeUnassigned -or -not [string]::IsNullOrWhiteSpace($_.UserPrincipalName)) -and
        ($IncludeStale -or ($_.LastSyncDateTime -and $_.LastSyncDateTime.DateTime -ge $cutoff))
    })


    $report = foreach ($device in $laptops) {
        $ownerType = [string]$device.ManagedDeviceOwnerType
        $personalIndicator = switch -Regex ($ownerType) {
            '^personal$'  { 'Yes - Intune classified personal'; break }
            '^company$'   { 'No personal ownership indicated (not proof of no BYOD)'; break }
            '^corporate$' { 'No personal ownership indicated (not proof of no BYOD)'; break }
            default       { 'Unknown - verify with employee/IT' }
        }

        [PSCustomObject]@{
            'Employee Name'      = $device.UserDisplayName
            'Email Address'      = $device.UserPrincipalName
            'Equipment Type'     = 'Laptop (assumed; verify model)'
            'Manufacturer'       = $device.Manufacturer
            'Model'              = $device.Model
            'Serial Number'      = $device.SerialNumber
            'Device Name'        = $device.DeviceName
            'Operating System'   = $device.OperatingSystem
            'Last Check-in'      = if ($device.LastSyncDateTime) { $device.LastSyncDateTime.ToString('yyyy-MM-dd HH:mm:ss zzz') } else { '' }
            'Ownership'          = if ($ownerType) { $ownerType } else { 'Unknown' }
            'Personal Device Use' = $personalIndicator
            'Intune Device ID'   = $device.Id
            'Entra Device ID'    = $device.AzureADDeviceId
            'Enrolled Date'      = if ($device.EnrolledDateTime) { $device.EnrolledDateTime.ToString('yyyy-MM-dd') } else { '' }
        }
    }

    if (-not (Test-Path -LiteralPath $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $csvPath = Join-Path $OutputFolder "Employee_Laptop_Inventory_$timestamp.csv"
    $report = @($report | Sort-Object 'Employee Name','Device Name')
    if ($report.Count -gt 0) {
        $report | Export-Csv -Path $csvPath -NoTypeInformation -Encoding utf8BOM
    } else {
        # Create a header-only CSV when no devices match.
        $headers = @('Employee Name','Email Address','Equipment Type','Manufacturer','Model','Serial Number','Device Name','Operating System','Last Check-in','Ownership','Personal Device Use','Intune Device ID','Entra Device ID','Enrolled Date')
        Set-Content -LiteralPath $csvPath -Value ($headers -join ',') -Encoding utf8BOM
    }

    $report | Format-Table 'Employee Name','Device Name','Manufacturer','Model','Serial Number','Ownership' -AutoSize
    Write-Host "`nDevices returned by Intune: $($devices.Count)" -ForegroundColor Cyan
    Write-Host "Laptop candidates exported: $($report.Count)" -ForegroundColor Green
    Write-Host "CSV saved: $csvPath" -ForegroundColor Green
    Write-Warning 'Review device models and assignments. Shared devices, non-enrolled BYOD, and personal use cannot be conclusively identified from Intune alone.'
}
catch {
    Write-Error "Inventory export failed: $($_.Exception.Message)"
}
finally {
    $stopwatch.Stop()
    Write-Host "Elapsed time: $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))"
}
