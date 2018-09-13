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

[String]$nowStr = Get-Date -format "yyyyMMddHHmmss"

#アウトプットファイルの名前(拡張子を含む)
$OutputFileName = "OutputSPWebUsageInfo_$nowStr.csv"

#対象のサイトコレクションURL
$siteCollectionUrl = $args[0]

#アクセス状況を取得する期間（=過去何日分取得するか）
$period = 60

#-------------------------------------------------
#ファンクション定義
#-------------------------------------------------

#Web Analytics レポートの「アクセスの多いページ」から、SharePointリストのデフォルトビューのURLのページビューを取得して出力する。
function OutputSPWebUsageInfo($web)
{
    #####################
    #アクセスの多いページの件数取得
    #####################
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $TopPageForPageReport = $AnalyticsReportFunction.GetWebAnalyticsReportData($web.Url, "3", "TopPageForPageReport", [DateTime]::Today.AddDays(-$period), [DateTime]::Today)

    switch($web.IsRootWeb)
    {
        'True'
        {
            $webType = "トップサイト"
        }
        'False'
        {
            $webType = "サブサイト"
        }
    }

    #SPWeb内のリストのデフォルトビューURLを取得
    $listUrlIndex = @{}
    foreach ($list in $web.Lists)
    {
        $listDefaultViewUrl = $web.Site.MakeFullUrl($list.DefaultViewUrl)
        $listUrlIndex[$listDefaultViewUrl] = $list
    }

    #取得された全ての「アクセスの多いページ」のレポートを処理対象とする
    for ($i = 0; $i -lt $TopPageForPageReport.Length; $i++)
    {
        #URLが設定されているもののみを出力対象とする
        if ($TopPageForPageReport[$i, 0])
        {
            #SPWeb内のリストのデフォルトビューURLのもののみを出力対象とする
            if ($listUrlIndex[$TopPageForPageReport[$i, 0]])
            {
                "{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}" -f `
                    $webType,`
                    $web.Site.Url,`
                    $web.Url,`
                    $listUrlIndex[$TopPageForPageReport[$i, 0]].Title,`
                    $TopPageForPageReport[$i, 0],`
                    $TopPageForPageReport[$i, 2],`
                    $TopPageForPageReport[$i, 3] >> $OutputFileName
            }
        }
    }
}

#-------------------------------------------------
#主処理
#-------------------------------------------------

#利用状況の取得対象期間をアウトプットに出力
"アクセスの多いページの取得期間：{0} から {1}" -f `
    [DateTime]::Today.AddDays(-$period).ToLocalTime().ToString("yyyy/MM/dd"),`
    [DateTime]::Today.ToLocalTime().ToString("yyyy/MM/dd")  > $OutputFileName

    #アウトプットに出力（タブ区切り）
"{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}" -f `
    "トップorサブ",`
    "サイトコレクションURL",`
    "サイトURL",`
    "タイトル",`
    "ページURL",`
    "ページビューの数",`
    "全体に対する割合" >> $OutputFileName

#Webアプリケーションを取得
$site = New-Object Microsoft.SharePoint.SPSite($siteCollectionUrl)

foreach($web in $site.AllWebs)
{
    OutputSPWebUsageInfo $web
}

Write-Host "完了"
