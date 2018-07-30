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
Push-Location (Split-Path $MyInvocation.MyCommand.Path -parent)

#関数スクリプトをロード
.\OutputSPListUsageInfo.ps1

#-------------------------------------------------
#変数の宣言
#-------------------------------------------------

#アウトプットファイルの名前(拡張子を含む)
$OutputFileName = "OutputSPSiteUsgeInfo.csv"

#対象のサイトコレクション
#$SiteCollectionUrl = "http://sd-portal.km.local/"
$SiteCollectionUrl = "http://sps2010/"

#アクセス状況を取得する期間（=過去何日分取得するか）
$period = 30

#-------------------------------------------------
#主処理
#-------------------------------------------------

#サイトコレクションを取得
$site = New-Object Microsoft.SharePoint.SPSite($SiteCollectionUrl)

#ヘッダーを出力
$OutputFileHeader > $OutputFileName

Write-Host "Websループに入る[$site]"
$webs = $site.AllWebs
foreach ($web in $webs)
{
    Write-Host "Listsループに入る[$web]"
    foreach ($list in $web.Lists)
    {
        Write-Host "外部呼出し[$list.DefaultViewUrl]"
        OutputUsageInfo $list >> $OutputFileName
    }
}

#カレントディレクトリをもとの場所に設定する
Pop-Location

Write-Host "完了"
