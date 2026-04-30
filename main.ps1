#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;y;

powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\23jrg";

#Automatic debloat then launches the Guibased Tools
git clone https://github.com/raphire/win11debloat c:\23jrg\win11debloat
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\win11debloat\Win11Debloat.ps1", '-Silent', '-CreateRestorePoint', '-Config', "C:\23jrg\Quantum-Impeller\Win11Debloat-Config.json"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\AI_Uninstaller.ps1", '-noninteractive', '-alloptions'
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\winutil.ps1"

#invoke-expression 'cmd /c start powershell -Command {irm "https://christitus.com/win" | iex}';
C:\23jrg\Quantum-Impeller\quser.bat
#invoke-expression 'cmd /c start powershell -Command {C:\23jrg\Quantum-Impeller\quser.bat}';

#Profile Customization
if ($env:USERNAME -eq "jgraham" -or $env:USERNAME -eq "Administrator" -or $env:USERNAME -eq "CISTECH") {

$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "DarkYellow"

# 1. Define the online image URL and local save path
$url = "https://images4.alphacoders.com/101/1014815.png"
$localPath = "$env:USERPROFILE\Pictures\online_wallpaper.jpg"

# 2. Download the image from the web
Invoke-WebRequest -Uri $url -OutFile $localPath

# Create the registry key if it does not exist
if (!(Test-Path $cspPath)) {
    New-Item -Path $cspPath -Force | Out-Null
}

# 3. Define the C# code to call the Windows API for an instant update
$code = @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# 4. Add the type and apply the wallpaper
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

#Hide Widgets
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UCPD" -Name "Start" -Value 4
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0

#Turn off taskview
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

#Hide Searchbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

#Kill onedrive
taskkill /f /im OneDrive.exe

#Unpin everything from the taskbar
$appsToUnpin = @("Microsoft Store", "Mail", "Calculator", "Microsoft Edge", "Copilot", "Microsoft 365 Copilot", "Outlook")
$shell = New-Object -Com Shell.Application
$taskbarItems = $shell.NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
foreach ($appname in $appsToUnpin) {
    $item = $taskbarItems | Where-Object { $_.Name -eq $appname }
    if ($item) {
        $item.Verbs() | Where-Object { $_.Name.Replace("&", "") -match "Unpin from taskbar" } | ForEach-Object { $_.DoIt() }
        Write-Host "Unpinned: $appname"
    }
}

#Center taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1

#Refresh the explorer process to apply changes without logging out
#Stop-Process -Name explorer -Force

} 

#Set NTP pool time server
#w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org

#Set Timezone to EST
C:\Windows\System32\tzutil.exe /s "Eastern Standard Time"

#Sync Clock
w32tm /resync /force
Restart-Service w32time

#Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#installs a program that keeps the computer from sleeping and then sets it to keep awake for 15 mins
winget install ZhornSoftware.Caffeine --source winget --force;

#installs a tiling manager
#winget install GlazeWM --source winget --force;

#Refreshes the powershell path to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#Actives Caffeine, keeping the computer on for 15 mins while we work, sets computer to remain on for 15 mins after we sign in
Caffeine -activefor:15 -replace;

#Activates the tiling manager
#GlazeWM

$WshShell = New-Object -COMObject WScript.Shell
$CaffeineShortcut = $WshShell.CreateShortcut("$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine.lnk")
$CaffeineShortcut.Arguments = "-activefor:15 -replace"
$CaffeineShortcut.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$CaffeineShortcut.Save()

#Kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
#git clone https://github.com/23jrg/Kick-Inactive-Users;.\Kick-Inactive-Users\setup.bat;
git clone https://github.com/23jrg/Kick-Inactive-Users C:\LogInactiveOff;
schtasks.exe /Create /XML 'C:\LogInactiveOff\Log off inactive users.xml' /tn LogInactiveOff;

#Sets a copy of the Toolkit on the user's desktop
$WshShell = New-Object -COMObject WScript.Shell
$Shortcut3 = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools.lnk")
$Shortcut3.TargetPath = "powershell.exe"
$Shortcut3.Arguments = [string]"C:\23jrg\RemoveAI\RemoveWindowsAi.ps1 -noninteractive -alloptions"
$Shortcut3.Save()

#Pulls down an Office edition changer, this powerful tool automates the ability to switch one installed Office edition for another
git clone https://github.com/massgravel/Microsoft-Activation-Scripts c:\23jrg\Activator;C:\23jrg\Activator\MAS\Separate-Files-Version\Change_Office_Edition.cmd;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut4 = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Activator.lnk")
$Shortcut4.TargetPath = "C:\23jrg\Activator\MAS\All-In-One-Version-KL\MAS_AIO.cmd"
$Shortcut4.Save()


#Handy Windows updater gets placed in the tools folder
git clone https://github.com/23jrg/MediaCreationTool.bat c:\23jrg\MediaCreationTool.bat;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Mediacreationtool.lnk")
$Shortcut.TargetPath = "C:\23jrg\MediaCreationTool.bat\MediaCreationTool.bat"
$Shortcut.Save()

#Anti-AI
git clone https://github.com/zoicware/RemoveWindowsAI c:\23jrg\RemoveAI

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut3 = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Remove-AI.lnk")
$Shortcut3.TargetPath = "powershell.exe"
$Shortcut3.Arguments = [string]"C:\23jrg\RemoveAI\RemoveWindowsAi.ps1 -noninteractive -alloptions"
$Shortcut3.Save()

#Deployment Emailer gets placed in the Tools folder
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\SendEmail.bat" -Destination "C:\23jrg\"
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\Send-Gmail-Auto.ps1" -Destination "C:\23jrg\"


$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Send_Deployment_Email.lnk")
$Shortcut.TargetPath = "C:\23jrg\SendEmail.bat"
$Shortcut.Save()

#Set Quick Machine Recovery on 24h2+ computers
reagentc.exe /setrecoverysettings /path C:\23jrg\Quantum-Impeller\qmr_settings.xml;

#Set fast startup to disabled
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -v 'HiberbootEnabled' /t REG_DWORD -d 0 /f

#Disable location popups
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -v 'ShowGlobalPrompts' /t REG_DWORD -d 0 /f

#Disable Resume
taskkill /IM CrossDeviceResume.exe
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Connectivity\DisableCrossDeviceResume" /v "value" /t REG_DWORD /d "1" /f
Get-AppxPackage *Microsoft.CrossDeviceExperienceHost* | Remove-AppxPackage

#Grabs some functions to be run on cleanup
git clone https://github.com/ChrisTitusTech/winutil c:\23jrg\Winutil

#Cleans up leftovers on next startup
schtasks.exe /Create /XML 'C:\23jrg\Quantum-Impeller\Quantum-Cleanup.xml' /tn Quantum-Cleanup;
#schtasks.exe /Create /XML 'C:\23jrg\Quantum-Impeller\Quantum-Clipper.xml' /tn Quantum-Clipper;
Move-Item -Path "C:\23jrg\Quantum-Impeller\Quantum-Cleanup.ps1" -Destination "C:\Program Files\"
