# 認証APIのURI
$authenticateApiUri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/Authenticate"

# 認証APIのリクエストヘッダー
# ※Accept-Encodingが"gzip; deflate"だとエラーが発生する（HTTP Error 400. The request is badly formed.）
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

# 認証APIの実行
$authenticateApiResult = InvokeWebRequest $authenticateApiUri $authenticateApiHeaders $authenticateApiBody

Write-Output "--- Authenticate全体結果 ---"
Write-Output $authenticateApiResult
Write-Output "--- Authenticate全体結果（ここまで） ---"

# 認証APIの本文
$authenticateApiBody = @{
    "userID" = "nttadmin";
    "password" = "Z6HePKN/oxTiAwtLKBMm4A==";
    "action" = "S"
}

# TrackingMap取得APIのURI
$displayTrackingMapApiUri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/DisplayTrackingMap"

# TrackingMap取得APIのリクエストヘッダー
$displayTrackingMapApiHeaders = @{
    #"Origin"="https://docs.b2btcservicedev.com";
    #"Accept-Language" = "ja,en-US;q=0.9,en;q=0.8";
    #"User-Agent" = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";
    #"Accept" = "application/json, text/javascript, */*; q=0.01"
}

# 取得APIの本文
$displayTrackingMapApiBody = @{
    "tripNo" = "test";
    "tokenKey" = $authenticateApiResult.rtnMessage.tokenKey;
}

# TrackingMap取得APIの実行
$displayTrackingMapApiResult = InvokeWebRequest $displayTrackingMapApiUri $displayTrackingMapApiHeaders $displayTrackingMapApiBody

Write-Output "--- Authenticate全体結果 ---"
Write-Output $displayTrackingMapApiResult
Write-Output "--- Authenticate全体結果（ここまで） ---"
