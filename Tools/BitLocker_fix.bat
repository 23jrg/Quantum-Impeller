REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

REM A series ov powershell commands that repairs known failurepoints for bitlocker, can repair the FIPS check error
powershell -Command "Suspend-BitLocker -MountPoint 'C:' -RebootCount 1;Remove-Item -Path 'C:\Windows\System32\GroupPolicyUsers' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\GroupPolicy' -Force -Recurse;Remove-Item -Path 'C:\Windows\System32\Recovery\ReAgent.xml' -Force;gpupdate /force;shutdown -r -t 1"
