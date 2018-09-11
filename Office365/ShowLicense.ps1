# 管理者権限で以下を実行しておくこと
# Install-Module -Name AzureAD
# Install-Module -Name MSOnline

# ユーザー認証情報取得
$userCredential = Get-Credential -UserName "akiray@interestec.onmicrosoft.com" -Message "Enter Password."

# Office365に接続
Connect-MsolService -Credential $userCredential

# ログインユーザーのライセンスを表示
Get-MsolAccountSku
