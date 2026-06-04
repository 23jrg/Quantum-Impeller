#. C:\23jrg\Winutil\functions\public\Invoke-WPFFixesUpdate.ps1; Invoke-WPFFixesUpdate

#. C:\23jrg\Winutil\functions\public\Invoke-WPFSystemRepair.ps1; Invoke-WPFSystemRepair

chkdsk /scan /perf;sfc /scannow;dism /online /cleanup-image /restorehealth;

Install-Module PSWindowsUpdate -Force;Import-Module PSWindowsUpdate;Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot

winget uninstall git.git --accept-source-agreements --all --silent --force --nowarn;#schtasks.exe /delete /f /TN Quantum-Clipper;

[System.IO.File]::WriteAllText(
        'C:\23jrg\Quantum-Impeller\user_id.txt',
        ([System.IO.File]::ReadAllText('C:\23jrg\Quantum-Impeller\user_id.txt') -replace '\s')
    )


$user_id =  get-content "C:\23jrg\Quantum-Impeller\user_id.txt"

logoff (get-content "C:\23jrg\Quantum-Impeller\session_id.txt");

Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-MpPreference -ExclusionPath "C:\24jrg";

$ErrorActionPreference = 'Stop'

Remove-Item -Path "C:\Users\$user_id\desktop\TechTools.lnk" -Force; 

Remove-Item -Path "C:\24jrg.zip" -Force -Recurse;

$PSNativeCommandUseErrorActionPreference = $true

Remove-Item -Path "C:\23jrg" -Force -Recurse;

schtasks.exe /delete /f /TN Quantum-Cleanup;
Remove-Item $PSCommandPath -Force



