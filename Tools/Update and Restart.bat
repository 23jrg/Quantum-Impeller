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

REM Change Windows registry keys for a more aggressive update
start /wait powershell -Command "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "AllowMUUpdateService" -Value 1;Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "RestartNotificationsAllowed2" -Value 1;Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "IsExpedited" -Value 1;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 0;exit"

REM Powershell command to suspend bitlocker, then install updates and reboot
powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate -Install -AcceptAll -AutoReboot;shutdown -r -t 1"
