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
$listTemplateGallery = $context.web.GetCatalog(114)
$listTemplateGalleryItems = $listTemplateGallery.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())

$context.load($listTemplateGallery)
$context.load($listTemplateGalleryItems)

$context.executeQuery()

foreach ($listTemplateGalleryItem in $listTemplateGalleryItems)
{
    $templateTitle = $listTemplateGalleryItem["TemplateTitle"]
    $templateId = $listTemplateGalleryItem["TemplateID"]
    $templateType = $listTemplateGalleryItem["TemplateType"]
    Write-Output "$templateTitle,$templateId,$templateType"
}
