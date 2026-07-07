#Check if the current session is running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    #Relaunch the script with Administrator privileges (-Verb RunAs triggers UAC)
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs -ErrorAction Stop
    }
    catch {
        Write-Warning "UAC prompt was denied or failed to launch."
    }
    #Exit the current, non-elevated script instance
    Exit
}

#Remove any leftover files from last run
Remove-Item -Path "C:\Program Files\Quantum-Cleanup.ps1" -Force;
schtasks.exe /delete /f /TN Quantum-Cleanup;

#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;y;

#Create an exclusion to prevent false positives
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\23jrg";
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\24jrg";
#Automatic debloat then launches the Guibased Tools
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
#Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\tools\winutil.bat"

#Deployment Emailer gets placed on the Desktop
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\SendEmail.bat" -Destination "C:\23jrg\"
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\Send-Gmail-Auto.ps1" -Destination "C:\23jrg\"

#Makes a .txt with the ID of the runner who ran this script (this is used later for cleanup)
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

#Profile Customization
if ($env:USERNAME -eq "Administrator" -or $env:USERNAME -eq "CISTECH") {

$Host.UI.RawUI.BackgroundColor = "Black"

# Set Apps to Dark
Set-ItemProperty -Path $RegKeyPath -Name "AppsUseLightTheme" -Value 0 -Type Dword -Force

# Set System to Dark
Set-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme" -Value 0 -Type Dword -Force

#Hide Widgets
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UCPD" -Name "Start" -Value 4
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0

#Turn off taskview
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

#Hide Searchbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

#Kill onedrive
taskkill /f /im OneDrive.exe

#Unpin bloat from the taskbar
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

#Center taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1

}

#Set Timezone to EST
#C:\Windows\System32\tzutil.exe /s "Eastern Standard Time"

#Sync Clock
w32tm /resync /force
Restart-Service w32time

#Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#installs a program called Caffeine that keeps the computer from sleeping
winget install ZhornSoftware.Caffeine --source winget --force;

#Sets Caffeine to  keep the computer awake for 5 minutes every time the runner logs in
if (-not (Test-Path -Path "c:\users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine_wrk_hrs.lnk")) {

    Caffeine -activefor:15 -replace;

$WshShell = New-Object -COMObject WScript.Shell
$CaffeineShortcut = $WshShell.CreateShortcut("$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine.lnk")
$CaffeineShortcut.Arguments = "-activefor:15 -replace"
$CaffeineShortcut.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$CaffeineShortcut.Save()

}

#Refreshes the powershell path again to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#Pulls down a program that kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
#git clone https://github.com/23jrg/Kick-Inactive-Users C:\23jrg\Kick-Inactive-Users
curl -o C:\24jrg.zip https://github.com/23jrg/Kick-Inactive-Users/archive/refs/heads/main.zip;
tar -xf C:\24jrg.zip -C C:\23jrg
ren c:\23jrg\Kick-Inactive-Users-main Kick-Inactive-Users

#Sets a copy of the Toolkit on the user's desktop
$WshShell = New-Object -COMObject WScript.Shell
$ToolShortcut = $WshShell.CreateShortcut("$Home\desktop\TechTools.lnk")
$ToolShortcut.TargetPath = "C:\23jrg\Quantum-Impeller\Tools"
$ToolShortcut.IconLocation = "C:\23jrg\Quantum-Impeller\favicon.ico"
$ToolShortcut.Save()

#Creates an installer for the program and moves it to the desktop
$WshShell = New-Object -COMObject WScript.Shell
$LoiaShortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Install_LogOffInactiveAccounts.lnk")
$LoiaShortcut.TargetPath = "C:\23jrg\Kick-Inactive-Users\setup.bat"
$LoiaShortcut.Save()

#Handy Windows updater gets placed on the desktop
curl -o C:\24jrg.zip https://github.com/23jrg/MediaCreationTool.bat/archive/refs/heads/main.zip;
tar -xf C:\24jrg.zip -C C:\23jrg;
ren c:\23jrg\MediaCreationTool.bat-main "MediaCreationTool.bat"

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\11_Upgrade_Tool.lnk")
$Shortcut.TargetPath = "C:\23jrg\MediaCreationTool.bat\MediaCreationTool.bat"
$Shortcut.Save()

#Set Quick Machine Recovery on 24h2+ computers
reagentc.exe /setrecoverysettings /path C:\23jrg\Quantum-Impeller\qmr_settings.xml

# Sets troubleshooters to automatic
reg add 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsMitigation' -v 'UserPreference' /t REG_DWORD -d 3 /f


#Set Page File to automatically managed
Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem" -Property @{AutomaticManagedPagefile=$True}

#Set fast startup to disabled
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -v 'HiberbootEnabled' /t REG_DWORD -d 0 /f

#Disable location popups
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -v 'ShowGlobalPrompts' /t REG_DWORD -d 0 /f

#Disable Resume
taskkill /IM CrossDeviceResume.exe
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume" /v "value" /t REG_DWORD /d "1" /f
Get-AppxPackage *Microsoft.CrossDeviceExperienceHost* | Remove-AppxPackage

#Cleans up leftovers on next startup
schtasks.exe /Create /XML 'C:\23jrg\Quantum-Impeller\Quantum-Cleanup.xml' /tn Quantum-Cleanup;
Move-Item -Path "C:\23jrg\Quantum-Impeller\Quantum-Cleanup.ps1" -Destination "C:\Program Files\"
