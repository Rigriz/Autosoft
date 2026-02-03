$ErrorActionPreference = "Stop"

function Log {
    param ($Message)
    Write-Host "[INSTALL] $Message"
}

function Download-File {
    param (
        [string]$Url,
        [string]$Destination,
        [string]$Name
    )

    Log "Downloading $Name..."
    Start-BitsTransfer `
        -Source $Url `
        -Destination $Destination `
        -DisplayName "Downloading $Name" `
        -Description "$Name Installer Download"
}

function Install-ChromeDev {
    $Url = "https://dl.google.com/tag/s/appguid%3D%7B401C381F-E0DE-4B85-8BD8-3F3F14FBDA57%7D%26iid%3D%7BE9423A56-462B-C1C4-B510-FDB514F60967%7D%26lang%3Den-GB%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Dev%26needsadmin%3Dprefers%26ap%3Dx64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"
    $Installer = "$env:TEMP\ChromeDevPortable.exe"

    Download-File $Url $Installer "Chrome Dev Portable"

    Log "Installing Chrome Dev Portable..."
    Start-Process -FilePath $Installer -ArgumentList "/VERYSILENT /NORESTART" -Wait

    Remove-Item $Installer -Force
    Log "Chrome Dev Portable installed."
}


function Install-VSCode {
    $Url = "https://update.code.visualstudio.com/latest/win32-x64-user/stable"
    $Installer = "$env:TEMP\VSCodeSetup.exe"

    Download-File $Url $Installer "Visual Studio Code"

    Log "Installing VS Code..."
    Start-Process -FilePath $Installer -ArgumentList "/silent /mergetasks=!runcode" -Wait

    Remove-Item $Installer -Force
    Log "VS Code installed."
}

function Show-Menu {
    Clear-Host
    Write-Host "=============================="
    Write-Host "   Custom Installer Menu"
    Write-Host "=============================="
    Write-Host "1) Install Chrome Dev"
    Write-Host "2) Install VS Code"
    Write-Host "3) Install Chrome Dev + VS Code"
    Write-Host "4) Exit"
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" {
            Install-ChromeDev
            Pause
        }
        "2" {
            Install-VSCode
            Pause
        }
        "3" {
            Install-ChromeDev
            Install-VSCode
            Pause
        }
        "4" {
            Log "Exiting installer."
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Pause
        }
    }
} while ($choice -ne "4")
