$Exceptions = @(
    "Caffeine",
    "Lightshot",
    "WindowsDefender",
	"Rustdesk",
	"Tailscale",
    "ClickPaste",
	"Teams",
	"Zoom",
	"Webex"
)

Write-Host "Starting systemic startup program cleanup..." -ForegroundColor Cyan

# System-Wide Registry Locations
$GlobalRunKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce"
)

foreach ($KeyPath in $GlobalRunKeys) {
    if (Test-Path $KeyPath) {
        $Properties = Get-ItemProperty -Path $KeyPath
        foreach ($Name in $Properties.PSObject.Properties.Name) {
            if ($Name -notin @('PSPath','PSParentPath','PSChildName','PSDrive','PSProvider')) {
                # Check against exceptions
                $Match = $false
                foreach ($Except in $Exceptions) { if ($Name -like "*$Except*") { $Match = $true } }
                
                if (-not $Match) {
                    Write-Host "[GLOBAL REGISTRY] Removing: $Name from $KeyPath" -ForegroundColor Yellow
                    Remove-ItemProperty -Path $KeyPath -Name $Name -Force -ErrorAction SilentlyContinue
                } else {
                    Write-Host "[EXCEPTION] Skipping: $Name" -ForegroundColor Green
                }
            }
        }
    }
}

# System-Wide Startup Folder
$GlobalStartupFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
if (Test-Path $GlobalStartupFolder) {
    $Files = Get-ChildItem -Path $GlobalStartupFolder -File
    foreach ($File in $Files) {
        $Match = $false
        foreach ($Except in $Exceptions) { if ($File.Name -like "*$Except*") { $Match = $true } }
        
        if (-not $Match) {
            Write-Host "[GLOBAL FOLDER] Deleting shortcut: $($File.Name)" -ForegroundColor Yellow
            Remove-Item -Path $File.FullName -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "[EXCEPTION] Skipping shortcut: $($File.Name)" -ForegroundColor Green
        }
    }
}

# User Profiles (Folders and Offline/Active Registry Hives)
$UserProfilesDir = "C:\Users"
$Profiles = Get-ChildItem -Path $UserProfilesDir -Directory

# Get currently logged in user's SID to handle active HKCU changes safely via HKEY_USERS if needed
foreach ($Profile in $Profiles) {
    $Username = $Profile.Name
    # Skip system profiles
    if ($Username -in @("All Users", "Default", "Default User", "Public")) { continue }
    
    Write-Host "`nProcessing profile: $Username" -ForegroundColor Cyan
    
    # User Specific Startup Folder
    $UserStartupFolder = "$UserProfilesDir\$Username\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\StartUp"
    if (Test-Path $UserStartupFolder) {
        $Files = Get-ChildItem -Path $UserStartupFolder -File
        foreach ($File in $Files) {
            $Match = $false
            foreach ($Except in $Exceptions) { if ($File.Name -like "*$Except*") { $Match = $true } }
            
            if (-not $Match) {
                Write-Host "  [USER FOLDER] Deleting shortcut: $($File.Name)" -ForegroundColor Yellow
                Remove-Item -Path $File.FullName -Force -ErrorAction SilentlyContinue
            } else {
                Write-Host "  [EXCEPTION] Skipping shortcut: $($File.Name)" -ForegroundColor Green
            }
        }
    }
    
    # Mount Offline User Registry Hive (NTUSER.DAT)
    $HivePath = "$UserProfilesDir\$Username\NTUSER.DAT"
    if (Test-Path $HivePath) {
        $TemporaryHiveName = "Hive_$Username"
        
        # Check if hive is already in use/logged in, otherwise mount it
        $LoadedHives = Get-ChildItem -Path Registry::HKEY_USERS | Select-Object -ExpandProperty Name
        if ($LoadedHives -like "*$TemporaryHiveName*") {
            # Already loaded or conflict exists, skip mounting
            continue
        }
        
        # Mount the hive
        reg load "HKU\$TemporaryHiveName" $HivePath | Out-Null
        
        $UserRunKeys = @(
            "Registry::HKEY_USERS\$TemporaryHiveName\Software\Microsoft\Windows\CurrentVersion\Run",
            "Registry::HKEY_USERS\$TemporaryHiveName\Software\Microsoft\Windows\CurrentVersion\RunOnce"
        )
        
        foreach ($KeyPath in $UserRunKeys) {
            if (Test-Path $KeyPath) {
                $Properties = Get-ItemProperty -Path $KeyPath -ErrorAction SilentlyContinue
                if ($Properties) {
                    foreach ($Name in $Properties.PSObject.Properties.Name) {
                        if ($Name -notin @('PSPath','PSParentPath','PSChildName','PSDrive','PSProvider')) {
                            $Match = $false
                            foreach ($Except in $Exceptions) { if ($Name -like "*$Except*") { $Match = $true } }
                            
                            if (-not $Match) {
                                Write-Host "  [USER REGISTRY] Removing: $Name from $Username profile" -ForegroundColor Yellow
                                Remove-ItemProperty -Path $KeyPath -Name $Name -Force -ErrorAction SilentlyContinue
                            } else {
                                Write-Host "  [EXCEPTION] Skipping: $Name" -ForegroundColor Green
                            }
                        }
                    }
                }
            }
        }
        
        # Unmount the hive to save changes and release lock
        [GC]::Collect()
        [GC]::WaitForPendingFinalizers()
        reg unload "HKU\$TemporaryHiveName" | Out-Null
    }
}

Write-Host "`nStartup cleanup complete!" -ForegroundColor Cyan
