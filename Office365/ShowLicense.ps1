# 管理者権限で以下を実行しておくこと
# Install-Module -Name AzureAD
# Install-Module -Name MSOnline

# ユーザー認証情報取得
#$userCredential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"
#$userCredential = Get-Credential -UserName "akiray@scskwin.com" -Message "Enter Password."
$userCredential = Get-Credential

# Office365に接続
Connect-MsolService -Credential $userCredential

# ログインユーザーのライセンスを表示
Get-MsolAccountSku

# ユーザー情報の表示
Get-MsolUser | ForEach-Object { Write-Output $_.DisplayName }
#Get-MsolUser -All
