#Set Execution Policy Remote Signed (needed for the gui tools)
set-executionpolicy remotesigned;a;

#Guibased Tools
invoke-expression 'cmd /c start powershell -Command {irm https://get.activated.win | iex}';
invoke-expression 'cmd /c start powershell -Command {irm "https://christitus.com/win" | iex}';

#installs a program that keeps the computer from sleeping
winget install ZhornSoftware.Caffeine --source winget --force;

#Refreshes the powershell path to use all the cool stuff we just added to it
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

#Keeps computer awake while you're working on it
;Caffeine -activefor:15 -replace;git clone https://github.com/23jrg/Kick-Inactive-Users;.\Kick-Inactive-Users\setup.bat;

#Handy Windows updater
git clone https://github.com/lzw29107/MediaCreationTool.bat;.\MediaCreationTool.bat\MediaCreationTool.bat
