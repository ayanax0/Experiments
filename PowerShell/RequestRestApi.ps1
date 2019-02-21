$credential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

$uri = "https://interestec.sharepoint.com/_api/web/lists"
$method = "POST"
$contentType = "application/json;odata=verbose"

$headers = @{
    "ACCEPT" = "application/json;odata=verbose"
}

$body = @{
    "__metadata" = @{
        "type" = "SP.List"
    }
    "AllowContentTypes" = "true"
    "BaseTemplate" = "100"
    "ContentTypesEnabled" = "true"
    "Description" = "My list description"
    "Title" = "Test"
}

$bodyJson = ConvertTo-Json -InputObject $body -Compress
Invoke-WebRequest -Uri $uri -Method $method -Headers $headers -ContentType $contentType -Body $bodyJson -Credential $credential
