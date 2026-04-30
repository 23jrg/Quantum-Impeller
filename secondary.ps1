#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;y;

#Create an exclusion to prevent false positives
powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\23jrg";

#Automatic debloat then launches the Guibased Tools
git clone https://github.com/raphire/win11debloat c:\23jrg\win11debloat
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\win11debloat\Win11Debloat.ps1", '-Silent', '-CreateRestorePoint', '-Config', "C:\23jrg\Quantum-Impeller\Win11Debloat-Config.json"
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\AI_Uninstaller.ps1", '-noninteractive', '-alloptions'
Start-Process powershell.exe -ArgumentList "-File", "C:\23jrg\Quantum-Impeller\winutil.ps1"

#Deployment Emailer gets placed on the Desktop
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\SendEmail.bat" -Destination "C:\23jrg\"
Copy-Item -Path "\\ve-fsvr\CIS_Internal_Data\Tools\DeploymentEmails\Send-Gmail-Auto.ps1" -Destination "C:\23jrg\"

#Makes a .txt with the ID of the runner who ran this script (this is used later for cleanup)
C:\23jrg\Quantum-Impeller\quser.bat

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

}

#Set Timezone to EST
C:\Windows\System32\tzutil.exe /s "Eastern Standard Time"

#Sync Clock
w32tm /resync /force
Restart-Service w32time

#Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#installs a program called Caffeine that keeps the computer from sleeping
winget install ZhornSoftware.Caffeine --source winget --force;

#Sets Caffeine to  keep the computer awake for 5 minutes every time the runner logs in
Caffeine -activefor:5 -replace;

$WshShell = New-Object -COMObject WScript.Shell
$CaffeineShortcut = $WshShell.CreateShortcut("$Home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\caffeine.lnk")
$CaffeineShortcut.Arguments = "-activefor:5 -replace"
$CaffeineShortcut.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$CaffeineShortcut.Save()

#Refreshes the powershell path again to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#Pulls down a program that kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
git clone https://github.com/23jrg/Kick-Inactive-Users AppData\Local\Temp\KIU

#Sets a copy of the Toolkit on the user's desktop
$WshShell = New-Object -COMObject WScript.Shell
$ToolShortcut = $WshShell.CreateShortcut("$Home\desktop\TechTools.lnk")
$ToolShortcut.TargetPath = "C:\23jrg\Quantum-Impeller\Tools"
$ToolShortcut.Save()

#Creates an installer for the program and moves it to the desktop
$WshShell = New-Object -COMObject WScript.Shell
$LoiaShortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Install_LogOffInactiveAccounts.lnk")
$LoiaShortcut.TargetPath = "$Home\AppData\Local\Temp\KIU\setup.bat"
$LoiaShortcut.Save()

#Pulls down an Office edition changer, this powerful tool automates the ability to switch one installed Office edition for another
git clone https://github.com/massgravel/Microsoft-Activation-Scripts c:\23jrg\Activator;C:\23jrg\Activator\MAS\Separate-Files-Version\Change_Office_Edition.cmd;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut4 = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Change_Office_Edition.lnk")
$Shortcut4.TargetPath = "C:\23jrg\Activator\MAS\Separate-Files-Version\Change_Office_Edition.cmd"
$Shortcut4.Save()

#Handy Windows updater gets placed on the desktop
git clone https://github.com/lzw29107/MediaCreationTool.bat c:\23jrg\MediaCreationTool.bat;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\23jrg\Quantum-Impeller\Tools\Mediacreationtool.lnk")
$Shortcut.TargetPath = "C:\23jrg\MediaCreationTool.bat\MediaCreationTool.bat"
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
Move-Item -Path "C:\23jrg\Quantum-Impeller\Quantum-Cleanup.ps1" -Destination "C:\Program Files\"
