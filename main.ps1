<#
.SYNOPSIS 
This script terraforms a computer once ran, optimizing as it goes

.DESCRIPTION 
Windows ships broken. This script removes spyware, repairs damaged files, and enables settings to help the computer automatically recover if it enters a failstate. 
This script also places a folder on the desktop with every manual tool a technician needs to repair common issues

.PARAMETER
No parameters are accepted as this is a manual tool rather than run on a schedule

.NOTES
Author: 23jrg
Created: 2025
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Local Admin
Rollback: This script removes all files after it's done except for a script that saves performance with shared computers, this can be removed with C:\LogInactiveOff\uninstall.bat
AI-assisted: no

.CHANGELOG
V1.0 2026-07-29 23jrg Complience update
v1.1 2026-07-29 23jrg: Enable logging
v1.2 2026-07-29 23jrg: Changed execution policy as there were errors with running multiple processes
v1.3 2026-07-29 23jrg: Changed execution policy again
v1.4 2026-08-03 23jrg: Check for and remove old LogInactiveOff files
v1.5 2026-08-04 23jrg: Added installation of Chocolatey
v1.6 2026-08-04 23jrg: Added process to update all apps with winget and chocolatey if it's already on the system
v1.7 2026-08-04 23jrg: Uncommented startup cleaner
v1.8 2026-08-06 23jrg: Added compatibility to the auto-update apps funciton
v1.9 2026-08-06 23jrg: Added waterfox browser installation
v1.91 2026-08-06 23jrg: Commented chocolatey component
v1.92 2026-08-06 23jrg: Removed Waterfox installation
#>

# Enable logging
Start-Transcript -Path "C:\23jrg\ScriptLog_$(Get-Date -Format 'yyyy-MM-dd').log" -Append

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

# Set Execution Policy remotesigned
set-executionpolicy remotesigned -Scope CurrentUser -Force

# Automatic debloat then launches the Guibased Tools
curl -o C:\24jrg.zip https://github.com/Raphire/Win11Debloat/archive/refs/tags/2026.07.11.zip;
tar -xf C:\24jrg.zip -C C:\23jrg\;
ren C:\23jrg\Win11Debloat-2026.07.11 win11debloat;

Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Startup_Cleaner.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\OneDrive_Cleanup.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneLaunch\OneLaunch-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneStart\OneStart-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\OneBrowser\OneBrowser-Remediation-Script.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\Xephora-Threat-Remediation-Scripts\WaveBrowser\WaveBrowser-Remediation-Script-Win10-BrowserKill.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\win11debloat\Win11Debloat.ps1", '-Silent', '-CreateRestorePoint', '-Config', "C:\23jrg\Quantum-Impeller\Win11Debloat-Config.json"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\RemoveBloat.ps1"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\AI_Uninstaller.ps1", '-noninteractive', '-alloptions'
#Start-Process powershell.exe "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
Start-Process powershell.exe "winget upgrade --all --silent --include-unknown --force --accept-source-agreements"
#Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\s\winutil.bat"

# Notes down which user launched the script
C:\23jrg\Quantum-Impeller\quser.bat

# Minimize all open windows to allow the technician to begin work faster
(New-Object -ComObject Shell.Application).MinimizeAll()

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$SW_MINIMIZE = 6
$hwnd = [Win32]::GetForegroundWindow()
[Win32]::ShowWindow($hwnd, $SW_MINIMIZE)

