#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;y;

#Guibased Tools
invoke-expression 'cmd /c start powershell -Command {irm "https://christitus.com/win" | iex}';

#Makes a .txt with the ID of the runner who ran this script (this is used later for cleanup)
invoke-expression 'cmd /c start powershell -Command {C:\23jrg\Quantum-Impeller\quser.bat}'

#Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#installs a program called Caffeine that keeps the computer from sleeping
winget install ZhornSoftware.Caffeine --source winget --force;

#Sets Caffeine to  keep the computer awake for 5 minutes every time the runner logs in
Caffeine -activefor:5 -replace;

$WshShell = New-Object -COMObject WScript.Shell
$CaffeineShortcut = $WshShell.CreateShortcut("$Home\desktop\caffeine.lnk")
$CaffeineShortcut.Arguments = "-activefor:5 -replace"
$CaffeineShortcut.TargetPath = "$Home\AppData\Local\Microsoft\WinGet\Packages\ZhornSoftware.Caffeine_Microsoft.Winget.Source_8wekyb3d8bbwe\caffeine64.exe"
$CaffeineShortcut.Save()

#Refreshes the powershell path again to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#Pulls down a program that kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
git clone https://github.com/23jrg/Kick-Inactive-Users AppData\Local\Temp\KIU

#Creates an installer for the program and moves it to the desktop
$WshShell = New-Object -COMObject WScript.Shell
$LoiaShortcut = $WshShell.CreateShortcut("$Home\desktop\Install_LogOffInactiveAccounts.lnk")
$LoiaShortcut.TargetPath = "$Home\AppData\Local\Temp\KIU\setup.bat"
$LoiaShortcut.Save()

#Pulls down an Office edition changer, this powerful tool automates the ability to switch one installed Office edition for another
#powershell -inputformat none -outputformat none -NonInteractive -Command Add-MpPreference -ExclusionPath "c:\23jrg";
git clone https://github.com/massgravel/Microsoft-Activation-Scripts c:\23jrg\Activator;C:\23jrg\Activator\MAS\Separate-Files-Version\Change_Office_Edition.cmd;

#Handy Windows updater gets placed on the desktop
git clone https://github.com/lzw29107/MediaCreationTool.bat c:\23jrg\MediaCreationTool.bat;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Mediacreationtool.lnk")
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
