# �F��API��URI
$uri = "http://b2btradepoc.infotracktelematics.com/B2BTradeServices/api/Authenticate"

# �F��API�̃��N�G�X�g�w�b�_�[
# ��Accept-Encoding��"gzip; deflate"���ƃG���[����������iHTTP Error 400. The request is badly formed.�j
$headers = @{
    #"Origin"="https://docs.b2btcservicedev.com";
    #"Accept-Language" = "ja,en-US;q=0.9,en;q=0.8";
    #"User-Agent" = "Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36";
    #"Accept" = "application/json, text/javascript, */*; q=0.01"
}

# �F��API�̖{��
$body = @{
    "userID" = "nttadmin";
    "password" = "Z6HePKN/oxTiAwtLKBMm4A==";
    "action" = "S"
}

$bodyJson = ConvertTo-Json -InputObject $body -Compress

$resultJson = (Invoke-WebRequest -Uri $uri -Method "POST" -Headers $headers -ContentType "application/json" -Body $bodyJson)

Write-Output "--- Authenticate�S�̌��� ---"
Write-Output $resultJson
Write-Output "--- Authenticate�S�̌��ʁi�����܂Łj ---"

# Content��JSON�ɕϊ�
$content = (ConvertFrom-Json -InputObject $resultJson.Content)

Write-Output "--- Authenticate Content.rtnMessage���� ---"
Write-Output $content.rtnMessage
Write-Output "--- Authenticate Content.rtnMessage���ʁi�����܂Łj ---"
