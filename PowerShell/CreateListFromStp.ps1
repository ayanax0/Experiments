[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

# �A�J�E���g�ݒ�
$connectionUser = "akiray@interestec.onmicrosoft.com" 
#$connectionPassword = ConvertTo-SecureString "<���s���[�U�[�̃p�X���[�h>" -AsPlainText -Force
$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# �ڑ�Credential����
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($connectionUser, $connectionPassword)

# �ڑ���T�C�g��URL
$siteUrl = "https://interestec.sharepoint.com/"

# �T�C�gURL����Context����
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

# ���X�g�e���v���[�g�̎擾
$customListTemplates = $context.Site.GetCustomListTemplates($context.Web)
$surveyTemplate = $customListTemplates.GetByName("�A���P�[�g�e���v���[�g")

$context.Load($surveyTemplate)
$context.executeQuery()

Write-Output $surveyTemplate.Name

# ���X�g�쐬���̐���
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = "AncAnc"
$listCreationInformation.Url = "Lists/AncAnc"
$listCreationInformation.TemplateType = "102"
$listCreationInformation.ListTemplate = $surveyTemplate

# ���X�g�̍쐬
$list = $context.Web.Lists.Add($listCreationInformation)
$list.Title = "�Z�~�i�[�̃A���P�[�gA"
$list.Update()

$context.executeQuery()
