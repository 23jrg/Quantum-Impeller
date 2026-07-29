goto :COMMENT_BLOCK
.SYNOPSIS 
This script repairs bitlocker

.DESCRIPTION 
This script runs common bitlocker repairs to try to resolve encryption issues like FIPS complience errors

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 10/11 workstations; single computer
Requires: Local Admin
Rollback: Unneeded
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM A series ov powershell commands that repairs known failurepoints for bitlocker, can repair the FIPS check error
powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Remove-Item -Path 'C:\Windows\System32\GroupPolicyUsers' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\GroupPolicy' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\Recovery\ReAgent.xml' -Force;gpupdate /force;shutdown -r -t 1"
