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
    $Url = "https://dl.google.com/dl/chrome/install/dev/googlechromedevstandaloneenterprise64.msi"
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
