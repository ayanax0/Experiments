# SharePoint CSOMのロード
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

# アカウント設定
$connectionUser = "<実行ユーザーのメールアドレス>" 
$connectionPassword = ConvertTo-SecureString "<実行ユーザーのパスワード>" -AsPlainText -Force

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# 接続先サイトのURL
$siteUrl = "https://smflc.sharepoint.com/teams/TSA"

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

# 接続先サイト（SPWeb）の取得
$web = $context.Web
$context.Load($web)

# クエリをサーバーに送信
$context.ExecuteQuery()

# ～ ここから接続先サイト（$web）の情報が取得できる。 ～
# サイトのタイトルを表示
Write-Host $web.Title

# コンテキストを廃棄
$context.Dispose()
