goto :COMMENT_BLOCK
.SYNOPSIS 
This script is a shortcut to winutil

.DESCRIPTION 
winutil is a very powerful admin windows capable of advanced features

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 10/11 workstations; single computer
Requires: Local Admin
Rollback: you can close the winutil window
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Powershell command to suspend bitlocker, then install updates and reboot
powershell -Command "irm "https://christitus.com/win" | iex"
