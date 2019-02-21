# SharePoint CSOMのロード
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

# アカウント設定
#$connectionUser = "akiray@interestec.onmicrosoft.com" 
$connectionUser = "akiyama@wintech.onmicrosoft.com" 
$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# 接続先サイトのURL
#$siteUrl = "https://interestec.sharepoint.com/"
#$siteUrl = "https://interestec.sharepoint.com/sites/Develop1/"
$siteUrl = "https://wintech.sharepoint.com/"

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

# 接続先サイト（SPWeb）の取得
$web = $context.Web
#$navigation = $web.Navigation
$context.Load($web)
$context.Load($web.AllProperties)

# クエリをサーバーに送信
$context.ExecuteQuery()

#Get-Member -InputObject $navigation | Format-Table

Write-Output "----------"
#Write-Output $navigation.Retrieve()

$properties = $web.AllProperties.FieldValues

$globalNavigationIncludeTypes = $properties["__GlobalNavigationIncludeTypes"]
$currentNavigationIncludeTypes = $properties["__CurrentNavigationIncludeTypes"]

Write-Output "__GlobalNavigationIncludeTypes : $globalNavigationIncludeTypes"
Write-Output "__CurrentNavigationIncludeTypes : $currentNavigationIncludeTypes"

# コンテキストを廃棄
$context.Dispose()
