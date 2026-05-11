FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate -Install -AcceptAll -AutoReboot"
