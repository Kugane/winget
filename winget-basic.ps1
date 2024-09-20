# Created by Kugane
$global:dryRun = $false

### Here you can add apps that you want to configure during installation ###
$graphical = @(
    "ClamWin.ClamWin"
)

### These apps are installed silently for all users ###
$apps = @(
    "7zip.7zip",
    "Foxit.FoxitReader",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "9N0DX20HK701",
    "9NCBCSZSJRSB",
    "9NKSQGP7F2NH",
    "9WZDNCRFJ3TJ",
    "9P6RC76MSMMJ",
    "9NXQXXLFST89",
    "9N7F2SM5D1LR",
    "9PMMSR1CGPWG",
    "9MVZQVXJBQ9V",
    "9NCTDW2W1BH8",
    "9N95Q1ZZPMH4"
)

$bloatware = @(
### Apps below will be uninstalled by default. Add # to keep any app installed. ###
    "Clipchamp.Clipchamp",
    "Microsoft.3DBuilder",
    "Microsoft.549981C3F5F10",   # Cortana app
    "Microsoft.BingFinance",
    "Microsoft.BingFoodAndDrink",            
    "Microsoft.BingHealthAndFitness",         
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingTranslator",
    "Microsoft.BingTravel",
    "Microsoft.BingWeather",
    "Microsoft.Getstarted",    # Cannot be uninstalled in Windows 11
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftJournal",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftPowerBIForWindows",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MixedReality.Portal",
    # "Microsoft.NetworkSpeedTest",     # Needed in Windows 11
    "Microsoft.News",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.OneConnect",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.XboxApp",        # Old Xbox Console Companion App, no longer supported
    "Microsoft.ZuneVideo",
    "MicrosoftCorporationII.MicrosoftFamily",       # Family Safety App
    "MicrosoftCorporationII.QuickAssist",
    "MicrosoftTeams",       # Old MS Teams personal (MS Store)
    "MSTeams",      # New MS Teams app
    
    ### Third-party apps ###
    # "AmazonVideo.PrimeVideo",
    # "Disney",
    # "Netflix",
    # "Spotify",
    "ACGMediaPlayer",
    "ActiproSoftwareLLC",
    "AdobeSystemsIncorporated.AdobePhotoshopExpress",
    "Amazon.com.Amazon",
    "Asphalt8Airborne",
    "AutodeskSketchBook",
    "CaesarsSlotsFreeCasino",
    "COOKINGFEVER",
    "CyberLinkMediaSuiteEssentials",
    "DisneyMagicKingdoms",
    "DrawboardPDF",
    "Duolingo-LearnLanguagesforFree",
    "EclipseManager",
    "Facebook",
    "FarmVille2CountryEscape",
    "fitbit",
    "Flipboard",
    "HiddenCity",
    "HULULLC.HULUPLUS",
    "iHeartRadio",
    "Instagram",
    "king.com.BubbleWitch3Saga",
    "king.com.CandyCrushSaga",
    "king.com.CandyCrushSodaSaga",
    "LinkedInforWindows",
    "MarchofEmpires",
    "NYTCrossword",
    "OneCalendar",
    "PandoraMediaInc",
    "PhototasticCollage",
    "PicsArt-PhotoStudio",
    "Plex",
    "PolarrPhotoEditorAcademicEdition",
    "Royal Revolt",
    "Shazam",
    "Sidia.LiveWallpaper",
    "SlingTV",
    "TikTok",
    "TuneInRadio",
    "Twitter",
    "Viber",
    "WinZipUniversal",
    "Wunderlist",
    "XING"      # add semi-colon if you add more apps

    # "Microsoft.BingSearch",                   # Web Search from Microsoft Bing (Integrates into Windows Search)
    # "Microsoft.Copilot",                      # New Windows Copilot app
    # "Microsoft.Edge",                         # Edge browser (Can only be uninstalled in European Economic Area)
    # "Microsoft.GetHelp",                      # Required for some Windows 11 Troubleshooters
    # "Microsoft.MSPaint",                      # Paint 3D
    # "Microsoft.OneDrive",                     # OneDrive consumer
    # "Microsoft.Paint",                        # Classic Paint
    # "Microsoft.ScreenSketch",                 # Snipping Tool
    # "Microsoft.Whiteboard",                   # Only preinstalled on devices with touchscreen and/or pen support
    # "Microsoft.Windows.Photos",
    # "Microsoft.WindowsCalculator",
    # "Microsoft.WindowsCamera",
    # "Microsoft.WindowsStore",                 # Microsoft Store, WARNING: This app cannot be reinstalled!
    # "Microsoft.WindowsTerminal",              # New default terminal app in windows 11
    # "Microsoft.Xbox.TCUI",                    # UI framework, seems to be required for MS store, photos and certain games
    # "Microsoft.XboxIdentityProvider",         # Xbox sign-in framework, required for some games
    # "Microsoft.XboxSpeechToTextOverlay",      # Might be required for some games, WARNING: This app cannot be reinstalled!
    # "Microsoft.YourPhone",                    # Phone link
    # "Microsoft.ZuneMusic",                    # Modern Media Player
    # "MicrosoftWindows.CrossDevice",           # Phone integration within File Explorer, Camera and more
    # "Microsoft.GamingApp",                    # Modern Xbox Gaming App, required for installing some PC games
    # "Microsoft.OutlookForWindows",            # New mail app: Outlook for Windows
    # "Microsoft.People",                       # Required for & included with Mail & Calendar
    # "Microsoft.PowerAutomateDesktop",
    # "Microsoft.RemoteDesktop",
    # "Microsoft.Windows.DevHome",
    # "Microsoft.windowscommunicationsapps",    # Mail & Calendar
    # "Microsoft.XboxGameOverlay",              # Game overlay, required/useful for some games
    # "Microsoft.XboxGamingOverlay"             # Game overlay, required/useful for some games
)