# Profile Customization
if ($env:USERNAME -eq "jgraham" -or $env:USERNAME -eq "Administrator" -or $env:USERNAME -eq "CISTECH") {


$Host.UI.RawUI.BackgroundColor = "Black"

#Yellow
#$Host.UI.RawUI.ForegroundColor = "DarkYellow"
#$Hex = 0xFF009AC4
#$url = "https://images4.alphacoders.com/101/1014815.png"

#Blue
$Host.UI.RawUI.ForegroundColor = "Blue"
$Hex = 0xFFEBA134
$url = "https://4kwallpapers.com/images/wallpapers/dark-abstract-3840x2160-18134.png"


$localPath = "$env:USERPROFILE\Pictures\online_wallpaper.jpg"

# Download the image from the web
Invoke-WebRequest -Uri $url -OutFile $localPath

# Create the registry key if it does not exist
# if (!(Test-Path $cspPath)) {
#     New-Item -Path $cspPath -Force | Out-Null
# }

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

# Update Registry for Personalization Colors
$registryPath = "HKCU:\Software\Microsoft\Windows\DWM"
Set-ItemProperty -Path $registryPath -Name "AccentColor" -Value $Hex
Set-ItemProperty -Path $registryPath -Name "ColorPrevalence" -Value 1

# Update User Personalization for the "Yellow" theme color
$personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
Set-ItemProperty -Path $personalizePath -Name "AccentColorMenu" -Value $Hex

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
Stop-Process -Name explorer -Force

} 

# Sync Clock
w32tm /resync /force
Restart-Service w32time

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
schtasks.exe /delete /f /TN LogInactiveOff;
Remove-Item -Path "C:\Kick-Inactive-Users-main" -Recurse -Force;
Remove-Item -Path "C:\LogInactiveOff" -Recurse -Force;
curl -o C:\24jrg.zip https://github.com/23jrg/Kick-Inactive-Users/archive/refs/heads/main.zip;
tar -xf C:\24jrg.zip -C C:\
ren c:\Kick-Inactive-Users-main LogInactiveOff
schtasks.exe /Create /XML 'C:\LogInactiveOff\Log off inactive users.xml' /tn LogInactiveOff;

# Sets a copy of the kit on the user's desktop
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

# Office installers get placed in the tools folder
Start-process powershell.exe -WindowStyle Minimized "curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/fktoj3o64v403x17ccma5/ADpsfyO5LHjH5eEQdRzUzGE?rlkey=1uf44kexqpneguhwd6xyisbs4&st=inpfbgg2&dl=1';mkdir C:\23jrg\Quantum-Impeller\tools\Office_Installers;tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools\Office_Installers"

# Set Quick Machine Recovery on 24h2+ computers
reagentc.exe /setrecoverysettings /path C:\23jrg\Quantum-Impeller\qmr_settings.xml;

# Sets troubleshooters to automatic
reg add 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsMitigation' -v 'UserPreference' /t REG_DWORD -d 3 /f

# Set Page File to automatically managed
Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem" -Property @{AutomaticManagedPagefile=$True}

# Set fast startup to disabled
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -v 'HiberbootEnabled' /t REG_DWORD -d 0 /f

# https://windowsforum.com/threads/lg-monitor-app-installer-pushes-mcafee-ads-on-windows-11.439030/
reg add 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Device Metadata' -v 'PreventDeviceMetadataFromNetwork' /t REG_DWORD -d 1 /f

# Disable location popups for current technician and future users
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -v 'ShowGlobalPrompts' /t REG_DWORD -d 0 /f
$DefaultHive = "$env:SystemDrive\Users\Default\NTUSER.DAT"
reg.exe load HKU\DefaultUser $DefaultHive
New-Item -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
New-ItemProperty `
    -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" `
    -Name "ShowGlobalPrompts" `
    -Value 0 `
    -PropertyType DWord `
    -Force | Out-Null
reg.exe unload HKU\DefaultUser

# Disable Resume
taskkill /IM CrossDeviceResume.exe
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume" /v "value" /t REG_DWORD /d "1" /f
Get-AppxPackage *Microsoft.CrossDeviceExperienceHost* | Remove-AppxPackage

# Creates schedueled task to clean up leftovers and run a computer repair when the computer falls asleep
schtasks.exe /Create /XML 'C:\23jrg\Quantum-Impeller\Quantum-Cleanup.xml' /tn Quantum-Cleanup;
Move-Item -Path "C:\23jrg\Quantum-Impeller\Quantum-Cleanup.ps1" -Destination "C:\Program Files\"

Stop-Transcript
