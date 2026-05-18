FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Caffeine -replace;Start-Process cmd.exe -ArgumentList '/c chkdsk /scan /perf' -NoNewWindow -Wait;Start-Process cmd.exe -ArgumentList '/c sfc /scannow' -NoNewWindow -Wait;Start-Process cmd.exe -ArgumentList '/c dism /online /cleanup-image /restorehealth' -NoNewWindow -Wait;Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate -Install -AcceptAll -AutoReboot;shutdown -r -t 1;"
