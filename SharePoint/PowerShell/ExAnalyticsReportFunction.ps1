#ListUrl
$listUrl1 = "http://sps2010/Shared%20Documents/"
$listUrl2 = "http://sps2010/Shared%20Documents/Forms/AllItems.aspx"

#アクセス状況を取得する期間（=過去何日分取得するか）
$period = 30

$AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
[Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

$PageViewTrend1 = $AnalyticsReportFunction.GetWebAnalyticsReportData($listUrl1,"2","PageViewTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)
$PageViewTrend2 = $AnalyticsReportFunction.GetWebAnalyticsReportData($listUrl2,"2","PageViewTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)

for($i = 0; $i -lt $period; $i++)
{
    Write-Host $PageViewTrend1[$i,1]":"$PageViewTrend2[$i,1]
}
