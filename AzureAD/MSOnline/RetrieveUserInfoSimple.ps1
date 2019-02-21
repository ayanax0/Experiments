# 管理者権限で以下を実行しておくこと
# Install-Module -Name MSOnline

# ユーザー認証情報取得
$userCredential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

# Office365に接続
Connect-MsolService -Credential $userCredential

#Get-MsolUser -All | Select UserPrincipalName,Department
Get-MsolUser -All | Select-Object UserPrincipalName,SignInName,Department
