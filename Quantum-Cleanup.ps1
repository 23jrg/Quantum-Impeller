Remove-Item -Path "C:\23jrg" -Force -Recurse; winget uninstall git.git;schtasks.exe /delete /f /TN Quantum-Cleanup;
Remove-Item $PSCommandPath -Force