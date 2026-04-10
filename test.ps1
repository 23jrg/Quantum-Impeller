#Profile Customization
if ($env:USERNAME -eq "jgraham" -or "Administrator" -or -"CISTECH") {
Write-Host "jgraham" -ForegroundColor Cyan
Write-Host $env:USERNAME -ForegroundColor Cyan

}
Write-Host "End script" -ForegroundColor Cyan
