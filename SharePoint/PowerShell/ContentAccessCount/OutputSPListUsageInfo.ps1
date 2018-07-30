#-------------------------------------------------
#開始処理
#-------------------------------------------------

#アウトプットに出力（タブ区切り）
$OutputFileHeader ="{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}" -f `
    "URL",`
    "タイトル",`
    "作成日",`
    "最終更新日",`
    "ページビュー数（合計）",`
    "ページビュー（平均）",`
    "ユニークビジター数（合計）",`
    "ユニークビジター数（平均）",`
    "容量(GB)"

#-------------------------------------------------
#ファンクション定義
#-------------------------------------------------
function OutputUsageInfo($list)
{
    Write-Host $list.DefaultViewUrl

    return ""

    #####################
    #ページビュー数の算出
    #####################
    #ページビュー数（日単位）を指定した期間分抽出する
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $PageViewTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($list.DefaultViewUrl, "2", "PageViewTrend", [DateTime]::Today.AddDays(-$period),[DateTime]::Today)

    #指定した期間のページビュー（日単位）の平均値を算出する
    $sumOfPageViewTrendPerDay = 0
    $averageOfPageViewTrendPerDay = 0
    for($i = 0; $i -lt $period; $i++)
    {
        $sumOfPageViewTrendPerDay += $PageViewTrend[$i,1]
    }

    $averageOfPageViewTrendPerDay = ($sumOfPageViewTrendPerDay/$period).ToString("0")

    #####################
    #ユニークビジター数の算出
    #####################
    #ユニークビジターの数（日単位）を指定した期間分抽出する
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $UniqueVisitorsTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($list.DefaultViewUrl,"2","UniqueVisitorsTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)

    #戻り値を生成（タブ区切り）
    $returnValue = "{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}" -f `
        $site.RootWeb.Url,`
        $site.RootWeb.Title,`
        $site.RootWeb.Created.ToLocalTime(),`
        $site.RootWeb.LastItemModifiedDate.ToLocalTime(),`
        $sumOfPageViewTrendPerDay,`
        $averageOfPageViewTrendPerDay,`
        $sumOfUniqueVisitorsPerDay,`
        $averageOfUniqueVisitorsPerDay,`
        $Storage

    return $returnValue
}
