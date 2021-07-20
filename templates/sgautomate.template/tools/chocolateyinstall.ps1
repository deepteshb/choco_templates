Write-Information "Beginning Installation"
$toolsDir   = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$destination = 'C:\Temp\'

Write-Host "My Current Directory is" -ForegroundColor Green 
Write-Host $toolsDir -ForegroundColor Red
Copy-Item -Path "$toolsDir\*.zip" -Destination "$destination" -Recurse
Write-Host "Copied items from $toolsDir to $destination"
$source = Get-Item "$destination"
Write-Host $source
#Expand-Archive -Path $source -DestinationPath $destination