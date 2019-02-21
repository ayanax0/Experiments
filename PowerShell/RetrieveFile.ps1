# SharePoint CSOMのロード
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$siteUrl = "https://interestec.sharepoint.com"
$account = "akiray@interestec.onmicrosoft.com"

$connectionPassword = Read-Host -Prompt "Enter Password." -AsSecureString

# 接続Credential生成
$credential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($account, $connectionPassword)

# サイトURLからContext生成
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$context.Credentials = $credential

#$fileName = "testfile.txt"
$fileName = "testfile.bin"
$filePath = "/Shared%20Documents/$fileName"

while ($true) {
    try {
        $sharePointFile = $context.Web.GetFileByServerRelativeUrl($filePath)
        $context.Load($sharePointFile)
        $context.ExecuteQuery()
    } catch {
        Write-Output "File NOT exist on Sharepoint.: $fileName"
        continue
    }

    Write-Output "File exist on Sharepoint.: $fileName"
    if ($context.HasPendingRequest) {
        $context.ExecuteQuery()
    }

    $contextFile = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
    $contextFile.Credentials = $credential
    $sourceFileInformation = [Microsoft.SharePoint.Client.File]::OpenBinaryDirect($contextFile, $filePath)
    $distinationStream = [System.IO.File]::Create("C:\Users\akiray\Documents\github\SharePointOnline\$fileName")
    $sourceFileInformation.Stream.CopyTo($distinationStream)
    $distinationStream.Close()

    $distinationStream.Dispose()
    $sourceFileInformation.Dispose()
    $contextFile.Dispose()
    break
}

$context.Dispose()
