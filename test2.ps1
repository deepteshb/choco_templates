$sourceA = "C:\choco-setup\packages\putty\tools\*.zip"
$destination = "C:\Temp"
Expand-Archive -Path "$sourceA" -DestinationPath "$destination"