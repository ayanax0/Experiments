# 認証APIのURI
$uri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/Authenticate"

# 認証APIのリクエストヘッダー
# ※Accept-Encodingが"gzip; deflate"だとエラーが発生する（HTTP Error 400. The request is badly formed.）
$headers = @{
    #"Origin"="https://docs.b2btcservicedev.com";
    #"Accept-Language" = "ja,en-US;q=0.9,en;q=0.8";
    #"User-Agent" = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";
    #"Accept" = "application/json, text/javascript, */*; q=0.01"
}

# 認証APIの本文
$body = @{
    "userID" = "nttadmin";
    "password" = "Z6HePKN/oxTiAwtLKBMm4A==";
    "action" = "S"
}

$bodyJson = ConvertTo-Json -InputObject $body -Compress

$resultJson = (Invoke-WebRequest -Uri $uri -Method "POST" -Headers $headers -ContentType "application/json" -Body $bodyJson)

Write-Output "--- Authenticate全体結果 ---"
Write-Output $resultJson
Write-Output "--- Authenticate全体結果（ここまで） ---"

# ContentをJSONに変換
$content = (ConvertFrom-Json -InputObject $resultJson.Content)

Write-Output "--- Authenticate Content.rtnMessage結果 ---"
Write-Output $content.rtnMessage
Write-Output "--- Authenticate Content.rtnMessage結果（ここまで） ---"
