FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;caffeine -replace;curl -o C:\23jrg\Quantum-Impeller\tools\tron 'https://www.dropbox.com/scl/fo/prrk0mely19rjp9wzqojl/APtqiavYg_8v98lLIVmNb38?rlkey=ogk1k9i0u6kfmmvvn35jskgvw&st=85s2zz34&dl=1';C:\23jrg\Quantum-Impeller\tools\tron\tron.bat;Remove-Item $PSCommandPath -Force;"
