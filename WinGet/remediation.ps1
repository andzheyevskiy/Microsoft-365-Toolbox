$AppID = "Microsoft.Edge"

Set-Location -Path ("$env:ProgramW6432\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe")
.\winget.exe upgrade --exact --id $AppID --silent --accept-package-agreements --accept-source-agreements