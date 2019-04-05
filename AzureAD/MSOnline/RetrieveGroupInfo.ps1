# 管理者権限で以下を実行しておくこと
# Install-Module -Name MSOnline

# ユーザー認証情報取得
$userCredential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

# Office365に接続
Connect-MsolService -Credential $userCredential

$groups = Get-MsolGroup

foreach ($group in $groups)
{
    Write-Host "--- グループ情報 ---"
    Write-Host $group.DisplayName
    Write-Host $group.GroupType
    Write-Host "--- メンバー情報 ---"
    $gourpMembers = (Get-MsolGroupMember -GroupObjectId $group.ObjectId)
    foreach ($gourpMember in $gourpMembers)
    {
        $gourpMember.ObjectId
        $gourpMember.GroupMemberType
        $gourpMember.DisplayName
    }
}
