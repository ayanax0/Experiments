# �F��API��URI
$authenticateApiUri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/Authenticate"

# �F��API�̃��N�G�X�g�w�b�_�[
# ��Accept-Encoding��"gzip; deflate"���ƃG���[����������iHTTP Error 400. The request is badly formed.�j
$authenticateApiHeaders = @{
    #"Origin"="https://docs.b2btcservicedev.com";
    #"Accept-Language" = "ja,en-US;q=0.9,en;q=0.8";
    #"User-Agent" = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";
    #"Accept" = "application/json, text/javascript, */*; q=0.01"
}

function InvokeWebRequest
{
    param (
        [String] $uri,
        $headers,
        $body 
    )

    $bodyJson = ConvertTo-Json -InputObject $body -Compress

    $resultJson = (Invoke-WebRequest -Uri $uri -Method "POST" -Headers $headers -ContentType "application/json" -Body $bodyJson)
    
    return (ConvertFrom-Json $resultJson.Content)
}

# �F��API�̎��s
$authenticateApiResult = InvokeWebRequest $authenticateApiUri $authenticateApiHeaders $authenticateApiBody

Write-Output "--- Authenticate�S�̌��� ---"
Write-Output $authenticateApiResult
Write-Output "--- Authenticate�S�̌��ʁi�����܂Łj ---"

# �F��API�̖{��
$authenticateApiBody = @{
    "userID" = "nttadmin";
    "password" = "Z6HePKN/oxTiAwtLKBMm4A==";
    "action" = "S"
}

# TrackingMap�擾API��URI
$displayTrackingMapApiUri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/DisplayTrackingMap"

# TrackingMap�擾API�̃��N�G�X�g�w�b�_�[
$displayTrackingMapApiHeaders = @{
    #"Origin"="https://docs.b2btcservicedev.com";
    #"Accept-Language" = "ja,en-US;q=0.9,en;q=0.8";
    #"User-Agent" = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";
    #"Accept" = "application/json, text/javascript, */*; q=0.01"
}

# �擾API�̖{��
$displayTrackingMapApiBody = @{
    "tripNo" = "test";
    "tokenKey" = $authenticateApiResult.rtnMessage.tokenKey;
}

# TrackingMap�擾API�̎��s
$displayTrackingMapApiResult = InvokeWebRequest $displayTrackingMapApiUri $displayTrackingMapApiHeaders $displayTrackingMapApiBody

Write-Output "--- Authenticate�S�̌��� ---"
Write-Output $displayTrackingMapApiResult
Write-Output "--- Authenticate�S�̌��ʁi�����܂Łj ---"
