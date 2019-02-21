# 管理者権限で以下を実行しておくこと
# Install-Module -Name MSOnline

# ユーザー認証情報取得
$userCredential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

# Office365に接続
Connect-MsolService -Credential $userCredential

$users = (Get-MsolUser)

$userInfoJson = (ConvertTo-Json -InputObject $users[2] -Depth 10)

# ライセンス情報表示
Write-Output "----- ここから -----"
#Write-Output $userInfoJson

foreach ($property in Get-Member -InputObject $users[2])
{
    $value = $users[2].($property.Name)

    "{0}`t{1}`t{2}`t{3}" -f `
        $property.Name, `
        $property.MemberType, `
        $property.Definition, `
        $value >> hoge.csv
}
