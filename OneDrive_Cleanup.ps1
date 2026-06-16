# Get the username of the currently logged-in user
$CurrentUser = $env:USERNAME

# Define system/default profiles to completely skip
$ExcludedProfiles = @("Public", "Default", "Default User", "All Users")

# Fetch all local user folder paths from the registry to ensure accuracy
$UserProfiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" |
                Select-Object -ExpandProperty ProfileImagePath

foreach ($ProfilePath in $UserProfiles) {
    # Extract the actual folder name (username) from the path
    $ProfileName = Split-Path $ProfilePath -Leaf

    # Skip the current user and standard Windows default/system profiles
    if ($ProfileName -eq $CurrentUser -or $ExcludedProfiles -contains $ProfileName) {
        continue
    }

    # Build potential paths for OneDrive folders (Commercial vs. Personal)
    $OneDrivePaths = @(
        (Join-Path $ProfilePath "OneDrive"),
        (Get-ChildItem -Path $ProfilePath -Filter "OneDrive - *" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    )

    foreach ($Path in $OneDrivePaths) {
        # Ensure the directory exists before checking contents
        if ($Path -and (Test-Path -Path $Path)) {
            
            # Look for any files (excluding folders themselves) deeply nested within the OneDrive directory
            $HasFiles = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1

            if ($HasFiles) {
                Write-Host "Found local OneDrive files for another user ($ProfileName) at: $Path" -ForegroundColor Yellow
                Write-Host "Exiting script immediately." -ForegroundColor Red
                Exit
            }
        }
    }
}

Write-Host "No files found in other users' local OneDrive directories. Continuing script execution..." -ForegroundColor Green

irm asheroto.com/uninstallonedrive | iex
