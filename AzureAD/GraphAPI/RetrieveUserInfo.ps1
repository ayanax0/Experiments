# 管理者権限で以下を実行しておくこと
# Install-Module -Name AzureAD

# リソースのURI
$resourceUri = "https://graph.windows.net"
$apiVersion = "?api-version=1.6"

# モジュールのロード
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\WindowsPowerShell\Modules\AzureAD\2.0.1.16\Microsoft.IdentityModel.Clients.ActiveDirectory.dll")

# 認証URI
$authority = "https://login.microsoftonline.com/interestec.onmicrosoft.com"

# Azure Active Directoryで定義したアプリケーションID
$clientId = "08103819-563b-4bf3-a558-480690d0133b"

# 認証時のリダイレクトURI
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

# 情報取得するユーザー
$userId = "akiray%40interestec.onmicrosoft.com"

# ユーザー情報（部署情報）取得REST Uri
$restUri = "$resourceUri/interestec.onmicrosoft.com/users/$userId$apiVersion"
Write-Output $restUri

# 認証コンテキスト取得
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

# プラットフォームパラメータ（自動）
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"

# 認証
$authResult = $authContext.AcquireTokenAsync($resourceUri, $clientId, $redirectUri, $platformParameters).Result

# 認証ヘッダーを取得
$authHeader = $authResult.CreateAuthorizationHeader()

# ユーザー情報取得
$userInfo = (Invoke-RestMethod -Uri $restUri -Headers @{Authorization=$authHeader} -Method Get -ContentType "application/json")

$userInfoJson = (ConvertTo-Json -InputObject $userInfo -Depth 10)

# ライセンス情報表示
Write-Output "----- ここから -----"
Write-Output $userInfoJson
