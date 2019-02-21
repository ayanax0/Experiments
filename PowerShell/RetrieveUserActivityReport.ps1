# リソースのURI
$resourceUri = "https://graph.microsoft.com"

# モジュールのロード
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\WindowsPowerShell\Modules\AzureAD\2.0.1.16\Microsoft.IdentityModel.Clients.ActiveDirectory.dll")

# 認証URI
$authority = "https://login.microsoftonline.com/interestec.onmicrosoft.com"

# Azure Active Directoryで定義したアプリケーションID
$clientId = "08103819-563b-4bf3-a558-480690d0133b"

# 認証時のリダイレクトURI
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

# ユーザー利用状況取得REST Uri
$restUri = "$resourceUri/v1.0/reports/getSharePointActivityUserDetail(period='D90')"
Write-Output $restUri

# 認証コンテキスト取得
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

# プラットフォームパラメータ（自動）
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"

# 認証
$authResult = $authContext.AcquireTokenAsync($resourceUri, $clientId, $redirectUri, $platformParameters).Result

# 認証ヘッダーを取得
$authHeader = $authResult.CreateAuthorizationHeader()

# ユーザー利用状況取得
$userActivityInfo = (Invoke-RestMethod -Uri $restUri -Headers @{Authorization=$authHeader} -Method Get -ContentType "application/json")

Write-Output $userActivityInfo
