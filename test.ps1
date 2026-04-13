#Profile Customization start__________________________________________________________________________________________________________________________________
if ($env:USERNAME -eq "jgraham" -or $env:USERNAME -eq "Administrator" -or $env:USERNAME -eq "CISTECH") {

$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "DarkYellow"
$url = "https://images4.alphacoders.com/101/1014815.png"
$localPath = "$env:USERPROFILE\Pictures\online_wallpaper.jpg"

Invoke-WebRequest -Uri $url -OutFile $localPath

if (!(Test-Path $cspPath)) {
    New-Item -Path $cspPath -Force | Out-Null
}

# 3. Define the C# code to call the Windows API for an instant update
$code = @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

Add the type and apply the wallpaper
Add-Type -TypeDefinition $code -Language CSharp
[Wallpaper]::SystemParametersInfo(20, 0, $localPath, 3)

$RegKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

#Set Apps to Dark
Set-ItemProperty -Path $RegKeyPath -Name "AppsUseLightTheme" -Value 0 -Type Dword -Force

#Set System to Dark
Set-ItemProperty -Path $RegKeyPath -Name "SystemUsesLightTheme" -Value 0 -Type Dword -Force

Write-Host "Dark Mode Set Successfully"

#Define the Yellow accent color in hex (AABBGGRR format for registry)
$yellowHex = 0xFF009AC4

#Update Registry for Personalization Colors
$registryPath = "HKCU:\Software\Microsoft\Windows\DWM"
Set-ItemProperty -Path $registryPath -Name "AccentColor" -Value $yellowHex
Set-ItemProperty -Path $registryPath -Name "ColorPrevalence" -Value 1

#Update User Personalization for the "Yellow" theme color
$personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
Set-ItemProperty -Path $personalizePath -Name "AccentColorMenu" -Value $yellowHex

#Hide Widgets
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UCPD" -Name "Start" -Value 4
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0

#Turn off taskview
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0

#Hide Searchbar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

#Kill onedrive
taskkill /f /im OneDrive.exe

#Unpin everything from the taskbar
$appsToUnpin = @("Microsoft Store", "Mail", "Calculator", "Microsoft Edge", "Copilot", "Microsoft 365 Copilot", "Outlook", "Outlook (New)")
$shell = New-Object -Com Shell.Application
$taskbarItems = $shell.NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
foreach ($appname in $appsToUnpin) {
    $item = $taskbarItems | Where-Object { $_.Name -eq $appname }
    if ($item) {
        $item.Verbs() | Where-Object { $_.Name.Replace("&", "") -match "Unpin from taskbar" } | ForEach-Object { $_.DoIt() }
        Write-Host "Unpinned: $appname"
    }
}

# Refresh the explorer process to apply changes without logging out
Stop-Process -Name explorer -Force
    
} 
#Profile Customization end___________________________________________________________________________________________________________________________________
