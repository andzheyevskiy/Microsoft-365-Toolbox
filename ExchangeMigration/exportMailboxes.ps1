# Required Roles
# New-ManagementRoleAssignment –Role "Mailbox Import Export" –User "Administrator"

$OU = "OU=OrganizationUnit,DC=yourdomain,DC=com"
$destination = "\\FileServer\PSTs\\"
$errorLog = "${destination}error.txt"
$mappingFile = "${destination}mapping.csv"
$recentMonths = 6
$thresholdBytes = 50GB

if (-not (Test-Path $errorLog)) {
    New-Item -Path $errorLog -ItemType File -Force | Out-Null
}

"Workload,FilePath,Name,Mailbox,IsArchive" | Out-File -FilePath $mappingFile -Encoding UTF8

$users = Get-User -OrganizationalUnit $OU | Where-Object { Get-Mailbox $_.Identity -ErrorAction SilentlyContinue }

foreach ($user in $users) {
    $username = $user.SamAccountName
    $mailbox = Get-Mailbox $username

    if ($mailbox) {
        try {
            $stats = Get-MailboxStatistics -Identity $username
            $sizeBytes = $stats.TotalItemSize.Value.ToBytes()

            # Depending on the size the files will be split or not.
            if ($sizeBytes -gt $thresholdBytes) {
                $recentPath = "$destination$($username)_recent.pst"
                $archivePath = "$destination$($username)_archive.pst"

                New-MailboxExportRequest -Mailbox $username `
                    -ContentFilter {(Received -ge (Get-Date).AddMonths(-$recentMonths))} `
                    -FilePath $recentPath

                New-MailboxExportRequest -Mailbox $username `
                    -ContentFilter {(Received -le (Get-Date).AddMonths(-$recentMonths))} `
                    -FilePath $archivePath

                Add-Content -Path $mappingFile -Value "Exchange,$($username)_recent.pst,$($username),$($mailbox.PrimarySmtpAddress),False"
                Add-Content -Path $mappingFile -Value "Exchange,$($username)_archive.pst,$($username),$($mailbox.PrimarySmtpAddress),True"
            }
            else {
                # Single export
                $exportPath = "$destination$($username).pst"
                New-MailboxExportRequest -Mailbox $username -FilePath $exportPath
                Add-Content -Path $mappingFile -Value "Exchange,$($username).pst,$($username),$($mailbox.PrimarySmtpAddress),False"
            }
        } catch {
            Add-Content -Path $errorLog -Value "$username: $($_.Exception.Message)`n"
        }
    } else {
        Add-Content -Path $errorLog -Value "$username: No mailbox found`n"
    }
}
