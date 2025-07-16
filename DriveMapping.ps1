function Set-DriveMapping {
    param (
        [string]$letter,
        [string]$resource,
        [string]$fallback
    )

    $driveID = "$letter:"
    $mappedDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 4 }

    # Caso 1: Disco $letter esta mapeado y apunta a $resource.
    $case1 = $mappedDrives | Where-Object { $_.DeviceID -eq $driveID -and $_.ProviderName -eq $resource }

    # Caso 2: Existe otro disco que apunta a $resource pero no esta usando $letter.
    $case2 = $mappedDrives | Where-Object { $_.DeviceID -ne $driveID -and $_.ProviderName -eq $resource }

    # Caso 3: Disco $letter esta en uso, y no hay ningun disco que apunta a $resource.
    $case3 = ($mappedDrives | Where-Object { $_.DeviceID -eq $driveID }) -and
             -not ($mappedDrives | Where-Object { $_.ProviderName -eq $resource })

    # Caso 4: $letter no esta en uso y  $resource no esta mapeado.
    $case4 = -not ($mappedDrives | Where-Object { $_.DeviceID -eq $driveID }) -and
             -not ($mappedDrives | Where-Object { $_.ProviderName -eq $resource })

    if ($case1) {
        exit 0
    }
    elseif ($case2) {
        # TODO
    }
    elseif ($case3) {
        if ($letter -ne $fallback) {
            $newLetter = $fallback
            Set-DriveMapping -letter $newLetter -resource $resource -fallback $newLetter
        }else{
            exit 1
        }
    }
    elseif ($case4) {
        try {
            New-PSDrive -Name $letter -PSProvider FileSystem -Root $resource -Persist -ErrorAction Stop
            exit 0
        } catch {
            exit 1
        }
    }
}

#=========USO===========
$driveLetter = "Z"
$fallbackLetter = "ZA"
$networkResource = "\\server\share"

Set-DriveMapping -letter $driveLetter -resource $networkResource -fallback $fallbackLetter