REM Cleans up system files
start /wait powershell "net stop wuauserv;net stop bits"
start /wait powershell "Remove-Item $env:SystemRoot\SoftwareDistribution\* -Recurse -Force -Verbose -ErrorAction SilentlyContinue"
start /wait powershell "Remove-Item -Path "$env:TEMP\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue"
start /wait powershell "Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue"
start powershell "net start wuauserv;net start bits"

REM Checks all the disk cleanup options and runs disk cleanup
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Windows Error Reporting Archive" -Name "StateFlags0001" -Value 2 -ErrorAction SilentlyContinue"
start /wait powershell "Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait"


REM Enable Storage Sense
start /wait powershell "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name "01" -Type DWord -Value 1"

REM Storage space run only when full disk
start /wait powershell "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name "2048" -Type DWord -Value 0"

REM Clear items out of recycling bin if they've been there for 30 days
start /wait powershell "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name "08" -Type DWord -Value 0"

REM Cleanup temporary files
start /wait powershell "Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name "04" -Type DWord -Value 1"


