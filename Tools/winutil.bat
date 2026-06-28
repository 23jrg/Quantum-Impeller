REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Powershell command to suspend bitlocker, then install updates and reboot
powershell -Command "irm "https://christitus.com/win" | iex"