#############################################################################################
################################ Don't change anything below ################################
#############################################################################################

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$errorlog = "$DesktopPath\winget_error.log"

function handle_errors {
    param (
        [string]$action,
        [object]$errorobj
    )
    $errorMsg = "Error during $action : $error"
    $errorMsg | Add-Content $errorlog
    Write-Warning $errorMsg
}

function install_apps_by_type {
    param (
        [ValidateSet("Graphical", "Silent", "All")] 
        [string]$type
    )
    if ($type -eq "All" -or $type -eq "Graphical") {
        Write-Host "Installing graphical apps..."
        handle_app_installation $graphical "--interactive" "none"
    }
    if ($type -eq "All" -or $type -eq "Silent") {
        Write-Host "Installing silent apps..."
        handle_app_installation $apps "--silent" "msstore"
    }
}

function handle_app_installation {
    param (
        [array]$appsToInstall,
        [string]$installMode,
        [string]$sourceType
    )
    foreach ($app in $appsToInstall) {
        if ($global:dryRun) {
            Write-Host "[Dry Run] Would install $app in $installMode mode..."
            continue
        }
        try {
            $listAPP = winget list --exact --accept-source-agreements -q $app
            if (![String]::Join("", $listAPP).Contains($app)) {
                Write-Host -ForegroundColor Cyan "Installing $app in $installMode mode..."
                $installArgs = @("--exact", "--accept-source-agreements", "--accept-package-agreements", $app, $installMode)
                if ($sourceType -eq 'msstore') {
                    $installArgs += ("--source", "msstore")
                }
                winget install @installArgs
                if ($LASTEXITCODE -eq 0) {
                    Write-Host -ForegroundColor Green "$app successfully installed."
                } else {
                    throw "Installation failed with exit code $LASTEXITCODE"
                }
            } else {
                Write-Host "$app is already installed. Skip..."
            }
        } catch {
            handle_errors "installing $app" $_
        }
    }
}

function install_winget {
    Write-Host -ForegroundColor Yellow "Checking if WinGet is installed"
    if ($global:dryRun) {
        Write-Host -ForegroundColor Cyan "[Dry Run] Would check for WinGet installation"
        return
    }
    $packages = @{
        'Microsoft.DesktopAppInstaller' = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
        'Microsoft.UI.Xaml.2.7*' = 'https://github.com/Kugane/winget/raw/main/Microsoft.UI.Xaml.2.7_7.2203.17001.0_x64__8wekyb3d8bbwe.Appx'
        'Microsoft.VCLibs.140.00.UWPDesktop' = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
        'Microsoft.Winget.Source' = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
    }
    foreach ($package in $packages.Keys) {
        try {
            $installedPackage = Get-AppxPackage -Name $package -ErrorAction SilentlyContinue
            if (-not $installedPackage) {
                Write-Host -ForegroundColor Yellow "Installing $package..."
                if ($package -eq 'Microsoft.DesktopAppInstaller') {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
                    $releases = Invoke-RestMethod -Uri $packages[$package]
                    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
                    Add-AppxPackage -Path $latestRelease.browser_download_url
                } else {
                    Add-AppxPackage -Path $packages[$package]
                }
                Write-Host -ForegroundColor Green "$package successfully installed."
            } else {
                Write-Host -ForegroundColor Green "$package is already installed. Skip..."
            }
        } catch {
            handle_errors "installing $package" $_
        }
    }
}

