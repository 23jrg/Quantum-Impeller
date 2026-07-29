<#
.SYNOPSIS 
This script plays music

.DESCRIPTION 
This script downloads loading music and begins playing it, can be used on it's own but primarily intended for other scripts to call and play it while they're running

.PARAMETER
No parameters are accepted as this is a manual tool rather than run on a schedule

.NOTES
Author: 23jrg
Created: 2026
Ticket: General ticket
Risk tier: Low
Targets: Windows 7/10/11 workstations; single computer
Requires: Nothing needed
Rollback: Not required
AI-assisted: no

.CHANGELOG
V1.0 2025-07-29 23jrg Complience update
#>

#Checks if the .mp3 file already exists, if it doesn't then it pulls a copy from dropbox
if (-not (Test-Path -Path "C:\23jrg\Music.mp3")) 
{
curl -o C:\23jrg\Music.mp3 "https://www.dropbox.com/scl/fi/m52r1moitb7yphnor7877/Metal-Gear-Rising-Revengeance-The-Original-Gamerip-Soundtrack-N1uxIEIwn_k.mp3?rlkey=3srk5evv2pclo5jccomohmceg&st=78o13loo&dl=1"
}

#Spawns a music player and asks it to open the .mp3
Add-Type -AssemblyName presentationCore
$player = New-Object system.windows.media.mediaplayer
$player.Open("C:\23jrg\Music.mp3")

#Wait for the media to buffer and open properly
Write-Host "Buffering..."
while ($player.NaturalDuration.HasTimeSpan -eq $false) {
    Start-Sleep -Milliseconds 200
}

#Play the file and monitor progress
$player.Play()
Write-Host "Playing music. Press any key to stop..."

#Loop safe from "Automatic" type conversion errors
while ($player.Position -lt $player.NaturalDuration.TimeSpan) {
    if ([Console]::KeyAvailable) { break }
    Start-Sleep -Seconds 1
}

$player.Stop()
$player.Close()
