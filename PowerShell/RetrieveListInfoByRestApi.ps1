$credential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

$uri = "https://interestec.sharepoint.com/_api/web/lists/getByTitle('customlist1')"
$method = "GET"
$contentType = "application/json;odata=verbose"

$headers = @{
    "Accept" = "application/json;odata=verbose"
}

$body = @{
}

$bodyJson = ConvertTo-Json -InputObject $body -Compress
#Invoke-WebRequest -Uri $uri -Method $method -Headers $headers -ContentType $contentType -Body $bodyJson -Credential $credential
Invoke-WebRequest -Uri $uri -Method $method -Headers $headers -ContentType $contentType -Credential $credential
