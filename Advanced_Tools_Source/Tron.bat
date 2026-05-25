ECHO is off.
FSUTIL DIRTY query C: >NUL || ( 
PowerShell "Start-Process -FilePath C:\23jrg\Quantum-Impeller\Tools\Advanced_Tools\Tron.bat -Verb RunAs" 
EXIT 
) 
start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Volume.ps1" 
start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Music.ps1" 
start cmd /k "color 2&&curl ascii.live/knot" 
powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Caffeine -replace;Add-WindowsCapability -Online -Name WMIC;Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All;foreach ($dev in (Get-PnpDevice | Where-Object{$_.Class -eq 'Mouse'})) {&'pnputil' /remove-device $dev.InstanceId};curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/l1i47sufwu8oq9gfomxzd/AH0AlovhO_R5M1hd3_JyIgk?rlkey=o5of9srrq12e6e6jxp324n186&st=yowokjft&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;Start-Process 'cmd.exe' -ArgumentList '/c C:\23jrg\Quantum-Impeller\tools\tron\tron.bat' -WindowStyle Maximized;" 
