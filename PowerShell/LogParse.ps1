$LogParserCmd = "C:\Program Files (x86)\Log Parser 2.2\LogParser.exe"
$InputFormat = "-i:IISW3C"
$OutputFormat = "-o:csv"
$LogFileDir = "C:\Users\akiray\OneDrive - WinƒeƒNƒmƒƒW\knowledge\PowerShell\LogParser\IISLog"
$LogFileName = "u_ex180509.log"
$Query = "SELECT * FROM $LogFileName"

Push-Location -Path "$LogFileDir"

& "$LogParserCmd" $InputFormat $OutputFormat "$Query" > parsed.csv

Pop-Location
