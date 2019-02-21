$credential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

$uri = "https://interestec.sharepoint.com/sites/seminar/_api/web/lists/getByTitle('SeminarEntry')"
$method = "GET"
$contentType = "application/json;odata=verbose"

$headers = @{
    "Accept" = "application/json;odata=verbose"
}

$body = @{
}

$bodyJson = ConvertTo-Json -InputObject $body -Compress

try {
    if ($method -eq "GET") {
        Invoke-WebRequest -Uri $uri -Method $method -Headers $headers -ContentType $contentType -Credential $credential    
    } else {
        Invoke-WebRequest -Uri $uri -Method $method -Headers $headers -ContentType $contentType -Credential $credential -Body $bodyJson
    }
} catch [System.Net.WebException] {
    Write-Host "áO­ś"
    Write-Host $error

    $stream = New-Object -TypeName System.IO.StreamReader $_.Exception.Response.GetResponseStream()

    Write-Host $stream.ReadToEnd()
}
