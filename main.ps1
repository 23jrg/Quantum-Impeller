# Check if the current session is running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Relaunch the script with Administrator privileges (-Verb RunAs triggers UAC)
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -ErrorAction Stop
    }
    catch {
        Write-Warning "UAC prompt was denied or failed to launch."
    }
    # Exit the current, non-elevated script instance
    Exit
}

# Remove any leftover files from last run
Remove-Item -Path "C:\Program Files\Quantum-Cleanup.ps1" -Force;
schtasks.exe /delete /f /TN Quantum-Cleanup;

# Set Execution Policy Remote Signed
set-executionpolicy remotesigned;a;y;

# Set exclusion path to prevent false positives
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\23jrg";
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\24jrg";

# Automatic debloat then launches the Guibased Tools
curl -o C:\24jrg.zip https://github.com/Raphire/Win11Debloat/archive/refs/heads/master.zip;
tar -xf C:\24jrg.zip -C C:\23jrg\;
ren C:\23jrg\Win11Debloat-master win11debloat;

#Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Startup_Cleaner.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\OneDrive_Cleanup.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneLaunch\OneLaunch-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneStart\OneStart-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneBrowser\OneBrowser-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\WaveBrowser\WaveBrowser-Remediation-Script-Win10-BrowserKill.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\win11debloat\Win11Debloat.ps1", '-Silent', '-CreateRestorePoint', '-Config', "C:\23jrg\Quantum-Impeller\Win11Debloat-Config.json"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\RemoveBloat.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\AI_Uninstaller.ps1", '-noninteractive', '-alloptions'
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\winutil.ps1"

# Notes down which user launched the script
C:\23jrg\Quantum-Impeller\quser.bat

# Profile Customization
if ($env:USERNAME -eq "jgraham" -or $env:USERNAME -eq "Administrator" -or $env:USERNAME -eq "CISTECH") {
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "DarkYellow"

# Backround image URL
$url = "https://images4.alphacoders.com/101/1014815.png"

# $localPath = "$env:USERPROFILE\Pictures\online_wallpaper.jpg"
Invoke-WebRequest -Uri $url -OutFile "$env:USERPROFILE\Pictures\online_wallpaper.jpg" #$localPath

# Create the registry key if it does not exist
if (!(Test-Path $cspPath)) {
    New-Item -Path $cspPath -Force | Out-Null
}

# Define the C# code to call the Windows API for an instant update
$code = @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Add the type and apply the wallpaper
Add-Type -TypeDefinition $code -Language CSharp
[Wallpaper]::SystemParametersInfo(20, 0, $localPath, 3)

$RegKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Set Apps to Dark
Set-ItemProperty -Path $RegKeyPath -Name "AppsUseLightTheme" -Value 0 -Type Dword -Force

# Set System to Dark
Set-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme" -Value 0 -Type Dword -Force

# Define the Yellow accent color in hex (AABBGGRR format for registry)
$yellowHex = 0xFF009AC4

# Update Registry for Personalization Colors
$registryPath = "HKCU:\Software\Microsoft\Windows\DWM"
Set-ItemProperty -Path $registryPath -Name "AccentColor" -Value $yellowHex
Set-ItemProperty -Path $registryPath -Name "ColorPrevalence" -Value 1

# Update User Personalization for the "Yellow" theme color
$personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
Set-ItemProperty -Path $personalizePath -Name "AccentColorMenu" -Value $yellowHex

# Hide Widgets
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UCPD" -Name "Start" -Value 4
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0

# Turn off taskview
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

# Hide Searchbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

# Kill onedrive
taskkill /f /im OneDrive.exe

# Unpin everything from the taskbar except File Explorer
$shell = New-Object -Com Shell.Application
$taskbarItems = $shell.NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()

foreach ($appname in $taskbarItems) {
    if ($appname.Name -ne "File Explorer") {
        $item = $appname
        $item.Verbs() |
            Where-Object { $_.Name.Replace("&", "") -match "Unpin from taskbar" } |
            ForEach-Object {
                $_.DoIt()
                Write-Host "Unpinned: $($appname.Name)"
            }
    }
}

# Center taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1

#Refresh the explorer process to apply changes without logging out
#Stop-Process -Name explorer -Force

} 

#Set NTP pool time server
#w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org

# Set Timezone to EST
C:\Windows\System32\tzutil.exe /s "Eastern Standard Time"

# Sync Clock
w32tm /resync /force
Restart-Service w32time

# Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

# installs a program that keeps the computer from sleeping and then sets it to keep awake for 15 mins
winget install ZhornSoftware.Caffeine --source winget --force;

