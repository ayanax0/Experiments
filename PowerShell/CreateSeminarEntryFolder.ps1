# SharePoint CSOMのロード
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$siteUrl = "https://interestec.sharepoint.com/sites/seminar"
$account = "sysadmin@interestec.onmicrosoft.com"

# 再作成の範囲
$from = 1
$to = 100

# SharePoint Client Context
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

# Password Setting
$securePassword = Read-Host -Prompt "Enter Your Password." -AsSecureString
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($account, $securePassword)

# 応募者リストの取得
$seminarEntryList = $context.web.GetList("/sites/seminar/Lists/SeminarEntry")
$context.load($seminarEntryList)

# リストテンプレートの取得
$customListTemplates = $context.Site.GetCustomListTemplates($context.Web)
$surveyTemplate = $customListTemplates.GetByName("アンケートテンプレート")
$context.load($surveyTemplate)

$context.executeQuery()

# 応募者リストフォルダの削除
for ($i = $from; $i -le $to; $i++) {
    # CAMLの生成
    $viewXml = "<View><Query><Where><Eq><FieldRef Name='FileLeafRef'/><Value Type='String'>SeminarEntry{0:00000}</Value></Eq></Where></Query></View>" -f $i

    $camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
    $camlQuery.ViewXml = $viewXml
    $seminarEntryListItems = $seminarEntryList.GetItems($camlQuery)
    $context.load($seminarEntryListItems)

    $context.executeQuery()

    foreach ($seminarEntryListItem in $seminarEntryListItems) {
        $seminarEntryListItem.DeleteObject()
    }

    # アンケートリストの削除
    $surveyListPath = "/sites/seminar/Lists/SeminarSurvey{0:00000}" -f $i
    $surveyList = $context.web.GetList($surveyListPath)
    $surveyList.DeleteObject()

    $context.executeQuery()
}

# 応募者リストフォルダ／アンケートリストの作成
for ($i = $from; $i -le $to; $i++) {
    # フォルダ名の生成
    $folderName = "SeminarEntry{0:00000}" -f $i

    # フォルダ作成情報の生成
    $itemCreationInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $itemCreationInfo.underlyingObjectType = 1

    $folder = $seminarEntryList.AddItem($itemCreationInfo)
    $folder["Title"] = $folderName
    $folder.Update()
    $context.load($folder)

    # リスト名の生成
    $listName = "SeminarSurvey{0:00000}" -f $i

    # リスト作成情報の生成
    $listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $listCreationInformation.Title = $listName
    $listCreationInformation.Url = "Lists/$listName"
    $listCreationInformation.TemplateType = "102"
    $listCreationInformation.ListTemplate = $surveyTemplate

    # リストの作成
    $list = $context.Web.Lists.Add($listCreationInformation)
    $list.Update()
    $context.load($list)

    $context.executeQuery()
}
