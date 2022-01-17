# Created by Kugane

# Install WinGet
# Based on this gist: https://gist.github.com/crutkas/6c2096eae387e54bd05cde246f23901

$hasPackageManager = Get-AppXPackage -name 'Microsoft.Winget.Source'
$hasVCLibs = Get-AppXPackage -name 'Microsoft.VCLibs.140.00.UWPDesktop'
$hasAppInstaller = Get-AppXPackage -name 'Microsoft.DesktopAppInstaller'

if (!$hasPackageManager -or !$hasPackageManager.Version -lt "1.1.12653") {

    Write-Host -ForegroundColor Yellow "Checking if WinGet is installed"

    if ($hasVCLibs.Version -lt "14.0.30035.0") {

        Write-Host -ForegroundColor Yellow "Installing VCLibs dependencies..."

        #Get-AppXPackage 'Microsoft.DesktopAppInstaller' -AllUsers | Foreach {Add-AppXPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
        Add-AppxPackage -Path https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx
        Add-AppxPackage -Path https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx

        Write-Host -ForegroundColor Green "VCLibs dependencies successfully installed."
        }
        else {
            Write-Host -ForegroundColor Yellow "VCLibs is already installed. Skip..."
        }
    if ($hasAppInstaller.Version -lt "1.16.12653.0" -or !$hasPackageManager) {

        Write-Host -ForegroundColor Yellow "Installing WinGet..."

	    $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$releases = Invoke-RestMethod -uri "$($releases_url)"
		$latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
		Add-AppxPackage -Path $latestRelease.browser_download_url

        Write-Host -ForegroundColor Green "WinGet successfully installed."
    }
else {
    Write-Host -ForegroundColor Green "WinGet is already installed. Skip..."
    }
}
Pause
Clear-Host

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
winget list > "$DesktopPath\winget.txt"


Write-Host -ForegroundColor Magenta  "List saved on $DesktopPath\winget.txt"
Pause