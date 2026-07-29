<#
.SYNOPSIS 
Script to be ran before Music.ps1 to ensure that the volume is just barely audible

.DESCRIPTION 
Script to set volume to 12

.PARAMETER
No parameters are accepted as this is a manual tool rather than run on a schedule

.NOTES
Author: 23jrg
Created: 2025
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Nothing
Rollback: The volume can be re-adjusted with the volume buttons
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
#>


$obj = New-Object -ComObject WScript.Shell

# First, mute then unmute to reset, or just turn down 50 times (each tick is 2%)
# to ensure we start at 0% volume.
for ($i = 0; $i -lt 50; $i++) {
    $obj.SendKeys([char]174) # 174 is the Virtual Key Code for Volume Down
}

# Now increase by one "tick" (approx 10%)
#$obj.SendKeys([char]175) # 175 is the Virtual Key Code for Volume Up

for ($o = 0; $o -lt 5; $o++) {
    $obj.SendKeys([char]175) # 174 is the Virtual Key Code for Volume Down
}
