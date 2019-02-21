$userCredential = Get-Credential -Credential "akiray@interestec.onmicrosoft.com"

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $userCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking

$auditLogs = (Search-UnifiedAuditLog -StartDate "2018/7/1" -EndDate "2018/9/19"-RecordType "SharePoint" -Operations "PageViewed")

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
