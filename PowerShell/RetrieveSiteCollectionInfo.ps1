# Install-Module SharePointPnPPowerShellOnline

$adminSiteUrl = "https://interestec-admin.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint管理センターにログイン
$credential = Get-Credential -Credential $account
#Connect-SPOService -Url $adminSiteUrl -Credential $credential
Connect-PnPOnline -Url $adminSiteUrl -Credentials $credential

$sites = Get-PnPTenantSite -IncludeOneDriveSites

foreach ($site in $sites)
{
    #$siteJson = ConvertTo-Json -InputObject $site -Compress
    #Write-Output $siteJson
    $site.Context.LoadQuery({$site.Context.Site.id})

    Write-Output $site.Context.Site.id
}
