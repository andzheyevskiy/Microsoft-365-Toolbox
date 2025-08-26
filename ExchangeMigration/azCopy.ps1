$origin = "\\FileServer\PSTs\\"  
$destination = "" 
$errorLog = "$origin\error.txt" 

$azCopyPath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe"


$pstFiles = Get-ChildItem -Path $origin -Filter *.pst -File

foreach ($file in $pstFiles) {
    $sourceFile = $file.FullName
    $targetUrl = "$destination/$($file.Name)"

    $azCommand = "`"$azCopyPath`" copy `"$sourceFile`" `"$targetUrl`" --overwrite=true --log-level=ERROR"

    try {
        Invoke-Expression $azCommand | Out-Null
    } catch {
        Add-Content -Path $errorLog -Value $file.Name
    }
}
