Write-Information "Beginning Installation"
$toolsDir   = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
Write-Host "My Current Directory is" -ForegroundColor Green 
Write-Host $toolsDir -ForegroundColor Red
$source = "$toolsDir\*.zip"
Write-Host $source
$destination = "C:\Temp"
Write-Host $destination
Expand-Archive -Path "$source" -DestinationPath "$destination"
