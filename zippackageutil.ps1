# Nexus Download Link: http://www.sonatype.org/downloads/nexus-latest-bundle.zip
 
clear
  
# URL Parameter
$WebURL = "http://www.sonatype.org/downloads/nexus-latest-bundle.zip"
  
# Directory Parameter
$FileDirectory = "$($env:USERPROFILE)$("\downloads\")"
 
#Write-Output $FileDirectory
 
# If directory doesn't exist create the directory
if((Test-Path $FileDirectory) -eq 0)
    {
        mkdir $FileDirectory;
    }
 
# We assume the file you download is named what you want it to be on your computer
$FileName = [System.IO.Path]::GetFileName($WebURL)
 
# Concatenate the two values to prepare the download
$FullFilePath = "$($FileDirectory)$($FileName)"
 
#Write-Output $FullFilePath
 
function Get-FileDownload([String] $WebURL, [String] $FullFilePath)
{
        # Give a basic message to the user to let them know what we are doing
        Write-Output "Downloading '$WebURL' to '$FullFilePath'"
 
        $uri = New-Object "System.Uri" "$WebURL"
        $request = [System.Net.HttpWebRequest]::Create($uri)
        $request.set_Timeout(30000) #15 second timeout
        $response = $request.GetResponse()
        $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
        $responseStream = $response.GetResponseStream()
        $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $FullFilePath, Create
        $buffer = new-object byte[] 10KB
        $count = $responseStream.Read($buffer,0,$buffer.length)
        $downloadedBytes = $count
        while ($count -gt 0)
            {
                [System.Console]::Write("`r`nDownloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes/1024), $totalLength)
                $targetStream.Write($buffer, 0, $count)
                $count = $responseStream.Read($buffer,0,$buffer.length)
                $downloadedBytes = $downloadedBytes + $count
            }
         
        $targetStream.Flush()
        $targetStream.Close()
        $targetStream.Dispose()
        $responseStream.Dispose()
         
        # Give a basic message to the user to let them know we are done
        Write-Output "`r`nDownload complete"
    }
 
function Expand-ZipFile([string]$File, [string]$Destination) #The targets to run.
{
    # If directory doesn't exist create the directory
    if((Test-Path $Destination) -eq 0)
    {
        mkdir $Destination;     
    }
 
    $Shell = new-object -com shell.application
  
    # Get the name of the Zip file
    $Zip = $Shell.NameSpace($File)
  
    #Expand/Extract each file from the zip file
    foreach($Item in $Zip.items())
        {
            $Shell.Namespace($Destination).copyhere($Item)
        }
}
 
Get-FileDownload $WebURL  $FullFilePath
 
Expand-ZipFile $FullFilePath c:\Nexus
 
 
 
cd C:\Nexus
 
$NexusFolder = (Get-ChildItem nexus* | Select Name).Name
 
# Create System Variable
[Environment]::SetEnvironmentVariable("NEXUS_HOME", "C:\Nexus\$NexusFolder", "Machine")
 
cd "C:\Nexus\$NexusFolder"
 
# Configure C:\Nexus\nexus-2.12.0-01\conf\nexus.properties
#     Set Port Number if you want something other than 8081
 
cd bin
# Nexus Download Link: http://www.sonatype.org/downloads/nexus-latest-bundle.zip
  
clear
   
# URL Parameter
$WebURL = "http://www.sonatype.org/downloads/nexus-latest-bundle.zip"
   
# Directory Parameter
$FileDirectory = "$($env:USERPROFILE)$("\downloads\")"
  
#Write-Output $FileDirectory
  
# If directory doesn't exist create the directory
if((Test-Path $FileDirectory) -eq 0)
    {
        mkdir $FileDirectory;
    }
  
# We assume the file you download is named what you want it to be on your computer
$FileName = [System.IO.Path]::GetFileName($WebURL)
  
# Concatenate the two values to prepare the download
$FullFilePath = "$($FileDirectory)$($FileName)"
  
#Write-Output $FullFilePath
  
function Get-FileDownload([String] $WebURL, [String] $FullFilePath)
{
        # Give a basic message to the user to let them know what we are doing
        Write-Output "Downloading '$WebURL' to '$FullFilePath'"
  
        $uri = New-Object "System.Uri" "$WebURL"
        $request = [System.Net.HttpWebRequest]::Create($uri)
        $request.set_Timeout(30000) #15 second timeout
        $response = $request.GetResponse()
        $totalLength = [System.Math]::Floor($response.get_ContentLength()/1024)
        $responseStream = $response.GetResponseStream()
        $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $FullFilePath, Create
        $buffer = new-object byte[] 10KB
        $count = $responseStream.Read($buffer,0,$buffer.length)
        $downloadedBytes = $count
        while ($count -gt 0)
            {
                [System.Console]::Write("`r`nDownloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes/1024), $totalLength)
                $targetStream.Write($buffer, 0, $count)
                $count = $responseStream.Read($buffer,0,$buffer.length)
                $downloadedBytes = $downloadedBytes + $count
            }
          
        $targetStream.Flush()
        $targetStream.Close()
        $targetStream.Dispose()
        $responseStream.Dispose()
          
        # Give a basic message to the user to let them know we are done
        Write-Output "`r`nDownload complete"
    }
  
function Expand-ZipFile([string]$File, [string]$Destination) #The targets to run.
{
    # If directory doesn't exist create the directory
    if((Test-Path $Destination) -eq 0)
    {
        mkdir $Destination;     
    }
  
    $Shell = new-object -com shell.application
   
    # Get the name of the Zip file
    $Zip = $Shell.NameSpace($File)
   
    #Expand/Extract each file from the zip file
    foreach($Item in $Zip.items())
        {
            $Shell.Namespace($Destination).copyhere($Item)
        }
}
  
Get-FileDownload $WebURL  $FullFilePath
  
Expand-ZipFile $FullFilePath c:\Nexus
  
  
  
cd C:\Nexus
  
$NexusFolder = (Get-ChildItem nexus* | Select Name).Name
  
# Create System Variable
[Environment]::SetEnvironmentVariable("NEXUS_HOME", "C:\Nexus\$NexusFolder", "Machine")
  
cd "C:\Nexus\$NexusFolder"
  
# Configure C:\Nexus\nexus-2.12.0-01\conf\nexus.properties
#     Set Port Number if you want something other than 8081
  
cd bin
  
Start-Process nexus.bat install -Wait
Start-Process nexus.bat start -Wait
  
start 'http://localhost:8081/nexus'