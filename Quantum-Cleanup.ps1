Install-Module PSWindowsUpdate -Force;Get-WindowsUpdate;Install-WindowsUpdate -AcceptAll
Remove-Item -Path "C:\23jrg" -Force -Recurse; winget uninstall git.git --force;schtasks.exe /delete /f /TN Quantum-Cleanup;
Remove-MpPreference -ExclusionPath "C:\23jrg";
Remove-Item $PSCommandPath -Force



