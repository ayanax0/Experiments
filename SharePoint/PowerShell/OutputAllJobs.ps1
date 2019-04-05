# SharePoint に定義されているJobをすべてCSVに出力する。

# 出力するCSVファイル名
$csvFileName = "D:\Work\Jobs\jobs.csv"

# ジョブ情報を取得
$timerJobs = (Get-SPTimerJob | Select-Object Id, Name, WebApplication, Title, IsDisabled, Status)

# 取得したジョブ情報をCSVに出力
foreach ($timerJob in $timerJobs)
{
    Export-Csv -Path $csvFileName -InputObject $timerJob -Append -NoTypeInformation
}
