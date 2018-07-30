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
Push-Location (Split-Path $MyInvocation.MyCommand.Path -parent)

#�֐��X�N���v�g�����[�h
.\OutputSPListUsageInfo.ps1

#-------------------------------------------------
#�ϐ��̐錾
#-------------------------------------------------

#�A�E�g�v�b�g�t�@�C���̖��O(�g���q���܂�)
$OutputFileName = "OutputSPSiteUsgeInfo.csv"

#�Ώۂ̃T�C�g�R���N�V����
#$SiteCollectionUrl = "http://sd-portal.km.local/"
$SiteCollectionUrl = "http://sps2010/"

#�A�N�Z�X�󋵂��擾������ԁi=�ߋ��������擾���邩�j
$period = 30

#-------------------------------------------------
#�又��
#-------------------------------------------------

#�T�C�g�R���N�V�������擾
$site = New-Object Microsoft.SharePoint.SPSite($SiteCollectionUrl)

#�w�b�_�[���o��
$OutputFileHeader > $OutputFileName

Write-Host "Webs���[�v�ɓ���[$site]"
$webs = $site.AllWebs
foreach ($web in $webs)
{
    Write-Host "Lists���[�v�ɓ���[$web]"
    foreach ($list in $web.Lists)
    {
        Write-Host "�O���ďo��[$list.DefaultViewUrl]"
        OutputUsageInfo $list >> $OutputFileName
    }
}

#�J�����g�f�B���N�g�������Ƃ̏ꏊ�ɐݒ肷��
Pop-Location

Write-Host "����"