function debloating {
    Write-Host -ForegroundColor Cyan "Removing bloatware..."
    foreach ($blt in $bloatware) {
        $packages = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "$blt*" }
        if ($packages) {
            foreach ($package in $packages) {
                Write-Host -ForegroundColor Red "Removing: $($package.Name)"
                if ($global:dryRun) {
                    Write-Host -ForegroundColor Cyan "[Dry Run] Would remove $($package.Name)"
                    continue
                }
                try {
                    if ($package.Name -like "Microsoft.MicrosoftEdge*" -or $package.Name -like "Microsoft.OneDrive*") {
                        winget uninstall --exact --silent --accept-source-agreements --accept-package-agreements $package.Name
                    } else {
                        $package | Remove-AppxPackage
                    }
                    Write-Host -ForegroundColor Green "$($package.Name) removed successfully."
                } catch {
                    handle_errors "removing $package.Name" $_
                }
            }
        } else {
            Write-Host "$blt not found. Skip..."
        }
    }
}

function taskjob {
    $taskname = 'WinGet AutoUpgrade & Cleanup'
    Write-Host -ForegroundColor Yellow "Checking for Taskjob..."
    if ($global:dryRun) {
        Write-Host -ForegroundColor Cyan "[Dry Run] Would check for task job $taskname"
        return
    }
    try {
        $taskExists = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
        if ($taskExists) {
            Write-Host -ForegroundColor Yellow "Taskjob already exists. Do you want to update to newer version? (y/n)"
            $update = Read-Host
            if ($update -match '^[yY]$') {
                Write-Host -ForegroundColor Yellow "Taskjob updating..."
                Unregister-ScheduledTask -TaskName $taskname -Confirm:$False -ErrorAction SilentlyContinue
            } else {
                Write-Warning "Taskjob not updated."
                Pause
                Menu
            }
        } else {
            Write-Host -ForegroundColor Yellow "Installing taskjob..."
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
        $taskjobPath = "$env:TEMP\WinGet_AutoUpgrade_Cleanup.xml"
        Invoke-WebRequest -Uri "https://github.com/Kugane/winget/raw/main/WinGet%20AutoUpgrade%20%26%20Cleanup.xml" -OutFile $taskjobPath
        Register-ScheduledTask -xml (Get-Content $taskjobPath | Out-String) -TaskName $taskname
        Write-Host -ForegroundColor Green "Taskjob successfully $(if ($taskExists) { 'updated' } else { 'installed' })."
    } catch {
        handle_errors "processing task job $taskname" $_
    }
}

function get_list {
    $newPath = "$DesktopPath\applist_$env:COMPUTERNAME" + "_" + (Get-Date -Format 'yyyy_MM_dd') + ".txt"
    Write-Host -ForegroundColor Yellow "Generating Applist..."
    if ($global:dryRun) {
        Write-Host -ForegroundColor Cyan "[Dry Run] Would generate app list and save to $newPath"
        return
    }
    try {
        winget list | Out-File -FilePath $newPath -Encoding utf8
        Write-Host -ForegroundColor Magenta "List saved in $newPath"
    } catch {
        handle_errors "generating app list" $_
    }
}

function reset_winget_sources {
    Write-Host -ForegroundColor Yellow "Attempting to reset Winget sources..."
    try {
        winget source reset --force
        Write-Host -ForegroundColor Green "Winget sources reset successfully."
    } catch {
        Write-Host -ForegroundColor Red "Failed to reset Winget sources: $_"
        handle_errors "resetting winget sources" $_
    }
}

function export_winget_list {
    $exportPath = "$DesktopPath\$env:COMPUTERNAME.json"
    $index = 1
    while (Test-Path $exportPath) {
        $exportPath = "$DesktopPath\$env:COMPUTERNAME" + "_$index.json"
        $index++
    }
    Write-Host -ForegroundColor Yellow "Exporting installed applications to $exportPath"
    try {
        winget export -o $exportPath
        if (Test-Path $exportPath) {
            Write-Host -ForegroundColor Green "Export completed successfully. File saved as $exportPath"
        } else {
            throw "Export failed. File was not created."
        }
    } catch {
        Write-Host -ForegroundColor Red "Error during export: $_"
        handle_errors "exporting winget list" $_

        Write-Host -ForegroundColor Yellow "Attempting to fix the issue and retry export..."
        reset_winget_sources
        try {
            winget export -o $exportPath
            if (Test-Path $exportPath) {
                Write-Host -ForegroundColor Green "Retry successful. Export completed successfully. File saved as $exportPath"
            } else {
                Write-Host -ForegroundColor Red "Retry failed. File was not created after fixing the issue."
            }
        } catch {
            Write-Host -ForegroundColor Red "Retry after fix failed: $_"
            handle_errors "retrying export after fixing" $_
        }
    }
}

function import_winget_list {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "JSON files (*.json)|*.json"
    $openFileDialog.Title = "Select a JSON file to import"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $importPath = $openFileDialog.FileName
    } else {
        Write-Host -ForegroundColor Red "No file selected. Aborting import."
        Pause
        menu
    }
    try {
        $fileContent = Get-Content -Path $importPath -Raw
        $jsonData = $fileContent | ConvertFrom-Json
        if ($jsonData.'$schema' -ne "https://aka.ms/winget-packages.schema.2.0.json") {
            Write-Host -ForegroundColor Red "The file does not contain the correct Winget schema. Please provide a valid Winget export file."
            Pause
            menu
        }
    } catch {
        Write-Host -ForegroundColor Red "Error reading the file: $_"
        handle_errors "reading the json file" $_
        Pause
        menu
    }
    try {
        Write-Host -ForegroundColor Yellow "Importing applications from $importPath"
        winget import -i $importPath --accept-source-agreements --accept-package-agreements
        Write-Host -ForegroundColor Green "Import completed successfully."
    } catch {
        Write-Host -ForegroundColor Red "Error during import: $_"
        handle_errors "importing winget list" $_
    }
}

