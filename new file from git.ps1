                                                                                              param(
    # provide a configuration file to define package handling
    [string] $skipFile = "wngt-cfg",
    # true to upgrade eligible packages, false dry run
    [switch] $upgrade = $false
)

[string] $source = "winget"

# get raw output of available upgrades, not power-shell native yet
[string[]] $source = winget upgrade --source $source

# check if available upgrades succeeded, otherwise display message to user
if ($lastExitCode -ne 0) {
    Write-Host
    Write-Host checking winget upgrade failed, try again -ForegroundColor Red
    Write-Host
    exit $lastExitCode
}

# load and parse a skip list definition file if it exists, otherwise ignore skips
[string[]] $skip = if (Test-Path -Path $skipFile -PathType Leaf) {
    Get-Content $skipFile | ForEach-Object {
        $_.Split('#')[0].Trim()
    }
} else {
    @("") # otherwise $skip is null
}

# check if package matches any of the listed skip packages
function Skip-Update {
    param ([string] $name)

    foreach ($skipped in $skip) {
        if ($name.Trim() -like $skipped) {
            return $true
        }
    }

    return $false
}

# find the index of title line, sometimes winget outputs unpredictably up until the title line
[int32] $titleLine = ($source | Select-String -Pattern "Id" | Select-Object -Expand LineNumber -First 1) - 1

# check if upgrades exist
if ($titleLine -lt 0) {
    Write-Host
    Write-Host no upgrades available
    Write-Host
    exit
}

# get all the indexes of column titles for parsing
[int32] $idIndex = $source[$titleLine].IndexOf("Id")
[int32] $currentIndex = $source[$titleLine].IndexOf("Version")
[int32] $availableIndex = $source[$titleLine].IndexOf("Available")
[int32] $sourceIndex = $source[$titleLine].IndexOf("Source")

# fail if any of the indexes could not be determined
if ($null -eq $idIndex -or $null -eq $currentIndex -or $null -eq $availableIndex -or $null -eq $sourceIndex) {
    Write-Host
    Write-Host winget failed because garbled output, try again -ForegroundColor Yellow
    Write-Host
    exit -1
}

# parse all of the listed packages into an object; Package { Name, Id, Current, Available, Source, Skip }
[PSCustomObject[]] $updates = $source | Select-Object -Skip $($titleLine + 2) | Select-Object -SkipLast 1 | ForEach-Object { 
    [string] $name      = $_.SubString(0, $idIndex).Trim()
    [string] $id        = $_.SubString($idIndex, $currentIndex - $idIndex).Trim()
    [string] $current   = $_.SubString($currentIndex, $availableIndex - $currentIndex).Trim()
    [int32]  $availLen  = if ($sourceIndex -lt 0) { $_.Length } else { $sourceIndex }
    [string] $available = $_.SubString($availableIndex, $availLen - $availableIndex).Trim()
    [string] $source    = if ($sourceIndex -lt 0) { $source } else { $_.SubString($sourceIndex, $_.Length - $sourceIndex).Trim() }

    [PSCustomObject] @{
        Name      = $name
        Id        = $id
        Current   = $Current
        Available = $available
        Source    = $source
        Skip      = Skip-Update $name
    }
}

# determine the widest package name for column padding
[int32] $namePadding = ($updates | ForEach-Object { $_.Name.Length } | Measure-Object -Maximum | Select-Object -Property Maximum).Maximum + 2
# determin the widest package version for column padding
[int32] $versionPadding = ($updates | ForEach-Object { [math]::Max($_.Current.Length, $_.Available.Length) } | Measure-Object -Maximum | Select-Object -Property Maximum).Maximum + 2
# const status width padding
[int32] $statusWidth = 42  # ironic? or cosmic? =P

#table variable size column titles
[string] $nameTitle = "Name"
[string] $currentTitle = "Current"
[string] $availableTitle = "Available"
[int32] $extraPadding = 2

# account for padding shorter than titles
$namePadding = [Math]::Max($namePadding, $nameTitle.Length + $extraPadding)
$versionPadding = [Math]::Max([Math]::Max($versionPadding, $currentTitle.Length + $extraPadding), $availableTitle.Length + $extraPadding)

# write table column titles
Write-Host
Write-Host $nameTitle.PadRight($namePadding, ' ')  $currentTitle.PadLeft($versionPadding, ' ') $availableTitle.PadLeft($versionPadding, ' ') "  Status"
Write-Host ("-" * $namePadding) ("-" * $versionPadding) ("-" * $versionPadding) " " ("-" * $statusWidth)
Write-Host

# process each package
foreach ($package in $updates) {
    # output package info coumns
    Write-Host $package.Name.PadRight($namePadding) $package.Current.PadLeft($versionPadding, ' ') $package.Available.PadLeft($versionPadding, ' ') "- " -NoNewline

    # check if package should be skipped?
    if ($package.Skip) {
        # output package status
        Write-Host "skipping" -ForegroundColor DarkYellow
        if ($upgrade) { Write-Host }
    } else {
        # check if package version is unknown
        if ($package.Current -eq "Unknown") {
            # output package status
            Write-Host "skipping unknown version, check manually" -ForegroundColor Cyan
            if ($upgrade) { Write-Host }
        } else {
            # temporary check if any properties have unicode garbled text
            # this is only until winget piped output is fixed or supports power-shell natively
            [bool] $garbled = (
                $package.Name.EndsWith("ΓÇ") -or
                $package.Id.EndsWith("ΓÇ") -or $package.Id.StartsWith("ª ") -or
                $package.Current.EndsWith("ΓÇ") -or $package.Current.StartsWith("ª ") -or
                $package.Available.EndsWith("ΓÇ") -or $package.Available.StartsWith("ª ") -or
                $package.Source.EndsWith("ΓÇ") -or $package.Source.StartsWith("ª ")
            )

            # check if packages should upgraded
            if ($upgrade) {
                # check if any property is garbled
                if ($garbled) {
                    # output package status and continue to next package
                    Write-Host "skipping, garbled identifiers prevents update" -ForegroundColor Yellow
                } else {
                    # perform package upgrade, capture output
                    [string[]] $result = winget upgrade --exact --name """$($package.Name)""" --id """$($package.Id)""" --version """$($package.Available)""" --source winget

                    # check if package upgrade succeeded and output package status accordingly
                    if ($lastExitCode -eq 0) {
                        Write-Host "updated" -ForegroundColor Blue
                    } else {
                        Write-Host "failed to update" -ForegroundColor Red
                        Write-Host
                        # demonstrate command used for upgrade
                        Write-Host ">" winget upgrade --exact --name """$($package.Name)""" --id """$($package.Id)""" --version """$($package.Available)""" --source winget -ForegroundColor Yellow
                        Write-Host
                        # output captured output from package upgrade
                        foreach ($line in $result) {
                            Write-Host $line -ForegroundColor DarkGray
                        }
                        Write-Host
                        Write-Host "* might require admin privledges" -ForegroundColor Yellow
                    }
                }

                Write-Host
            } else {
                # check if any property is garbled and output package status accordingly 
                if ($garbled) {
                    Write-Host "skipping new version, garbled identifiers prevent update" -ForegroundColor Yellow
                } else {
                    Write-Host "new version available" -ForegroundColor Blue
                }
            }
        }
    }
}

Write-Host