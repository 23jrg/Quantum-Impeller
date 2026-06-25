# Load User32.dll for native mouse tracking
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseUtils {
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);
}
"@

function Get-MousePosition {
    $point = New-Object MouseUtils+POINT
    [MouseUtils]::GetCursorPos([ref]$point) | Out-Null
    return $point
}

$threshold = 10      # Movement tolerance in pixels to account for minor jitter
$intervalMs = 100    # How often to check coordinates (in milliseconds)
$durationMs = 250   # The target duration of movement (1 second)
$checksRequired = [Math]::Ceiling($durationMs / $intervalMs)
$signature = '[DllImport("user32.dll", SetLastError = true)] public static extern bool LockWorkStation();'
$logon32 = Add-Type -MemberDefinition $signature -Name "Win32Lock" -Namespace "Win32Api" -PassThru

# Give the user a 5-second countdown to hands-off the mouse before armed
Write-Host "Arming lock mechanism. Please stop moving your mouse..." -ForegroundColor Yellow
for ($i = 5; $i -gt 0; $i--) {
    Write-Host "$i..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Capture the initial static coordinates of the cursor
# $initialPosition = [System.Windows.Forms.Cursor]::Position
Write-Host "System ARMED. If the mouse moves from $initialPosition, the PC will lock." -ForegroundColor Red
Write-Host "---------------------------------------------------"
Write-Host "Monitoring mouse movement... (Press Ctrl+C to stop)"


$movementCount = 0
$lastPos = Get-MousePosition

while ($true) {
    Start-Sleep -Milliseconds $intervalMs
    $currentPos = Get-MousePosition

    # Calculate the distance moved using a^2 + b^2 = c^2
    $dx = [Math]::Abs($currentPos.X - $lastPos.X)
    $dy = [Math]::Abs($currentPos.Y - $lastPos.Y)
    $distance = [Math]::Sqrt(($dx * $dx) + ($dy * $dy))

    if ($distance -gt $threshold) {
        $movementCount++
        if ($movementCount -ge $checksRequired) {
            Write-Host "-> Mouse has been moving for over a second!" -ForegroundColor Red
			[Win32Api.Win32Lock]::LockWorkStation() | Out-Null
			exit
            # Reset the counter so it doesn't trigger repeatedly on the same movement
            $movementCount = 0 
        }
    } else {
        # Reset if the mouse stops or the user pauses
        $movementCount = 0
    }

    $lastPos = $currentPos
}
