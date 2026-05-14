FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

powershell -Command "Remove-Item -Path 'C:\Windows\System32\GroupPolicyUsers' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\GroupPolicy' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\Recovery\ReAgent.xml' -Force;gpupdate /force;shutdown -r -t 1"