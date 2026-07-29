goto :COMMENT_BLOCK
.SYNOPSIS 
This script updates most if not all applications

.DESCRIPTION 
This script updates all applications that are registered in the winget repository

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 10/11 workstations; single computer
Requires: Local Admin
Rollback: applications can be downgraded individually if needed
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM Simple powershell command to update all applications in the winget repository
powershell -Command "winget upgrade --all --silent --include-unknown"
