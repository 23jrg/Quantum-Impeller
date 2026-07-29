<#
.SYNOPSIS 
The Impeller leaves behind some files, this script cleans them up

.DESCRIPTION 
This script removes leftover files and runs heavier repair processes after the computer locks, these heavier repair processes have a significant impact on performance
so scheduling them to run when the computer is not in use is optimal

.PARAMETER
No parameters are accepted as this is a cleanup utility

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Nothing
Rollback: The Impeller can be re-ran if needed
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
#>

# Repair routines to be run before residual impeller files are removed, 
chkdsk /scan /perf;sfc /scannow;dism /online /cleanup-image /restorehealth;

# Runs windows updates
Install-Module PSWindowsUpdate -Force;Import-Module PSWindowsUpdate;Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

# Reformates the txt file that stores the user data for who ran the impeller
[System.IO.File]::WriteAllText(
        'C:\23jrg\Quantum-Impeller\user_id.txt',
        ([System.IO.File]::ReadAllText('C:\23jrg\Quantum-Impeller\user_id.txt') -replace '\s')
    )

# Grabs the user ID for the person who ran the impeller
$user_id =  get-content "C:\23jrg\Quantum-Impeller\user_id.txt"

# Logs off the person who ran the impeller
logoff (get-content "C:\23jrg\Quantum-Impeller\session_id.txt");

# Removes the techtools shortcut from the desktop of the person who ran it
Remove-Item -Path "C:\Users\$user_id\desktop\TechTools.lnk" -Force; 

# Removes the .zip file which was used for transferring the impeller to the computer
Remove-Item -Path "C:\24jrg.zip" -Force -Recurse;

# Gets rid of any defender AV exclusions the script made
Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-MpPreference -ExclusionPath "C:\24jrg";

# Requests the script to immediately stop if an error occurs, it will try again later if an error occurs
$ErrorActionPreference = 'Stop'

# Enforces the script to immediately stop if an error occurs, it will try again later if an error occurs
$PSNativeCommandUseErrorActionPreference = $true

# Removes the main impeller folder
Remove-Item -Path "C:\23jrg" -Force -Recurse;

# Revert ExecutionPolicy changes
Set-ExecutionPolicy Default -force

# Removes the scheduled task responsible for retrying this script if it fails
schtasks.exe /delete /f /TN Quantum-Cleanup;

# Removes this script
Remove-Item $PSCommandPath -Force