function finish {
    Write-Host 
    Write-Host -ForegroundColor Magenta "Installation finished"
    Write-Host 
    Pause
    Clear-Host
}

function check_rights {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "The script needs to be executed with administrator privileges."
        Write-Host "Restarting script with elevated privileges..."
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

Add-Type -AssemblyName System.Windows.Forms
function set_console_background {
    [console]::BackgroundColor = 'Black'
    [console]::ForegroundColor = 'White'
    Clear-Host
}

function toggle_dry_run {
    $global:dryRun = -not $global:dryRun
    menu
}

function menu {
    [string]$Title = 'Winget Menu'
    function Show-Menu {
        Write-Host "================ $Title ================"
        Write-Host
        Write-Host " 1: Do all steps below"
        Write-Host " 2: Just install winget"
        Write-Host
        Write-Host " 3: Install all Apps"
        Write-Host " 4: Install Apps under graphical"
        Write-Host " 5: Install Apps under apps"
        Write-Host
        Write-Host " 6: Remove bloatware"
        Write-Host " 7: Install Taskjob for automatic updates"
        Write-Host
        Write-Host " 8: Get simple List of all installed Apps"
        Write-Host " 9: Export json config of installed Apps"
        Write-Host "10: Import json config of installed Apps"
        Write-Host
        Write-Host
        if ($global:dryRun) {
            $dryRunStatus = 'enabled'
            $dryRunColor = 'Green'
        } else {
            $dryRunStatus = 'disabled'
            $dryRunColor = 'Red'
        }
        Write-Host -ForegroundColor Yellow "11: Toggle Dry Run mode (currently " -NoNewline
        Write-Host -ForegroundColor $dryRunColor "$dryRunStatus" -NoNewline
        Write-Host -ForegroundColor Yellow ")"          
        Write-Host
        Write-Host -ForegroundColor Magenta "0: Quit"
        Write-Host
    }
    Clear-Host
    set_console_background
    Show-Menu

    $actions = "0"
    while ($actions -notin "0..11") {
        $actions = Read-Host -Prompt 'What you want to do?'
        switch ($actions) {
            0 { exit }
            # Do all steps
            1 {
                install_winget
                install_apps_by_type -type "All"
                debloating
                taskjob
                finish
                Show-Menu
            }
            # Just install winget
            2 {
                install_winget
                finish
                Show-Menu
            }
            # Install all Apps
            3 {
                install_winget
                install_apps_by_type -type "All"
                finish
                Show-Menu
            }
            # Install Apps under graphical
            4 {
                install_winget
                install_apps_by_type -type "Graphical"
                finish
                Show-Menu
            }
            # Install Apps under apps
            5 {
                install_winget
                install_apps_by_type -type "Silent"
                finish
                Show-Menu
            }
            # Remove bloatware
            6 {
                debloating
                finish
                Show-Menu
            }
            # Install Taskjob for automatic updates
            7 {
                taskjob
                finish
                Show-Menu
            }
            # Get simple List of all installed Apps
            8 {
                install_winget
                get_list
                finish
                Show-Menu
            }
            # Export json config of installed Apps
            9 {
                export_winget_list
                Show-Menu
            }
            # Import json config of installed Apps
            10 {
                import_winget_list
                Show-Menu
            }
            # Toggle Dry Run mode
            11 {
                toggle_dry_run
                Show-Menu
            }
            default {
                Clear-Host
                set_console_background
                Show-Menu
            }
        }
    }
}
check_rights
set_console_background
menu
