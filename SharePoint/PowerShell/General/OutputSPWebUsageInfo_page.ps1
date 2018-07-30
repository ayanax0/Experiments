#-------------------------------------------------
#�J�n����
#-------------------------------------------------

#�X�i�b�v�C���擾
Write-Host "������"
$snapInInfo = Get-PSSnapin | Where-Object{$_.Name -eq "Microsoft.SharePoint.PowerShell"}
if($snapInInfo -eq $null) {
	Add-PSSnapin Microsoft.SharePoint.PowerShell
}
Write-Host "��������"

#�Q�ƒǉ�
[System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 
[System.Reflection.Assembly]::Load("Microsoft.Office.Server.WebAnalytics.UI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c") | Out-Null; 

#�J�����g�f�B���N�g�����X�N���v�g�̕ۑ��ꏊ�ɐݒ肷��
Set-location (Split-Path $MyInvocation.MyCommand.Path -parent)

#-------------------------------------------------
#�ϐ��̐錾
#-------------------------------------------------

[String]$nowStr = Get-Date -format "yyyyMMddHHmmss"

#�A�E�g�v�b�g�t�@�C���̖��O(�g���q���܂�)
$OutputFileName = "OutputSPWebUsageInfo_$nowStr.csv"

#�Ώۂ̃T�C�g�R���N�V����URL
$siteCollectionUrl = $args[0]

#�A�N�Z�X�󋵂��擾������ԁi=�ߋ��������擾���邩�j
$period = 60

#-------------------------------------------------
#�t�@���N�V������`
#-------------------------------------------------

#Web Analytics ���|�[�g�́u�A�N�Z�X�̑����y�[�W�v����ASharePoint���X�g�̃f�t�H���g�r���[��URL�̃y�[�W�r���[���擾���ďo�͂���B
function OutputSPWebUsageInfo($web)
{
    #####################
    #�A�N�Z�X�̑����y�[�W�̌����擾
    #####################
    $AnalyticsReportFunction = New-Object Microsoft.Office.Server.WebAnalytics.Reporting.AnalyticsReportFunction
    [Threading.Thread]::CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $TopPageForPageReport = $AnalyticsReportFunction.GetWebAnalyticsReportData($web.Url, "3", "TopPageForPageReport", [DateTime]::Today.AddDays(-$period), [DateTime]::Today)

    switch($web.IsRootWeb)
    {
        'True'
        {
            $webType = "�g�b�v�T�C�g"
        }
        'False'
        {
            $webType = "�T�u�T�C�g"
        }
    }

    #SPWeb���̃��X�g�̃f�t�H���g�r���[URL���擾
    $listUrlIndex = @{}
    foreach ($list in $web.Lists)
    {
        $listDefaultViewUrl = $web.Site.MakeFullUrl($list.DefaultViewUrl)
        $listUrlIndex[$listDefaultViewUrl] = $list
    }

    #�擾���ꂽ�S�Ắu�A�N�Z�X�̑����y�[�W�v�̃��|�[�g�������ΏۂƂ���
    for ($i = 0; $i -lt $TopPageForPageReport.Length; $i++)
    {
        #URL���ݒ肳��Ă�����݂̂̂��o�͑ΏۂƂ���
        if ($TopPageForPageReport[$i, 0])
        {
            #SPWeb���̃��X�g�̃f�t�H���g�r���[URL�̂��݂̂̂��o�͑ΏۂƂ���
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
#�又��
#-------------------------------------------------

#���p�󋵂̎擾�Ώۊ��Ԃ��A�E�g�v�b�g�ɏo��
"�A�N�Z�X�̑����y�[�W�̎擾���ԁF{0} ���� {1}" -f `
    [DateTime]::Today.AddDays(-$period).ToLocalTime().ToString("yyyy/MM/dd"),`
    [DateTime]::Today.ToLocalTime().ToString("yyyy/MM/dd")  > $OutputFileName

    #�A�E�g�v�b�g�ɏo�́i�^�u��؂�j
"{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}" -f `
    "�g�b�vor�T�u",`
    "�T�C�g�R���N�V����URL",`
    "�T�C�gURL",`
    "�^�C�g��",`
    "�y�[�WURL",`
    "�y�[�W�r���[�̐�",`
    "�S�̂ɑ΂��銄��" >> $OutputFileName

#Web�A�v���P�[�V�������擾
$site = New-Object Microsoft.SharePoint.SPSite($siteCollectionUrl)

foreach($web in $site.AllWebs)
{
    OutputSPWebUsageInfo $web
}

Write-Host "����"
