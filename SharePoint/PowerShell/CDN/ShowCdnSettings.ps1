# CDNに登録されているリスト／ライブラリを表示します。

$adminSiteUrl = "https://interestec-admin.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint管理センターにログイン
$credential = Get-Credential -Credential $account
Connect-SPOService -Url $adminSiteUrl -Credential $credential

# CDN登録内容を表示
Get-SPOTenantCdnOrigins -CdnType private
