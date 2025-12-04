#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;y;

#Guibased Tools
invoke-expression 'cmd /c start powershell -Command {irm https://get.activated.win | iex}';
invoke-expression 'cmd /c start powershell -Command {irm "https://christitus.com/win" | iex}';

#Refreshes the powershell path to use winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#installs a program that keeps the computer from sleeping and then sets it to keep awake for 15 mins
winget install ZhornSoftware.Caffeine --source winget --force;

#Refreshes the powershell path to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");

#Actives Caffeine, keeping the computer on for 15 mins while we work
Caffeine -activefor:15 -replace;

#Kicks inactive users from the computer to prevent people from remaining logged in and drawing resources from the current active user
git clone https://github.com/23jrg/Kick-Inactive-Users;.\Kick-Inactive-Users\setup.bat;

#Handy Windows updater gets placed on the desktop
git clone https://github.com/23jrg/MediaCreationTool.bat;

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Mediacreationtool.lnk")
$Shortcut.TargetPath = "$Home\MediaCreationTool.bat\MediaCreationTool.bat"
$Shortcut.Save()

#Set Quick Machine Recovery on 24h2+ computers
reagentc.exe /setrecoverysettings /path Quantum-Impeller\qmr_settings.xml;

#Set fast startup to disabled
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -v 'HiberbootEnabled' /t REG_DWORD -d 0 /f

#Disable location popups
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -v 'ShowGlobalPrompts' /t REG_DWORD -d 0 /f
