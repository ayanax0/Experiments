#-------------------------------------------------
#開始処理
#-------------------------------------------------

#スナップイン取得
Write-Host "準備中"
$snapInInfo = Get-PSSnapin | Where-Object{$_.Name -eq "Microsoft.SharePoint.PowerShell"}
if($snapInInfo -eq $null) {
	Add-PSSnapin Microsoft.SharePoint.PowerShell
}
Write-Host "準備完了"

#参照追加
[System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 
[System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics.UI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 

#カレントディレクトリをスクリプトの保存場所に設定する
Set-location (Split-Path $MyInvocation.MyCommand.Path -parent)

#-------------------------------------------------
#変数の宣言
#-------------------------------------------------

#アウトプットファイルの名前(拡張子を含む)
$OutputFileName = "OutputSPSiteUsgeInfo.csv"

#対象のWebアプリケーション
$webAppName = "http://sd-portal.km.local/"

#アクセス状況を取得する期間（=過去何日分取得するか）
$period = 30

#-------------------------------------------------
#ファンクション定義
#-------------------------------------------------

function OutputSPSiteUsgeInfo($list)
{
    #####################
    #ページビュー数の算出
    #####################
    #ページビュー数（日単位）を指定した期間分抽出する
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $PageViewTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($list.,"2","PageViewTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)
    
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
    $UniqueVisitorsTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($site.RootWeb.Url,"2","UniqueVisitorsTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)
    
    #指定した期間のユニークビジター（日単位）の平均値を算出する
    $sumOfUniqueVisitorsPerDay = 0
    $averageOfUniqueVisitorsPerDay = 0
    for($i = 0; $i -lt $period; $i++)
    {
        $sumOfUniqueVisitorsPerDay += $UniqueVisitorsTrend[$i,1]
    }
    $averageOfUniqueVisitorsPerDay = ($sumOfUniqueVisitorsPerDay/$period).ToString("0")

    #サイトコレクションの容量取得（GB単位)
    $Storage = ($site.Usage.Storage/1GB).ToString("0.00")

    #アウトプットに出力（タブ区切り）
    "{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}" -f `
        $site.RootWeb.Url,`
        $site.RootWeb.Title,`
        $site.RootWeb.Created.ToLocalTime(),`
        $site.RootWeb.LastItemModifiedDate.ToLocalTime(),`
        $sumOfPageViewTrendPerDay,`
        $averageOfPageViewTrendPerDay,`
        $sumOfUniqueVisitorsPerDay,`
        $averageOfUniqueVisitorsPerDay,`
        $Storage  >> $OutputFileName
}

#-------------------------------------------------
#主処理
#-------------------------------------------------

#利用状況の取得対象期間をアウトプットに出力
"ページビュー数およびユニークビジター数の取得期間：{0} から {1}" -f `
    [DateTime]::Today.AddDays(-$period).ToLocalTime().ToString("yyyy/MM/dd"),`
    [DateTime]::Today.ToLocalTime().ToString("yyyy/MM/dd")  > $OutputFileName


#アウトプットに出力（タブ区切り）
"{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}" -f "URL",`
                                                 "タイトル",`
                                                 "作成日",`
                                                 "最終更新日",`
                                                 "ページビュー数（合計）",`
                                                 "ページビュー（平均）",`
                                                 "ユニークビジター数（合計）",`
                                                 "ユニークビジター数（平均）",`
                                                 "容量(GB)" >> $OutputFileName

#Webアプリケーションを取得 
$webApp = [Microsoft.SharePoint.Administration.SPWebApplication]::Lookup($webAppName)

foreach($site in $webApp.Sites)
{
    OutputSPSiteUsgeInfo $site
}

Write-Host "完了"
