# This script imports OVPN files into Open VPN, using the username as the matching variable for the correct file.
# This script relies that username.ovpn files are going to be on the root folder of the Win32 App.
# App_
#     ├ automateOvpnImportByUsername.ps1
#     ├ user1.ovpn
#     ├ user2.ovpn
#     └ {...}.opvn
#      

function Get-UsernameFromSystem {
    $userFull = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
    if (-not $userFull) {
        Write-Error "Could not retrieve username"
        return $null
    }
    $user = $userFull -replace '^.*[\\|]', ''
    if ($user -like '*@*') {
        $user = $user.Split('@')[0]
    }

    return $user
}

$userName = Get-UsernameFromSystem
if (-not $userName) {
    exit 1
}

$sourceFile = "$userName.ovpn"
$destDir = "$env:ProgramData\OpenVPN Connect\profiles"
$destFile = Join-Path $destDir $sourceFile

if (-not (Test-Path $destDir)) {
    New-Item -Path $destDir -ItemType Directory -Force | Out-Null
}

if (Test-Path $sourceFile) {
    Copy-Item -Path $sourceFile -Destination $destFile -Force
    exit 0
} else {
    exit 1
}