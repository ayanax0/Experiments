# ÉGÉâÅ[î≠ê∂éûÇÕèàóùÇí‚é~
$ErrorActionPreference = "Stop"

$userCredential = Get-Credential -Credential "sysadmin@interestec.onmicrosoft.com"

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $userCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking

$auditLogs = (Search-UnifiedAuditLog -StartDate "2019/4/10" -EndDate "2019/5/10"-RecordType "SharePoint" -Operations "PageViewed")

"CreationTime,ObjectId,UserId,Site,WebId"
foreach ($auditLog in $auditLogs)
{
    $auditData = (ConvertFrom-Json -InputObject $auditLog.AuditData)
    "{0},{1},{2},{3},{4}" -f `
        $auditData.CreationTime, `
        $auditData.ObjectId, `
        $auditData.UserId, `
        $auditData.Site, `
        $auditData.WebId `
}

Remove-PSSession $Session
