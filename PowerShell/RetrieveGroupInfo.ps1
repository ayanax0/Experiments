# SharePoint CSOMのロード
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

# アカウント設定
$connectionUser = "akiray@interestec.onmicrosoft.com" 
#$connectionPassword = ConvertTo-SecureString "<実行ユーザーのパスワード>" -AsPlainText -Force
$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# 接続先サイトのURL
$siteUrl = "https://interestec.sharepoint.com/"

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

# 接続先サイト（SPWeb）の取得
$web = $context.Web
$context.Load($web)
$context.Load($context.Site)
$context.Load($web.SiteGroups)

# クエリをサーバーに送信
$context.ExecuteQuery()

# ～ ここから接続先サイト（$web）の情報が取得できる。 ～
# サイトのタイトルを表示
$siteId = $context.Site.id
$webId = $web.Id
Write-Host "SiteID:$siteId"
Write-Host "WebID:$webId"

# グループ情報取得
foreach ($group in $web.SiteGroups)
{
    $context.Load($group.Users)
    $context.ExecuteQuery()

    $groupTitle = $group.Title
    $groupCount = $group.Users.Count
    Write-Host "$groupTitle : $groupCount"
}

# コンテキストを廃棄
$context.Dispose()
