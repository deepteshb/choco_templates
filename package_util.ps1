# This is primarily used for displaying any message before script execution.
Write-Host '
        ------------------------------------------------------------
        Welcome to SG Gaming Chocolatey Package Management Utility
        ------------------------------------------------------------
        
        |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
        | An SG Gaming and Persistent Systems Collaboration      |
        | author: Deeptesh Bhattacharya                          |
        | version: 1.0-alpha                                     |
        |                                                        |
        |________________________________________________________|
     
          
            ' -ForegroundColor Yellow

# Function for collecting user inputs for Package Name, Package Version and Maintainer which will be used by the
# templating engine to further parse it to the NuSpec to create the NuGet Package.
# The template is pre-written and will be used to generate the NuGet Package.


        #---------------------- Function Starts | Purpose: To collect the user inputs and color them green. ------------------------------
        function collect_user_input() {
            param
            (
                [Parameter(Position = 0, ValueFromPipeline = $true)]
                [string]$msg,
                [string]$ForegroundColor = "DarkGreen"
            )
        
            Write-Host -ForegroundColor $ForegroundColor -NoNewline $msg;
            return Read-Host
        }
        # ----------------------Function ends here.-------------------------------------

        #---------------------All variables are declared here which are consumed for Automatically induced by the Templating Engine.------------------->
        


        $pkgname = collect_user_input 'Please enter the name of the Package to build---->' #ask for PakageName
        $pkg_version = collect_user_input 'Enter the version of the Package --->' #ask for Version
        $maintainer = collect_user_input 'Enter the name of the Maintainer Group---->' #ask for Maintainer
        $filesDir = "C:\choco-setup\files"
        $outdir = "C:\choco-setup\packages\"
        $t = 'sgautomate'
        
        #---------------------All variables are declared here which are consumed for Automatically induced by the Templating Engine.------------------->
        #Changing Directory for Code Execution
        Set-Location $outdir
        Write-Information "Changing to the OutPut Directory Location where the packages will be built."
        
        # If Else: If (Condition: Directory Pre-Exists) THEN (Remove Directory and its contents recursively.) ELSE (Execute Packaging Automation From Line 65 onwards.)
        #IF BLOCK (LINE 54-63)
         If (Test-Path $outdir\$pkgname){
             Write-Host "Existing Directory Found"
             Write-Host "- Deleting Existing Directory." -ForegroundColor Red
             Remove-Item $outdir/$pkgname -Recurse -Confirm:$false
             Write-Host "==================+ Adding new package===================" -ForegroundColor Green
        }
        #IF BLOCK ENDS(Starts at Line 54)

        #--------------------------------EXECUTING PACKAGE AUTOMATION USING VARIABLE COLLECTED IN BETWEEN LINE 40-45------------------------------------------>
        #Creating the base package template using template automation.

        choco.exe new -t $t $pkgname --version=$pkg_version --maintainer=$maintainer --out=$outdir

        #TODO FOR FUTURE USE AND REFRENCE================================================================
        #$download_url = 'http://localhost:8082/service/rest/repository/browse/mypackages/'
        #Invoke-WebRequest $download_url -OutFile $outdir/$pkgname/tools/$pkgname-$pkg_version.zip
        #Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString($download_url)) -OutFile $outdir/$pkgname/tools/$pkgname-$pkg_version.zip
        #================================================================================================

        
        #Once the Code is executed. Collecting the artifacts and copying them to the Package Container for Packaging and trigger package automation(Line 75 - 80)
        Write-Host "Nothing to Remove."
        Write-Host "==================+ Adding new package===================" -ForegroundColor Green
        Copy-Item "$filesDir\*" -Destination "$outdir\$pkgname\tools" -Force
        Write-Host "Files Copied"
        Set-Location $outdir\$pkgname
        choco.exe pack --verbose $pkgname.nuspec --outputdirectory $outdir\$pkgname
        Write-Host "Package written to C:\choco-setup\$outdir\$pkgname"
       
       
        #Set-Location C:\choco-setup\mypkgs
        Write-Host "Setting API Key for MyPackages"
        choco apikey --confirm --verbose -k=953f7c33-de15-376c-bdc8-60e1c8b69699 -s=http://localhost:8082/repository/mypackages/
        Write-Host "Setting API Key for nugethosted"
        choco apikey --confirm --verbose-k=953f7c33-de15-376c-bdc8-60e1c8b69699 -s=http://localhost:8082/repository/nuget-hosted/
        Write-Host "Adding Source for MyPackages"
        choco source add --confirm --verbose -n=mypackages -s=http://localhost:8082/repository/mypackages/
        Write-Host "Adding Source for nugethosted"
        choco source add --confirm --verbose -n=mynuget -s=http://localhost:8082/repository/nuget-hosted/
        Write-Host "Pushing Nuget Package to Nexus Repository"
        choco.exe push --confirm --verbose $pkgname.$pkg_version.nupkg --source "'http://localhost:8082/repository/nuget-hosted/'" -k="'953f7c33-de15-376c-bdc8-60e1c8b69699'"

exit