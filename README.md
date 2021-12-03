# A Winget script to automatically install predefined programs and MS Store apps. Including automatic update and cleanup job
#
## Features

- Easy to use
- Does not require any additional tools
- Checks if winget is installed, otherwise the installation starts
- Drag&Drop script for executing powershell scripts and install packages with winget
- Automatic scheduled updates for installed packages
- Automatic log cleanup 
#
## Installation


Download the [latest release]

Edit **winget-basic.ps1** to your liking!

Any packages added to this section will be installed with GUI for you to configure.

```sh
$graphical = @(
    @{name = "ClamWin.ClamWin" }
);
```
#
All packages in this section will be installed silently. 
You can also install msstore apps, just as you can see below.
If you chose to install more packages, please separate them with a  ***comma ","***
```sh
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
```

#
## Usage

- Just **Drag&Drop** your **.ps1** on the **"Execute winget.bat"**
There will be a pop-up for admin rights which you will have to accept.
After that the powershell script will run and pause after each section to let you check what happend.

# Add automatic updates and cleanup job
- Open your Windows Task Scheduler 
- Import the **WinGet AutoUpgrade & Cleanup.xml**
- That's it!
#

#
## License

GNU General Public License v3.0



