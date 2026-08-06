goto :COMMENT_BLOCK
.SYNOPSIS 
For when there's time drift

.DESCRIPTION 
This script sets timezone to EST and syncs

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Local Admin
Rollback: Time can be changed in settings
AI-assisted: no

.CHANGELOG
V1.0 2026-08-06 23jrg Release
:COMMENT_BLOCK

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

tzutil.exe /s "Eastern Standard Time"

w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"&&w32tm /resync
