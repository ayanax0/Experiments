$siteUrl = "https://interestec.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint Online Management Shell
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

# SharePoint Client Context
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

# Password Setting
$securePassword = Read-Host -Prompt "Enter Your Password." -AsSecureString
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($account, $securePassword)

#$listTemplates = $context.web.ListTemplates
$lists = $context.web.Lists

$context.load($lists)

$context.executeQuery()

foreach ($list in $lists)
{
    $context.load($list)
    $context.executeQuery()

    $title = $list.Title
    $baseTemplate = $list.BaseTemplate
    Write-Output "$title,$baseTemplate"
}
