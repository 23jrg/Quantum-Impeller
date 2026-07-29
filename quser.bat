goto :COMMENT_BLOCK
.SYNOPSIS 
This script retrieves the user id for the person who first ran the impeller

.DESCRIPTION 
This script retrieves the user id for the person who first ran the impeller, required in order to target their account for logoff while leaving any other users alone
Logoff needed to stop the computer from using the impeller files, allowing them to be removed by the cleanup script

.PARAMETER
No parameters are accepted

.NOTES
Author: 23jrg
Created: 2025
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Nothing
Rollback: The technician can log back in again
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
:COMMENT_BLOCK

@echo off
echo %USERNAME% > "C:\23jrg\Quantum-Impeller\user_id.txt"
set OUTPUT=C:\23jrg\Quantum-Impeller\session_id.txt

> %OUTPUT% (
    for /f "skip=1 tokens=2,3" %%A in ('quser') do (
        if "%%B"=="" (
            echo %%A
        ) else (
            echo %%B
        )
    )
)

echo Session ID(s) saved to %OUTPUT%
TIMEOUT /T 3
