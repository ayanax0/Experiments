# テナントで、CDNを有効化します。

$adminSiteUrl = "https://interestec-admin.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

# SharePoint管理センターにログイン
$credential = Get-Credential -Credential $account
Connect-SPOService -Url $adminSiteUrl -Credential $credential

# CDNを有効化
Set-SPOTenantCdnEnabled -CdnType private -Enable $true

# CDN設定を表示
Get-SPOTenantCdnEnabled -CdnType private
