REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Simple powershell command to update all applications in the winget repository
powershell -Command "winget upgrade --all --silent --include-unknown"
