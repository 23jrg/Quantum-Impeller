goto :COMMENT_BLOCK
.SYNOPSIS 
This script repairs office

.DESCRIPTION 
This script performs a full online re-install of office that fixes most stubborn issues

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Local Admin
Rollback: Office can be uninstalled if needed
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Office Repair Command
"C:\Program Files\Common Files\microsoft shared\ClickToRun\OfficeClickToRun.exe" scenario=Repair platform=x64 culture=en-us forceappshutdown=True RepairType=FullRepair DisplayLevel=True
