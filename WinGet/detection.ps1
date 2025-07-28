$AppID = "Microsoft.Edge"

Set-Location -Path ("$env:ProgramW6432\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe")
$updateAvailable = .\winget.exe list --exact --id $AppID --accept-source-agreements --upgrade-available
if ($updateAvailable[-1].Trim() -eq "1 upgrades available.") {
    exit 1
} else {
    exit 0
}