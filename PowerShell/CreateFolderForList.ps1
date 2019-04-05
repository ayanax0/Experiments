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

# リストアイテム作成情報
$listItemCreationInformation = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
$listItemCreationInformation.UnderlyingObjectType = 1
$listItemCreationInformation.LeafName = "foo"

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

# リスト取得
$list = $context.Web.Lists.GetByTitle("customlist1")

# フォルダー作成
$listItem = $list.AddItem($listItemCreationInformation)
$listItem["Title"] = "foo"
$listItem.Update()

$context.Load($listItem)
$context.executeQuery()
