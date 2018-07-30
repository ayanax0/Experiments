# SharePoint サイトコレクションの列挙

# TODO パラメータから取得したWebアプリケーション名を取得できるようにすること。
# TODO ファイルから取得したURLリストからも取得できるようにすること。

$webAppName = "http://sps2010/"

# Webアプリケーションを取得 
$webApp = [Microsoft.SharePoint.Administration.SPWebApplication]::Lookup($webAppName)

Write-Output $webApp.Sites
