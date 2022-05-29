# Created by Kugane

### Question what to do ###




### Install WinGet ###
# Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901
$hasPackageManager = Get-AppxPackage -Name 'Microsoft.Winget.Source' | Select Name, Version
$hasVCLibs = Get-AppxPackage -Name 'Microsoft.VCLibs.140.00.UWPDesktop' | Select Name, Version
$hasXAML = Get-AppxPackage -Name '*UI.Xaml.2.7*' | Select Name, Version
$hasAppInstaller = Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' | Select Name, Version

if (!$hasPackageManager) {
    Write-Host -ForegroundColor Yellow "Checking if WinGet is installed"
        if ($hasVCLibs.Version -lt "14.0.30035.0") {
            Write-Host -ForegroundColor Yellow "Installing VCLibs dependencies..."
            Add-AppxPackage -Path "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
            Write-Host -ForegroundColor Green "VCLibs dependencies successfully installed."
        }
        else {
            Write-Host -ForegroundColor Green "VCLibs is already installed. Skip..."
        }
        if ($hasXAML.Version -lt "7.2203.17001.0") {
            Write-Host -ForegroundColor Yellow "Installing XAML dependencies..."
            Add-AppxPackage -Path "https://github.com/Kugane/winget/raw/Rewrite/Microsoft.UI.Xaml.2.7_7.2203.17001.0_x64__8wekyb3d8bbwe.Appx"
            Write-Host -ForegroundColor Green "XAML dependencies successfully installed."
        }
        else {
            Write-Host -ForegroundColor Green "XAML is already installed. Skip..."
        }
        if ($hasAppInstaller.Version -lt "1.16.12653.0") {
            Write-Host -ForegroundColor Yellow "Installing WinGet..."
	        $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
		    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		    $releases = Invoke-RestMethod -Uri "$($releases_url)"
		    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
		    Add-AppxPackage -Path $latestRelease.browser_download_url
            Write-Host -ForegroundColor Green "WinGet successfully installed."
        }
}
else {
    Write-Host -ForegroundColor Green "WinGet is already installed. Skip..."
    }
Pause
Clear-Host


### Install Apps with GUI ###
# Based on this gist: https://gist.github.com/Codebytes/29bf18015f6e93fca9421df73c6e512c

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
Write-Host -ForegroundColor Cyan "Installing new Apps wit GUI"

$graphical = @(
    @{name = "ClamWin.ClamWin" }
);

Foreach ($gui in $graphical) {
    $listGUI = winget list --exact -q $gui.name
    if (![String]::Join("", $listGUI).Contains($gui.name)) {
        Write-Host -ForegroundColor Yellow "Install:" $gui.name
        if ($gui.source -ne $null) {
            winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name --source $gui.source
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green $gui.name "successfully installed."
            }
            else {
                $gui.name + " couldn't be installed." | Add-Content "$DesktopPath\winget_install.log"
                Write-Host -ForegroundColor Red $gui.name "couldn't be installed."
                Write-Host -ForegroundColor Yellow "Write in $DesktopPath\winget_intall.log"
            }
        }
        else {
            winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green $gui.name "successfully installed."
            }
            else {
                $gui.name + " couldn't be installed." | Add-Content "$DesktopPath\winget_install.log"
                Write-Host -ForegroundColor Red $gui.name "couldn't be installed."
                Write-Host -ForegroundColor Yellow "Write in $DesktopPath\winget_intall.log"
            }            
        }
    }
    else {
        Write-Host -ForegroundColor Yellow "Skip installation of" $gui.name
    }
}
Pause
Clear-Host


### Install Apps silent ###

Write-Host -ForegroundColor Cyan "Installing new Apps"

$apps = @(
    @{name = "7zip.7zip" }
    @{name = "Foxit.FoxitReader" }
    @{name = "Microsoft.VC++2015-2022Redist-x86" }
    @{name = "Microsoft.VC++2015-2022Redist-x64" }
    @{name = "9NCBCSZSJRSB"; source = "msstore" }        # Spotify
    @{name = "9NKSQGP7F2NH"; source = "msstore" }        # Whatsapp Desktop
    @{name = "9WZDNCRFJ3TJ"; source = "msstore" }        # Netflix
    @{name = "9P6RC76MSMMJ"; source = "msstore" }        # Prime Video
    @{name = "9PMMSR1CGPWG"; source = "msstore" }        # HEIF-PictureExtension
    @{name = "9MVZQVXJBQ9V"; source = "msstore" }        # AV1 VideoExtension
    @{name = "9NCTDW2W1BH8"; source = "msstore" }        # Raw-PictureExtension
    @{name = "9N95Q1ZZPMH4"; source = "msstore" }        # MPEG-2-VideoExtension
    @{name = "9N4WGH0Z6VHQ"; source = "msstore" }        # HEVC-VideoExtension
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-Host -ForegroundColor Yellow  "Install:" $app.name
        # MS Store apps
        if ($app.source -ne $null) {
            winget install --exact --silent --accept-package-agreements --accept-source-agreements $app.name --source $app.source
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green $app.name "successfully installed."
            }
            else {
                $app.name + " couldn't be installed." | Add-Content "$DesktopPath\winget_install.log"
                Write-Host -ForegroundColor Red $app.name "couldn't be installed."
                Write-Host -ForegroundColor Yellow "Write in $DesktopPath\winget_intall.log"
            }    
        }
        # All other Apps
        else {
            winget install --exact --silent --scope machine --accept-package-agreements --accept-source-agreements $app.name
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green $app.name "successfully installed."
            }
            else {
                $app.name + " couldn't be installed." | Add-Content "$DesktopPath\winget_install.log"
                Write-Host -ForegroundColor Red $app.name "couldn't be installed."
                Write-Host -ForegroundColor Yellow "Write in $DesktopPath\winget_intall.log" 
            }  
        }
    }
    else {
        Write-Host -ForegroundColor Yellow "Skip installation of" $app.name
    }
}
Pause
Clear-Host


### Debloating ###
# Based on this gist: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

Write-Host -ForegroundColor Cyan "Remove bloatware Apps"
$bloatware = @(
    # default Windows 11 apps
    "MicrosoftTeams"
    "Microsoft.Todos"
    "Microsoft.PowerAutomateDesktop"

    # default Windows 10 apps
    "Microsoft.549981C3F5F10" # Cortana Offline
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.Print3D"    
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsMaps"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.ZuneVideo"
    "Microsoft.YourPhone"
    # "Microsoft.MSPaint"        # Paint & Paint3D
    # "Microsoft.ZuneMusic"      # New Media Player in Windows

    # Xbox Apps
    # "Microsoft.Xbox.TCUI"
    # "Microsoft.XboxApp"
    # "Microsoft.XboxGameOverlay"
    # "Microsoft.XboxGamingOverlay"
    # "Microsoft.XboxIdentityProvider"
    # "Microsoft.XboxSpeechToTextOverlay"

    # Threshold 2 apps
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    "Microsoft.Whiteboard"

    # non-Microsoft
    # "4DF9E0F8.Netflix"
    # "SpotifyAB.SpotifyMusic"
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491"
    "CAF9E577.Plex"
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "Fitbit.FitbitCoach"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "NORDCURRENT.COOKINGFEVER"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    "flaregamesGmbH.RoyalRevolt2"
    "king.com.*"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
);

Foreach ($blt in $bloatware) {
  Write-Host -ForegroundColor Red "Removing:" $blt
  Get-AppxPackage -AllUsers $blt | Remove-AppxPackage
}

Write-Host
Write-Host -ForegroundColor Magenta  "Installation finished"
Write-Host
Pause
