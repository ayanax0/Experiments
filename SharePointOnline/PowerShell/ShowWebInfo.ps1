#[System.Reflection.Assembly]::Load("Microsoft.SharePoint.Client, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
#[System.Reflection.Assembly]::Load("Microsoft.SharePoint.Client.Runtime, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")

[System.Reflection.Assembly]::Load("Microsoft.SharePoint.Client, Version=*.*.*.*, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
#[System.Reflection.Assembly]::Load("Microsoft.SharePoint.Client.Runtime, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")

# 接続先サイトのURL
$siteUrl = "https://interestec.sharepoint.com/"

# アカウント設定
$connectionUser = "akiray@interestec.onmicrosoft.com" 
$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

$site = $context.Site

$context.Load($site)
$context.executeQuery()
