. C:\23jrg\Winutil\functions\public\Invoke-WPFFixesUpdate.ps1; Invoke-WPFFixesUpdate

. C:\23jrg\Winutil\functions\public\Invoke-WPFSystemRepair.ps1; Invoke-WPFSystemRepair

Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate;Install-WindowsUpdate -AcceptAll

Remove-Item -Path "C:\23jrg" -Force -Recurse; winget uninstall git.git --accept-source-agreements --all --silent --force --nowarn;schtasks.exe /delete /f /TN Quantum-Cleanup;
#Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-Item $PSCommandPath -Force


