goto :COMMENT_BLOCK
.SYNOPSIS 
This script performs a loading animation accompanied by music

.DESCRIPTION 
This script This script performs a loading animation accompanied by music, to be used manually or triggered by longer running scripts

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2025
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Local Admin
Rollback: The files downloaded will be cleared when the Impeller does
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Volume.ps1" && start PowerShell -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\23jrg\Quantum-Impeller\Music.ps1" && start cmd /k "color 2 && curl ascii.live/knot" && exit
