# Open Windows Recovery Settings
Start-Process "ms-settings:recovery"

# Wait for the window to appear
Start-Sleep -Seconds 8

# Load UI Automation assemblies
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

$TargetText = "Reinstall now"

# Get the desktop root
$Root = [System.Windows.Automation.AutomationElement]::RootElement

# Find the Settings window
$WindowCondition = New-Object System.Windows.Automation.OrCondition(
    (New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ClassNameProperty,
        "ApplicationFrameWindow"
    )),
    (New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::NameProperty,
        "Settings"
    ))
)

$SettingsWindow = $null

for ($i = 0; $i -lt 20; $i++) {
    $SettingsWindow = $Root.FindFirst(
        [System.Windows.Automation.TreeScope]::Children,
        $WindowCondition
    )

    if ($SettingsWindow) {
        break
    }

    Start-Sleep -Milliseconds 500
}

if (-not $SettingsWindow) {
    Write-Error "Could not locate the Settings window."
    exit
}

Write-Host "Settings window found." -ForegroundColor Green

# Search for the button
$ButtonCondition = New-Object System.Windows.Automation.AndCondition(
    (New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Button
    )),
    (New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::NameProperty,
        $TargetText
    ))
)

$Button = $SettingsWindow.FindFirst(
    [System.Windows.Automation.TreeScope]::Descendants,
    $ButtonCondition
)

if ($Button) {

    Write-Host "Found '$TargetText'." -ForegroundColor Green

    $Invoke = $null

    if ($Button.TryGetCurrentPattern(
        [System.Windows.Automation.InvokePattern]::Pattern,
        [ref]$Invoke
    )) {

        Write-Host "Invoking button..."
        $Invoke.Invoke()
        Write-Host "Done." -ForegroundColor Green

    } else {

        Write-Warning "InvokePattern not supported. Attempting mouse click..."

        $Bounds = $Button.Current.BoundingRectangle

        $X = [int]($Bounds.X + ($Bounds.Width / 2))
        $Y = [int]($Bounds.Y + ($Bounds.Height / 2))

        Add-Type -AssemblyName System.Windows.Forms

        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)

        Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Mouse {
    [DllImport("user32.dll")]
    public static extern void mouse_event(int flags,int dx,int dy,int buttons,int extra);
}
"@

        [Mouse]::mouse_event(0x02,0,0,0,0)
        [Mouse]::mouse_event(0x04,0,0,0,0)

        Write-Host "Mouse clicked at ($X,$Y)." -ForegroundColor Yellow
    }

}
else {

    Write-Warning "Button '$TargetText' not found."

    Write-Host ""
    Write-Host "Available automation elements:"
    Write-Host "--------------------------------"

    $All = $SettingsWindow.FindAll(
        [System.Windows.Automation.TreeScope]::Descendants,
        [System.Windows.Automation.Condition]::TrueCondition
    )

    foreach ($Item in $All) {

        $Name = $Item.Current.Name
        $Type = $Item.Current.ControlType.ProgrammaticName

        if ($Name) {
            Write-Host "$Type : $Name"
        }
    }
}

# Wait for an OK button to appear
Write-Host "Waiting for OK button..."

$OKButton = $null

for ($i = 0; $i -lt 30; $i++) {

    Start-Sleep -Seconds 1

    $OKCondition = New-Object System.Windows.Automation.AndCondition(
        (New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
            [System.Windows.Automation.ControlType]::Button
        )),
        (New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::NameProperty,
            "OK"
        ))
    )

    $OKButton = $Root.FindFirst(
        [System.Windows.Automation.TreeScope]::Descendants,
        $OKCondition
    )

    if ($OKButton) {
        break
    }
}

if ($OKButton) {

    Write-Host "OK button found."
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait(" ")

Start-Sleep -Seconds 8

    $Invoke = $null

    if ($OKButton.TryGetCurrentPattern(
        [System.Windows.Automation.InvokePattern]::Pattern,
        [ref]$Invoke
    )) {

        $Invoke.Invoke()
        Write-Host "OK clicked." -ForegroundColor Green

    } else {

        Write-Warning "InvokePattern not supported. Clicking with mouse..."

        $Bounds = $OKButton.Current.BoundingRectangle
        $X = [int]($Bounds.X + ($Bounds.Width / 2))
        $Y = [int]($Bounds.Y + ($Bounds.Height / 2))

        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)

        [Mouse]::mouse_event(0x02,0,0,0,0)
        [Mouse]::mouse_event(0x04,0,0,0,0)

        Write-Host "OK clicked with mouse."
    }

} else {

    Write-Warning "Timed out waiting for the OK button."
}

(New-Object -ComObject Shell.Application).MinimizeAll()
