# Load the required .NET assembly to track cursor positions
Add-Type -AssemblyName System.Windows.Forms

# Define the Windows API signature to lock the workstation
$signature = '[DllImport("user32.dll", SetLastError = true)] public static extern bool LockWorkStation();'
$logon32 = Add-Type -MemberDefinition $signature -Name "Win32Lock" -Namespace "Win32Api" -PassThru

# Give the user a 5-second countdown to hands-off the mouse before armed
Write-Host "Arming lock mechanism. Please stop moving your mouse..." -ForegroundColor Yellow
for ($i = 5; $i -gt 0; $i--) {
    Write-Host "$i..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Capture the initial static coordinates of the cursor
$initialPosition = [System.Windows.Forms.Cursor]::Position
Write-Host "System ARMED. If the mouse moves from $initialPosition, the PC will lock." -ForegroundColor Red

# Continuously monitor coordinates
while ($true) {
    $currentPosition = [System.Windows.Forms.Cursor]::Position
    
    # Check if X or Y coordinates differ from the initial setup
    if ($currentPosition.X -ne $initialPosition.X -or $currentPosition.Y -ne $initialPosition.Y) {
        Write-Host "Movement detected! Locking computer..." -ForegroundColor DarkRed
        [Win32Api.Win32Lock]::LockWorkStation() | Out-Null
        break
    }
    
    # Check 10 times a second to catch sudden movements
    Start-Sleep -Milliseconds 100
}