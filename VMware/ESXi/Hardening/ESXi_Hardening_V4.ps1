#====================================================================================================================
#  AUTHOR: HumbledGeeks / Allen Johnson / Modified by ChatGPT for Allen Johnson
#  PURPOSE: Apply Recommended Advanced Settings to ESXi Hosts with Menu, Dry Run, Color Output, HTML Summary, and Emojis
#====================================================================================================================

Clear-Host
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "         ESXi Host Hardening Script" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "`nPlease choose a connection method:"
Write-Host "1. vCenter (cluster-based or all hosts)"
Write-Host "2. Standalone ESXi Hosts"
Write-Host "3. Use hosts.csv File"
$selection = Read-Host "Enter your choice (1-3)"

$dryRun = Read-Host "`n🧪 Dry Run only? (yes/no)"
$applyChanges = if ($dryRun -match "^(y|yes)$") { $false } else { $true }

if (-not $applyChanges) {
    Write-Host "`n🧪 Running in DRY-RUN mode: No changes will be applied." -ForegroundColor Magenta
}

# Recommended advanced settings
$recommendedSettings = @{
    "Config.HostAgent.log.level"              = "info"
    "Config.HostAgent.plugins.solo.enableMob" = "False"
    "Mem.ShareForceSalting"                   = "2"
    "Security.AccountLockFailures"            = "5"
    "Security.AccountUnlockTime"              = "900"
    "Security.PasswordHistory"                = "5"
    "Security.PasswordQulityControl"          = "similar=deny retry=3 min=disabled,disabled,disabled,disabled,15"
    "UserVars.DcuiTimeOut"                    = "600"
    "UserVars.ESXiShellInteractiveTimeOut"    = "900"
    "UserVars.ESXiShellTimeOut"               = "900"
    "UserVars.ESXiVPsDisabledProtocols"       = "sslv3,tlsv1,tlsv1.1"
    "UserVars.SuppressShellWarning"           = "1"
    "VMkernel.Boot.execInstalledOnly"         = "True"
    "Misc.BlueScreenTimeout"                  = "60"
}

# Paths and logs
$basePath = "C:\ESXi_Hardening"
New-Item -Path $basePath -ItemType Directory -Force | Out-Null
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$changeLogCsv = Join-Path $basePath "ESXi_AdvancedSettings_Changes_${timestamp}.csv"
$baselineCsv  = Join-Path $basePath "ESXi_AdvancedSettings_Baseline_${timestamp}.csv"
$textLogPath  = Join-Path $basePath "ESXi_AdvancedSettings_Log_${timestamp}.txt"

# Initialize output files
"Timestamp,HostName,Setting,OldValue,NewValue,Result" | Out-File -FilePath $changeLogCsv -Encoding UTF8
"Timestamp,HostName,Setting,CurrentValue"             | Out-File -FilePath $baselineCsv  -Encoding UTF8
"[{0}] Starting ESXi Hardening Run" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | Out-File -FilePath $textLogPath -Encoding UTF8

