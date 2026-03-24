@echo off
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
