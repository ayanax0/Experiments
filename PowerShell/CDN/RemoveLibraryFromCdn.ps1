# CDNからイメージライブラリの登録を削除します。

$adminSiteUrl = "https://interestec-admin.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"
$listUrl = "/CdnExImageLib"

# SharePoint管理センターにログイン
$credential = Get-Credential -Credential $account
Connect-SPOService -Url $adminSiteUrl -Credential $credential

# CDNからイメージライブラリを削除
Remove-SPOTenantCdnOrigin -CdnType private -OriginUrl $listUrl

# CDN登録内容を表示
Get-SPOTenantCdnOrigins -CdnType private
