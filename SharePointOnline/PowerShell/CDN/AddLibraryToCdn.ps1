# イメージライブラリをCDNに登録します。

$adminSiteUrl = "https://interestec-admin.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"
$listUrl = "/CdnExImageLib"
#$listUrl = "/sub1/Shared%20Documents"

# SharePoint管理センターにログイン
$credential = Get-Credential -Credential $account
Connect-SPOService -Url $adminSiteUrl -Credential $credential

# イメージライブラリをCDNへ登録
Add-SPOTenantCdnOrigin -CdnType private -OriginUrl $listUrl

# CDN登録内容を表示
Get-SPOTenantCdnOrigins -CdnType private
