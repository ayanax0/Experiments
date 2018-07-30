#-------------------------------------------------
#�J�n����
#-------------------------------------------------

#�A�E�g�v�b�g�ɏo�́i�^�u��؂�j
$OutputFileHeader ="{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}`t{7}`t{8}" -f `
    "URL",`
    "�^�C�g��",`
    "�쐬��",`
    "�ŏI�X�V��",`
    "�y�[�W�r���[���i���v�j",`
    "�y�[�W�r���[�i���ρj",`
    "���j�[�N�r�W�^�[���i���v�j",`
    "���j�[�N�r�W�^�[���i���ρj",`
    "�e��(GB)"

#-------------------------------------------------
#�t�@���N�V������`
#-------------------------------------------------
function OutputUsageInfo($list)
{
    Write-Host $list.DefaultViewUrl

    return ""

    #####################
    #�y�[�W�r���[���̎Z�o
    #####################
    #�y�[�W�r���[���i���P�ʁj���w�肵�����ԕ����o����
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $PageViewTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($list.DefaultViewUrl, "2", "PageViewTrend", [DateTime]::Today.AddDays(-$period),[DateTime]::Today)

    #�w�肵�����Ԃ̃y�[�W�r���[�i���P�ʁj�̕��ϒl���Z�o����
    $sumOfPageViewTrendPerDay = 0
    $averageOfPageViewTrendPerDay = 0
    for($i = 0; $i -lt $period; $i++)
    {
        $sumOfPageViewTrendPerDay += $PageViewTrend[$i,1]
    }

    $averageOfPageViewTrendPerDay = ($sumOfPageViewTrendPerDay/$period).ToString("0")

    #####################
    #���j�[�N�r�W�^�[���̎Z�o
    #####################
    #���j�[�N�r�W�^�[�̐��i���P�ʁj���w�肵�����ԕ����o����
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $UniqueVisitorsTrend = $AnalyticsReportFunction.GetWebAnalyticsReportData($list.DefaultViewUrl,"2","UniqueVisitorsTrend",[DateTime]::Today.AddDays(-$period),[DateTime]::Today)

    #�߂�l�𐶐��i�^�u��؂�j
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
