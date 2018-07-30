# リスト／ライブラリのIRM設定（有効／無効）を表示します。
# 有効の場合は、IRM設定内容を表示します。

$siteUrl = "https://interestec.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint Online Management Shell
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

# SharePoint Client Context
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

# Password Setting
$securePassword = Read-Host -Prompt "Enter Your Password." -AsSecureString
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($account, $securePassword)

$lists = $context.Web.Lists
$context.Load($lists)
$context.ExecuteQuery()

foreach ($list in $lists)
{
    $listTitle = $list.Title
    $listIrmEnabled = $list.IrmEnabled

    Write-Output "$listTitle $listIrmEnabled"

    if ($listIrmEnabled)
    {
        $listIrmSettings = $list.InformationRightsManagementSettings
        $context.Load($listIrmSettings)
        $context.ExecuteQuery()
        Write-Output "--- IRM Settings ---"
        Write-Output $listIrmSettings
        Write-Output "--- IRM Settings ---"
    }
}
