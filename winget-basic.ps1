# Created by Kugane

# Install WinGet
# Based on4 this gist: https://gist.github.com/crutkas/6c2096eae387e54bd05cde246f23901

$OSVersion = [System.Environment]::OSVersion.Version
$hasPackageManager = Get-AppXPackage -name 'Microsoft.Winget.Source'

if ($OSVersion -ge "10.0.22000" -and $hasPackageManager.Version -lt "1.1.12986") {

    Write-Host -ForegroundColor Yellow "Install WinGet..."

    Get-AppXPackage 'Microsoft.DesktopAppInstaller' -AllUsers | Foreach {Add-AppXPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

    Write-Host -ForegroundColor Green "WinGet successfully installed."
}
elseif ($OSVersion -lt "10.0.22000" -and $hasPackageManager.Version -lt "1.1.12986") {

        Write-Host -ForegroundColor Yellow "Install WinGet..."

		$releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$releases = Invoke-RestMethod -uri "$($releases_url)"
		$latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith("msixbundle") } | Select -First 1
		Add-AppxPackage -Path $latestRelease.browser_download_url

        Write-Host -ForegroundColor Green "WinGet successfully installed."
}
else {
    Write-Host -ForegroundColor Green "WinGet is already installed. Skip..."
}
Pause
cls


# Install Programs or any other App you want to install with GUI
# Based on this gist: https://gist.github.com/Codebytes/29bf18015f6e93fca9421df73c6e512c

Write-Host -ForegroundColor Cyan "Installing new Apps wit GUI"
$graphical = @(
    @{name = "ClamWin.ClamWin" }
);

Foreach ($gui in $graphical) {
    #check if the app is already installed
    $listGUI = winget list --exact -q $gui.name
    if (![String]::Join("", $listGUI).Contains($gui.name)) {
        
        Write-Host -ForegroundColor Yellow "Install:" $gui.name
        
        if ($gui.source -ne $null) {
            winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name --source $gui.source
            Write-Host -ForegroundColor Green $gui.name "successfully installed."
        }
        else {
            winget install --exact --interactive --accept-package-agreements --accept-source-agreements $gui.name
            Write-Host -ForegroundColor Green $gui.name "successfully installed."
        }
    }
    else {
        Write-Host -ForegroundColor Yellow "Skip installation of" $gui.name
    }
}
Pause
cls


# Install New apps

Write-Host -ForegroundColor Cyan "Installing new Apps"

$apps = @(
    @{name = "7zip.7zip" },
    @{name = "Foxit.FoxitReader" },
    @{name = "Microsoft.VC++2015-2022Redist-x86" },
    @{name = "Microsoft.VC++2015-2022Redist-x64" },
    @{name = "9NCBCSZSJRSB"; source = "msstore" },      # Spotify
    @{name = "9NKSQGP7F2NH"; source = "msstore" },      # Whatsapp Desktop
    @{name = "9WZDNCRFJ3TJ"; source = "msstore" },      # Netflix
    @{name = "9P6RC76MSMMJ"; source = "msstore" },      # Prime Video
    @{name = "9PMMSR1CGPWG"; source = "msstore" },      # HEIF-PictureExtension
    @{name = "9MVZQVXJBQ9V"; source = "msstore" },      # AV1 VideoExtension
    @{name = "9NCTDW2W1BH8"; source = "msstore" },      # Raw-PictureExtension
    @{name = "9N95Q1ZZPMH4"; source = "msstore" },      # MPEG-2-VideoExtension
    @{name = "9N4WGH0Z6VHQ"; source = "msstore" }       # HEVC-VideoExtension
);

Foreach ($app in $apps) {
    #check if the app is already installed
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        
        Write-Host -ForegroundColor Yellow  "Install:" $app.name
        
        if ($app.source -ne $null) {
            winget install --exact --silent --accept-package-agreements --accept-source-agreements $app.name --source $app.source
            Write-Host -ForegroundColor Green $app.name "successfully installed."
        }
        else {
            winget install --exact --silent --accept-package-agreements --accept-source-agreements $app.name
            Write-Host -ForegroundColor Green $app.name "successfully installed."
        }
    }
    else {
        Write-Host -ForegroundColor Yellow "Skip installation of" $app.name
    }
}
Pause
cls


# Remove Apps
# Based on this gist: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

Write-Host -ForegroundColor Cyan "Remove bloatware Apps"

$bloatware = @(
    # default Windows 11 apps
    "MicrosoftTeams"
    "Microsoft.Todos"
    "Microsoft.PowerAutomateDesktop"

    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

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

    # non-Microsoft
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    #"4DF9E0F8.Netflix"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
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
    #"SpotifyAB.SpotifyMusic"
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

Foreach ($blt in $bloatware)
{
  Write-Host -ForegroundColor Red "Remove:" $blt
  Get-AppXPackage -AllUsers $blt | Remove-AppXPackage
}
Write-Host -ForegroundColor Magenta  "Installation finished"
Pause