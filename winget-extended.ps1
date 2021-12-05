# Created by Kugane

# Install New apps

Write-Host -ForegroundColor Cyan "Installing new Apps"

$apps = @(
    @{name = "SteelSeries.GG" },
    @{name = "9NF8H0H7WMLT"; source = "msstore" }		# NVIDIA Control Panel
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
Write-Host -ForegroundColor Magenta  "Installation finished"
Pause