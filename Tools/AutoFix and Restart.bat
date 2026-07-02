REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Queues up a windows reinstall on 24H2+ computers
start powershell -file "C:\23jrg\Quantum-Impeller\InplaceReinstall.ps1"

TIMEOUT /T 23

REM Launches a script in the backround that locks the computer if someone moves the mouse, useful for running the following repair commands onsite without having to worry about users messing with the computer while you're logged in
start powershell -file "C:\23jrg\Quantum-Impeller\tools\Lock_on_mouse_movement.ps1"

REM A series of powershell commands that suspends bitlocker, keeps the screen awake, disables the mouse until reboot (or reseat) then launches chkdsk, sfc, dism, Windows Update, and finally a reboot
start /max powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 3;Caffeine -replace;foreach ($dev in (Get-PnpDevice | Where-Object{$_.Class -eq 'Mouse'})) {&'pnputil' /remove-device $dev.InstanceId};Start-Process cmd.exe -ArgumentList '/c chkdsk /scan /perf' -NoNewWindow -Wait;Start-Process cmd.exe -ArgumentList '/c sfc /scannow' -NoNewWindow -Wait;Start-Process cmd.exe -ArgumentList '/c dism /online /cleanup-image /restorehealth' -NoNewWindow -Wait;$RepairPack = Get-TroubleshootingPack -Path C:\Windows\diagnostics\system\WindowsUpdate;Invoke-TroubleshootingPack -Pack $RepairPack -Unattended;Install-Module PSWindowsUpdate -Force;Import-Module PSWindowsUpdate;Get-WindowsUpdate -Install -AcceptAll -AutoReboot;shutdown -r -t 1"
