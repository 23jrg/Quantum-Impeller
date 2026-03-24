#. C:\23jrg\Winutil\functions\public\Invoke-WPFFixesUpdate.ps1; Invoke-WPFFixesUpdate

. C:\23jrg\Winutil\functions\public\Invoke-WPFSystemRepair.ps1; Invoke-WPFSystemRepair

Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate;Install-WindowsUpdate -AcceptAll

winget uninstall git.git --accept-source-agreements --all --silent --force --nowarn;schtasks.exe /delete /f /TN Quantum-Clipper;

logoff (get-content "C:\23jrg\Quantum-Impeller\session_id.txt");

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

Remove-Item -Path "C:\23jrg" -Force -Recurse; 

schtasks.exe /delete /f /TN Quantum-Cleanup;
#Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-Item $PSCommandPath -Force



