[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

# アカウント設定
$connectionUser = "sysadmin@interestec.onmicrosoft.com" 
#$connectionPassword = ConvertTo-SecureString "<実行ユーザーのパスワード>" -AsPlainText -Force
$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# 接続先サイトのURL
$siteUrl = "https://interestec.sharepoint.com/sites/publish"

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

$web = $context.Web
$list = $web.Lists.GetByTitle("custom5")
$listItem = $list.GetItemById(1)
$context.Load($listItem)

# クエリをサーバーに送信
$context.ExecuteQuery()

Write-Host $listItem["Title"]

# ゴミ箱へ移動
$listItem.Recycle()

# クエリをサーバーに送信
$context.ExecuteQuery()

# コンテキストを廃棄
$context.Dispose()
