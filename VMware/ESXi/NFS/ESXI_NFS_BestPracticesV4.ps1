#====================================================================================================================
#  AUTHOR: HumbledGeeks / Allen Johnson / Modified by ChatGPT for Allen Johnson
#  PURPOSE: Apply NFS Best Practice Advanced Settings to ESXi Hosts with Interactivity, Dry-Run, HTML Report, and Emojis
#====================================================================================================================

Clear-Host
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "        NFS Best Practices Hardening Script" -ForegroundColor Green
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

# Settings
$nfsSettings = @{
    "Net.TcpipHeapSize"          = "32"
    "Net.TcpipHeapMax"           = "1024"
    "NFS.MaxVolumes"             = "256"
    "NFS41.MaxVolumes"           = "256"
    "NFS.MaxQueueDepth"          = "128"
    "NFS.HeartbeatMaxFailures"   = "10"
    "NFS.HeartbeatFrequency"     = "12"
    "NFS.HeartbeatTimeout"       = "5"
    "Disk.QFullSampleSize"       = "32"
    "Disk.QFullThreshold"        = "8"
    "SunRPC.MaxConnPerIP"        = "128"
}

# Paths and logs
$basePath = "C:\ESXi_Hardening"
New-Item -Path $basePath -ItemType Directory -Force | Out-Null
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$csvPath       = Join-Path $basePath "hosts.csv"
$changeLogCsv  = Join-Path $basePath "NFS_AdvancedSettings_Changes_${timestamp}.csv"
$baselineCsv   = Join-Path $basePath "NFS_AdvancedSettings_Baseline_${timestamp}.csv"
$textLogPath   = Join-Path $basePath "NFS_AdvancedSettings_Log_${timestamp}.txt"

"Timestamp,HostName,Setting,OldValue,NewValue,Result" | Out-File $changeLogCsv -Encoding UTF8
"Timestamp,HostName,Setting,CurrentValue"             | Out-File $baselineCsv -Encoding UTF8
"[{0}] Starting NFS Best Practices Run" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | Out-File $textLogPath -Encoding UTF8

function Write-ChangedSetting { param ($msg); Write-Host "⚠️  $msg" -ForegroundColor Yellow; $msg | Out-File $textLogPath -Append -Encoding UTF8 }
function Write-CompliantSetting { param ($msg); Write-Host "✅ $msg" -ForegroundColor Green; $msg | Out-File $textLogPath -Append -Encoding UTF8 }
function Write-ErrorSetting { param ($msg); Write-Host "❌ $msg" -ForegroundColor Red; $msg | Out-File $textLogPath -Append -Encoding UTF8 }

# Connection setup
$connectedVIServers = @()
$hosts = @()
$cred = Get-Credential -Message "Enter ESXi root/admin credentials"

switch ($selection) {
    "1" {
        $vCenter = Read-Host "Enter vCenter Server"
        $viserver = Connect-VIServer -Server $vCenter -Credential $cred
        $connectedVIServers += $viserver
        $clusterName = Read-Host "Enter cluster name (leave blank for all hosts)"
        $hosts = if ($clusterName) { Get-Cluster -Name $clusterName | Get-VMHost } else { Get-VMHost }
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

# Apply NFS Best Practices
foreach ($vmhost in $hosts) {
    $hostName = $vmhost.Name
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "`n🔧 [$time] Processing $hostName..." -ForegroundColor Cyan

    foreach ($setting in $nfsSettings.Keys) {
        $desiredValue = $nfsSettings[$setting]
        $currentSetting = Get-AdvancedSetting -Entity $vmhost -Name $setting -ErrorAction SilentlyContinue
        if ($currentSetting) {
            $currentValue = $currentSetting.Value
            "$time,${hostName},${setting},${currentValue}" | Out-File $baselineCsv -Append -Encoding UTF8
            if ($currentValue -ne $desiredValue) {
                if ($applyChanges) {
                    Set-AdvancedSetting -AdvancedSetting $currentSetting -Value $desiredValue -Confirm:$false | Out-Null
                    Write-ChangedSetting "$hostName - CHANGED: $setting from '$currentValue' to '$desiredValue'"
                    "$time,$hostName,$setting,$currentValue,$desiredValue,Updated" | Out-File $changeLogCsv -Append -Encoding UTF8
                } else {
                    Write-Host "$hostName - 🧪 DRYRUN: Would change $setting from '$currentValue' to '$desiredValue'" -ForegroundColor Yellow
                    "$time,$hostName,$setting,$currentValue,$desiredValue,DryRun" | Out-File $changeLogCsv -Append -Encoding UTF8
                }
            } else {
                Write-CompliantSetting "$hostName - COMPLIANT: $setting = '$currentValue'"
                "$time,$hostName,$setting,$currentValue,$desiredValue,Already compliant" | Out-File $changeLogCsv -Append -Encoding UTF8
            }
        }
    }
}

# Disconnect sessions
$connectedVIServers | ForEach-Object {
    Disconnect-VIServer -Server $_ -Confirm:$false
    Write-Host "🔌 Disconnected from $($_.Name)" -ForegroundColor DarkGray
}

# Generate HTML Summary
Write-Host "`n📝 Generating HTML Summary Report..." -ForegroundColor Cyan
$htmlPath = Join-Path $basePath "nfs_summary_${timestamp}.html"
$csv = Import-Csv -Path $changeLogCsv
$html = @"
<html><head><title>NFS Summary</title><style>
body { font-family: Arial; margin: 20px; }
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
th { background-color: #f2f2f2; }
.compliant { background-color: #d4edda; }
.changed { background-color: #fff3cd; }
.dryrun { background-color: #fce4ec; }
.error { background-color: #f8d7da; }
.unknown { background-color: #eeeeee; }
</style></head><body>
<h1>ESXi NFS Best Practices Summary</h1>
<p><strong>Generated:</strong> $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
<table>
<tr><th>Timestamp</th><th>Host</th><th>Setting</th><th>Old Value</th><th>New Value</th><th>Result</th></tr>
"@
foreach ($entry in $csv) {
    $css = ""; $result = $entry.Result.ToLower().Trim()
    switch -Wildcard ($result) {
        "*compliant*" { $css = "compliant" }
        "*updated*"   { $css = "changed" }
        "*dryrun*"    { $css = "dryrun" }
        "*error*"     { $css = "error" }
        default       { $css = "unknown" }
    }
    $html += "<tr class='$css'><td>$($entry.Timestamp)</td><td>$($entry.HostName)</td><td>$($entry.Setting)</td><td>$($entry.OldValue)</td><td>$($entry.NewValue)</td><td>$($entry.Result)</td></tr>`n"
}
$html += "</table></body></html>"
$html | Out-File -FilePath $htmlPath -Encoding UTF8
Write-Host "📄 HTML summary exported to: $htmlPath" -ForegroundColor Cyan

# Open HTML prompt
$openBrowser = Read-Host "`n🌐 Would you like to open the HTML summary in your browser now? (yes/no)"
if ($openBrowser -match "^(y|yes)$") {
    Start-Process $htmlPath
}

# Final summary
Write-Host "`n✅ NFS best practices configuration complete." -ForegroundColor Cyan
Write-Host "📄 Changes CSV:     $changeLogCsv" -ForegroundColor Cyan
Write-Host "📄 Baseline CSV:    $baselineCsv" -ForegroundColor Cyan
Write-Host "📄 Log file (TXT):  $textLogPath" -ForegroundColor Cyan
Write-Host "🌐 HTML Summary:    $htmlPath" -ForegroundColor Cyan
