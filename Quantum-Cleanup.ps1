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

# Gets rid of any defender AV exclusions the script made
Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-MpPreference -ExclusionPath "C:\24jrg";

# Removes the techtools shortcut from the desktop of the person who ran it
Remove-Item -Path "C:\Users\$user_id\desktop\TechTools.lnk" -Force; 

# Removes the .zip file which was used for transferring the impeller to the computer
Remove-Item -Path "C:\24jrg.zip" -Force -Recurse;

# Requests the script to immediately stop if an error occurs, it will try again later if an error occurs
$ErrorActionPreference = 'Stop'

# Enforces the script to immediately stop if an error occurs, it will try again later if an error occurs
$PSNativeCommandUseErrorActionPreference = $true

# Removes the main impeller folder
Remove-Item -Path "C:\23jrg" -Force -Recurse;

# Removes the scheduled task responsible for retrying this script if it fails
schtasks.exe /delete /f /TN Quantum-Cleanup;

# Removes this script
Remove-Item $PSCommandPath -Force



