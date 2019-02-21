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

# リストテンプレートの取得
$customListTemplates = $context.Site.GetCustomListTemplates($context.Web)
$surveyTemplate = $customListTemplates.GetByName("アンケートテンプレート")

$context.Load($surveyTemplate)
$context.executeQuery()

Write-Output $surveyTemplate.Name

# リスト作成情報の生成
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = "AncAnc"
$listCreationInformation.Url = "Lists/AncAnc"
$listCreationInformation.TemplateType = "102"
$listCreationInformation.ListTemplate = $surveyTemplate

# リストの作成
$list = $context.Web.Lists.Add($listCreationInformation)
$list.Title = "セミナーのアンケートA"
$list.Update()

$context.executeQuery()
