@echo off

:start
echo Enter the code to unlock additional functionality :
set /p "code=>"

if "%code%"=="1337" (
echo Access Granted!
echo > Tron.bat
echo FSUTIL DIRTY query ^%SystemDrive% ^>NUL ^|^| ( >> Tron.bat
echo PowerShell ^"Start-Process -FilePath C:\23jrg\Quantum-Impeller\Tools\Advanced_Tools\Tron.bat -Verb RunAs^" >> Tron.bat
echo ^EXIT >> Tron.bat
echo ^) >> Tron.bat

echo start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Volume.ps1" >> Tron.bat
echo start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Music.ps1" >> Tron.bat
echo start cmd /k "color 2&&curl ascii.live/knot" >> Tron.bat
echo powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Caffeine -replace;Add-WindowsCapability -Online -Name WMIC;Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All;foreach ($dev in (Get-PnpDevice | Where-Object{$_.Class -eq 'Mouse'})) {&'pnputil' /remove-device $dev.InstanceId};curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/l1i47sufwu8oq9gfomxzd/AH0AlovhO_R5M1hd3_JyIgk?rlkey=o5of9srrq12e6e6jxp324n186&st=yowokjft&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;Start-Process 'cmd.exe' -ArgumentList '/c C:\23jrg\Quantum-Impeller\tools\tron\tron.bat' -WindowStyle Maximized;" >> Tron.bat

start powershell -Command "$WshShell = New-Object -COMObject WScript.Shell;$Shortcut3 = $WshShell.CreateShortcut('C:\23jrg\Quantum-Impeller\Tools\Advanced_Tools\Remove-AI.lnk');$Shortcut3.TargetPath = 'powershell.exe';$Shortcut3.Arguments = [string]'& ([scriptblock]::Create((irm 'https://raw.githubusercontent.com/zoicware/RemoveWindowsAI/main/RemoveWindowsAi.ps1'))) -nonInteractive -AllOptions';$Shortcut3.Save()"

start powershell -Command "$WshShell = New-Object -COMObject WScript.Shell;$Shortcut4 = $WshShell.CreateShortcut('C:\23jrg\Quantum-Impeller\Tools\Advanced_Tools\Activator.lnk');$Shortcut4.TargetPath = 'powershell.exe';$Shortcut4.Arguments = [string]'iex (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String)';$Shortcut4.Save()"

(goto) 2>nul & del "%~f0"
) else (
    echo Access Denied. Try again.
    goto start
)
