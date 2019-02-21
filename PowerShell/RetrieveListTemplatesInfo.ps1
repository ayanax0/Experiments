$siteUrl = "https://interestec.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint Online Management Shell
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

# SharePoint Client Context
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

# Password Setting
$securePassword = Read-Host -Prompt "Enter Your Password." -AsSecureString
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($account, $securePassword)

# $listTemplates = $context.web.ListTemplates
$listTemplates = $context.Site.GetCustomListTemplates($context.web)

$context.load($listTemplates)

$context.executeQuery()

foreach ($listTemplate in $listTemplates)
{
    $templateName = $listTemplate.Name
    $internalName = $listTemplate.InternalName
    $listTemplateTypeKind = $listTemplate.ListTemplateTypeKind
    $featureId = $listTemplate.FeatureId
    $isCustomTemplate = $listTemplate.IsCustomTemplate
    Write-Output "$templateName,$internalName,$listTemplateTypeKind,$featureId,$isCustomTemplate"
}
