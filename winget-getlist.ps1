# Created by Kugane

### Install WinGet ###
# Based on this gist: https://gist.github.com/crutkas/6c2096eae387e544bd05cde246f23901

$hasPackageManager = Get-AppxPackage -Name 'Microsoft.Winget.Source' | Select Name, Version
$hasVCLibs = Get-AppxPackage -Name 'Microsoft.VCLibs.140.00.UWPDesktop' | Select Name, Version
$hasXAML = Get-AppxPackage -Name 'Microsoft.UI.Xaml.2.7*' | Select Name, Version
$hasAppInstaller = Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' | Select Name, Version

Write-Host -ForegroundColor Yellow "Checking if WinGet is installed"
if (!$hasPackageManager) {
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
            Add-AppxPackage -Path "https://github.com/Kugane/winget/raw/main/Microsoft.UI.Xaml.2.7_7.2203.17001.0_x64__8wekyb3d8bbwe.Appx"
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

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
Write-Host -ForegroundColor Yellow "Generating Applist..."
winget list > "$DesktopPath\$env:computername_winget.txt"
Write-Host -ForegroundColor Magenta "List saved on $DesktopPath\$env:computername_winget.txt"
Pause