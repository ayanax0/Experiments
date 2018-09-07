# モジュールのロード
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\WindowsPowerShell\Modules\AzureAD\2.0.1.16\Microsoft.IdentityModel.Clients.ActiveDirectory.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\WindowsPowerShell\Modules\AzureAD\2.0.1.16\Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll")

# リソースのURI
$resourceUri = "https://graph.microsoft.com"

# 認証URI
$authority = "https://login.microsoftonline.com/interestec.onmicrosoft.com"

# Azure Active Directoryで定義したアプリケーションID
$clientId = "08103819-563b-4bf3-a558-480690d0133b"

# 認証時のリダイレクトURI
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

# 情報取得するユーザー
$userId = "fujioy@interestec.onmicrosoft.com"

# ユーザー情報（部署情報）取得REST Uri
$restUri = "$resourceUri/v1.0/users/$userId/department"

# 認証コンテキスト取得
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

# プラットフォームパラメータ（自動）
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"

# 認証
$authResult = $authContext.AcquireTokenAsync($resourceUri, $clientId, $redirectUri, $platformParameters).Result

# 認証ヘッダーを取得
$authHeader = $authResult.CreateAuthorizationHeader()

# 部署情報取得
$department = (Invoke-RestMethod -Uri $restUri -Headers @{Authorization=$authHeader} -Method Get -ContentType "application/json").value

# 部署情報表示
Write-Output "[$userId]:[$department]"