function Write-ChangedSetting {
    param ([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
    $Message | Out-File -FilePath $textLogPath -Append -Encoding UTF8
}
function Write-CompliantSetting {
    param ([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
    $Message | Out-File -FilePath $textLogPath -Append -Encoding UTF8
}
function Write-ErrorSetting {
    param ([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
    $Message | Out-File -FilePath $textLogPath -Append -Encoding UTF8
}

# Track connected VIServers for clean disconnect
$connectedVIServers = @()

# Prompt for credentials once
$cred = Get-Credential -Message "Enter ESXi root/admin credentials"

# Determine host list
$hosts = @()
switch ($selection) {
    "1" {
        $vCenter = Read-Host "Enter vCenter Server"
        $viserver = Connect-VIServer -Server $vCenter -Credential $cred
        $connectedVIServers += $viserver

        $clusterName = Read-Host "Enter cluster name (leave blank for all hosts)"
        if ($clusterName) {
            $hosts = Get-Cluster -Name $clusterName | Get-VMHost
        } else {
            Write-Host "⚠️  No cluster specified. Querying all hosts from vCenter..." -ForegroundColor Yellow
            $hosts = Get-VMHost
        }
    }
    "2" {
        $hostnames = Read-Host "Enter comma-separated list of standalone ESXi hosts"
        foreach ($esxiHostName in $hostnames -split ",") {
            try {
                $viserver = Connect-VIServer -Server $esxiHostName.Trim() -Credential $cred -ErrorAction Stop
                $connectedVIServers += $viserver
                $hosts += Get-VMHost -Server $viserver
                Write-Host "🔄 Connected to $esxiHostName" -ForegroundColor Green
            } catch {
                Write-ErrorSetting "Could not connect to ${esxiHostName}: $($_.Exception.Message)"
            }
        }
    }
    "3" {
        $csvPath = Join-Path $basePath "hosts.csv"
        if (-not (Test-Path $csvPath)) {
            Write-ErrorSetting "CSV file not found at: $csvPath"
            exit
        }
        $hostList = Import-Csv -Path $csvPath
        foreach ($entry in $hostList) {
            try {
                $viserver = Connect-VIServer -Server $entry.HostName -Credential $cred -ErrorAction Stop
                $connectedVIServers += $viserver
                $hosts += Get-VMHost -Server $viserver -Name $entry.HostName
                Write-Host "🔄 Connected to $($entry.HostName)" -ForegroundColor Green
            } catch {
                Write-ErrorSetting "Could not connect to $($entry.HostName): $($_.Exception.Message)"
            }
        }
    }
    default {
        Write-ErrorSetting "Invalid selection. Exiting..."
        exit
    }
}

# Apply or simulate settings
foreach ($vmhost in $hosts) {
    $hostName = $vmhost.Name
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "`n🔧 [$time] Processing $hostName..." -ForegroundColor Cyan

    foreach ($setting in $recommendedSettings.Keys) {
        $desiredValue = $recommendedSettings[$setting]
        $currentSetting = Get-AdvancedSetting -Entity $vmhost -Name $setting -ErrorAction SilentlyContinue

        if ($currentSetting) {
            $currentValue = $currentSetting.Value
            "$time,${hostName},${setting},${currentValue}" | Out-File -FilePath $baselineCsv -Append -Encoding UTF8

            if ($currentValue -ne $desiredValue) {
                if ($applyChanges) {
                    Set-AdvancedSetting -AdvancedSetting $currentSetting -Value $desiredValue -Confirm:$false -ErrorAction Stop | Out-Null
                    $log = "${hostName} - CHANGED: ${setting} from '${currentValue}' to '${desiredValue}'"
                    Write-ChangedSetting $log
                    "$time,${hostName},${setting},${currentValue},${desiredValue},Updated" | Out-File -FilePath $changeLogCsv -Append -Encoding UTF8
                } else {
                    $log = "${hostName} - 🧪 DRYRUN: Would change ${setting} from '${currentValue}' to '${desiredValue}'"
                    Write-Host $log -ForegroundColor Yellow
                    "$time,${hostName},${setting},${currentValue},${desiredValue},DryRun" | Out-File -FilePath $changeLogCsv -Append -Encoding UTF8
                }
            } else {
                $log = "${hostName} - COMPLIANT: ${setting} = '${currentValue}'"
                Write-CompliantSetting $log
                "$time,${hostName},${setting},${currentValue},${desiredValue},Already compliant" | Out-File -FilePath $changeLogCsv -Append -Encoding UTF8
            }
        }
    }
}

# Disconnect all connected VIServers
$connectedVIServers | ForEach-Object {
    Disconnect-VIServer -Server $_ -Confirm:$false
    Write-Host "🔌 Disconnected from $($_.Name)" -ForegroundColor DarkGray
}

# === HTML Summary Generation ===
Write-Host "`n📝 Generating HTML Summary Report..." -ForegroundColor Cyan
$htmlPath = Join-Path $basePath "settings_summary_${timestamp}.html"
$csv = Import-Csv -Path $changeLogCsv

$html = @"
<html>
<head>
    <title>ESXi Hardening Summary</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h1 { color: #2e6c80; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .compliant { background-color: #d4edda; }
        .changed { background-color: #fff3cd; }
        .dryrun { background-color: #fce4ec; }
        .error { background-color: #f8d7da; }
        .unknown { background-color: #eeeeee; }
    </style>
</head>
<body>
    <h1>ESXi Host Hardening Summary</h1>
    <p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    <table>
        <tr>
            <th>Timestamp</th>
            <th>Host</th>
            <th>Setting</th>
            <th>Old Value</th>
            <th>New Value</th>
            <th>Result</th>
        </tr>
"@

foreach ($entry in $csv) {
    $css = ""
    $result = $entry.Result.ToLower().Trim()
    switch -Wildcard ($result) {
        "*compliant*" { $css = "compliant" }
        "*updated*"   { $css = "changed" }
        "*dryrun*"    { $css = "dryrun" }
        "*error*"     { $css = "error" }
        default       { $css = "unknown" }
    }

    $html += "<tr class='$css'><td>$($entry.Timestamp)</td><td>$($entry.HostName)</td><td>$($entry.Setting)</td><td>$($entry.OldValue)</td><td>$($entry.NewValue)</td><td>$($entry.Result)</td></tr>`n"
}

$html += @"
    </table>
</body>
</html>
"@

$html | Out-File -FilePath $htmlPath -Encoding UTF8
Write-Host "📄 HTML summary exported to: $htmlPath" -ForegroundColor Cyan

# Prompt to open in browser
$openBrowser = Read-Host "`n🌐 Would you like to open the HTML summary in your browser now? (yes/no)"
if ($openBrowser -match "^(y|yes)$") {
    Start-Process $htmlPath
}

# Final Summary
Write-Host "`n✅ Configuration complete." -ForegroundColor Cyan
Write-Host "📄 Changes CSV:     $changeLogCsv" -ForegroundColor Cyan
Write-Host "📄 Baseline CSV:    $baselineCsv" -ForegroundColor Cyan
Write-Host "📄 Log file (TXT):  $textLogPath" -ForegroundColor Cyan
Write-Host "🌐 HTML Summary:    $htmlPath" -ForegroundColor Cyan