#installs a tiling manager
#winget install GlazeWM --source winget --force;

# Refreshes the powershell path to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

# Actives Caffeine, keeping the computer on for 15 mins while we work, sets computer to remain on for 15 mins after we sign in
if (-not (Test-Path -Path "c:\users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine_wrk_hrs.lnk")) {
Caffeine -activefor:15 -replace;
$WshShell = New-Object -COMObject WScript.Shell
$CaffeineShortcut = $WshShell.CreateShortcut("$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine.lnk")
$CaffeineShortcut.Arguments = "-activefor:15 -replace"
$CaffeineShortcut.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$CaffeineShortcut.Save()
}

# Kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
curl -o C:\24jrg.zip https://github.com/23jrg/Kick-Inactive-Users/archive/refs/heads/main.zip;
tar -xf C:\24jrg.zip -C C:\
ren c:\Kick-Inactive-Users-main LogInactiveOff
schtasks.exe /Create /XML 'C:\LogInactiveOff\Log off inactive users.xml' /tn LogInactiveOff;

# Sets a copy of the Toolkit on the user's desktop
$WshShell = New-Object -COMObject WScript.Shell
$ToolShortcut = $WshShell.CreateShortcut("$Home\desktop\TechTools.lnk")
$ToolShortcut.TargetPath = "C:\23jrg\Quantum-Impeller\Tools"
$ToolShortcut.IconLocation = "C:\23jrg\Quantum-Impeller\favicon.ico"
$ToolShortcut.Save()

# Puts a shortcut of Caffeine in the tech tools, set to stay active from 9:30-6:00
$WshShell = New-Object -COMObject WScript.Shell
$Caffeine_wrk_hrs = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\caffeine_wrk_hrs.lnk")
$Caffeine_wrk_hrs.Arguments = " -activeperiods:0930-1800 -replace"
$Caffeine_wrk_hrs.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$Caffeine_wrk_hrs.Save()

# Creates shortcut to startup folder
$WshShell = New-Object -COMObject WScript.Shell
$Startup = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\startup.lnk")
$Startup.TargetPath = "$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$Startup.Save()

# Copies the Inactive User Uninstaller to the tools folder
Copy-Item -Path "C:\LogInactiveOff\uninstall.bat" -Destination "C:\23jrg\Quantum-Impeller\Tools"
Rename-Item -Path "C:\23jrg\Quantum-Impeller\Tools\uninstall.bat" -NewName "Uninstall_Log_Inactive_Off.bat"

# Handy Windows updater gets placed in the tools folder
curl -o C:\24jrg.zip https://github.com/23jrg/MediaCreationTool.bat/archive/refs/heads/main.zip;
tar -xf C:\24jrg.zip -C C:\23jrg;
ren c:\23jrg\MediaCreationTool.bat-main "MediaCreationTool.bat"
$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\11_Upgrade_Tool.lnk")
$Shortcut.TargetPath = "C:\23jrg\MediaCreationTool.bat\MediaCreationTool.bat"
$Shortcut.Save()

#Deployment Emailer gets placed in the Tools folder
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\SendEmail.bat" -Destination "C:\23jrg\"
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\Send-Gmail-Auto.ps1" -Destination "C:\23jrg\"
$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Send_Deployment_Email.lnk")
$Shortcut.TargetPath = "C:\23jrg\SendEmail.bat"
$Shortcut.Save()

# Set Quick Machine Recovery on 24h2+ computers
reagentc.exe /setrecoverysettings /path C:\23jrg\Quantum-Impeller\qmr_settings.xml;

# Set Page File to automatically managed
Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem" -Property @{AutomaticManagedPagefile=$True}

# Set fast startup to disabled
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -v 'HiberbootEnabled' /t REG_DWORD -d 0 /f

# Disable location popups
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -v 'ShowGlobalPrompts' /t REG_DWORD -d 0 /f

# Disable Resume
taskkill /IM CrossDeviceResume.exe
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume" /v "value" /t REG_DWORD /d "1" /f
Get-AppxPackage *Microsoft.CrossDeviceExperienceHost* | Remove-AppxPackage

# Creates schedueled task to clean up leftovers and run a computer repair when the computer falls asleep
schtasks.exe /Create /XML 'C:\23jrg\Quantum-Impeller\Quantum-Cleanup.xml' /tn Quantum-Cleanup;
Move-Item -Path "C:\23jrg\Quantum-Impeller\Quantum-Cleanup.ps1" -Destination "C:\Program Files\"
