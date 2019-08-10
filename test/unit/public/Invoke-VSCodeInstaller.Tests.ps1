$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\data" -FileName $lData


Describe 'Unit tests for function Invoke-VSCodeInstaller' {

    $verboseCapture = "TestDrive:\Capture.txt"

    mock -ModuleName $ThisModuleName -CommandName Write-Progress {
    }

    it "should call 'Install-VSCodeExtension' 1 time if 1 'Visual Studio Code extensions' is handed over." {
        $extensions = @(
            'ahmadawais.shades-of-purple'
        )
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            [PSCustomObject]@{
                Publisher = 'dracula-theme'
                Name = 'theme-dracula'
                Version = '2.17.0'
            }
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
        }
        Invoke-VSCodeInstaller -SkipGitInstallation -AdditionalExtensions $extensions
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName 'Install-VSCodeExtension' -Exactly 1 -Scope It
    }

    it "should call 'Get-InstalledVSCodeExtension' 1 time if an 'Visual Studio Code extension' is handed over." {
        $extensions = @('ahmadawais.shades-of-purple')

        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
        }
        Invoke-VSCodeInstaller -SkipGitInstallation -AdditionalExtensions $extensions
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName 'Get-InstalledVSCodeExtension' -Exactly 1 -Scope It
    }

    it "should call 'Install-VSCodeExtension' 2 times if 2 'Visual Studio Code extensions' are handed over." {
        $extensions = @(
            'ahmadawais.shades-of-purple',
            'wesbos.theme-cobalt2'
        )
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            [PSCustomObject]@{
                Publisher = 'dracula-theme'
                Name = 'theme-dracula'
                Version = '2.17.0'
            }
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
        }
        mock -ModuleName $ThisModuleName -CommandName Set-VSCodeUserSetting {
        }
        Invoke-VSCodeInstaller -SkipGitInstallation -AdditionalExtensions $extensions
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName 'Install-VSCodeExtension' -Exactly 2 -Scope It
    }

    it "should display the correct Write-Verbose message if 'Git' is already installed" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Test-Path {
            $true
        }
        $msg = $localized.SoftwareIsAlreadyInstalled -f $localized.Git
        (Invoke-VSCodeInstaller -Verbose) 4> $verboseCapture
        (Get-Content $verboseCapture)[1] | Should Match ([regex]::Escape($msg))
    }

    it "should display the correct Write-Verbose message if 'SkipGitInstallation' is selected" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        (Invoke-VSCodeInstaller -Verbose -SkipGitInstallation) 4> $verboseCapture
        (Get-Content $verboseCapture)[1] | Should Match ([regex]::Escape($localized.SkipGitInstallation))
    }

    it "should display the correct Write-Verbose message if 'PowerShellCore' is already installed" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Get-ChildItem -MockWith {
            [PSCustomObject]@{
                PSPath = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\'
            }
        }
        mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
            [PSCustomObject]@{
                DisplayName = 'PowerShell 7-preview-x64'
            }
        }
        mock -ModuleName $ThisModuleName -CommandName Write-Progress {
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName ForEach-Object {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName New-ShellLauncherConfiguration {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Set-VSCodeUserSetting {
        }
        $msg = $localized.SoftwareIsAlreadyInstalled -f $localized.PSCore
        (Invoke-VSCodeInstaller -Verbose -SkipGitInstallation -Template 'PowerShellCore') 4> $verboseCapture
        (Get-Content $verboseCapture)[0] | Should Match ([regex]::Escape($msg))
    }

    it "should display the correct Write-Verbose message if 'Visual Studio Code' is already installed" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        $verboseCapture = "TestDrive:\Verbose.txt"
        $msg = $localized.SoftwareIsAlreadyInstalled -f $localized.VSCode
        (Invoke-VSCodeInstaller -Verbose -SkipGitInstallation) 4> $verboseCapture
        (Get-Content $verboseCapture)[0] | Should Match ([regex]::Escape($msg))
    }

    it 'should display the correct Write-Verbose message if no template data could be imported' {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Import-LocalizedData {
        }
        mock -ModuleName $ThisModuleName -CommandName Where-Object {
            $null
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
        }
        $template = 'MockTemplate'
        (Invoke-VSCodeInstaller -SkipGitInstallation -Template $template -Verbose) 4> $verboseCapture
        (Get-Content $verboseCapture)[0] | Should Match ([regex]::Escape($localized.ImportTemplateError))
    }

    it "should call 'Invoke-VSCodeDownload' and 'Install-VSCode' 1 time if 'Visual Studio Code' is not installed." {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Write-Progress {
        }
        mock -ModuleName $ThisModuleName -CommandName Invoke-VSCodeDownload {
            [System.IO.FileInfo]'C:\Mock'
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCode {
        }
        mock -ModuleName $ThisModuleName -CommandName Remove-Item {
        }
        Invoke-VSCodeInstaller -SkipGitInstallation
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Invoke-VSCodeDownload -Exactly 1 -Scope It
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Install-VSCode -Exactly 1 -Scope It
    }

    it "should call 'Invoke-GitDownload' and 'Install-Git' 1 time if 'Git' is not installed." {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Test-Path {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Write-Progress {
        }
        mock -ModuleName $ThisModuleName -CommandName Invoke-GitDownload {
            [System.IO.FileInfo]'C:\Mock'
        }
        mock -ModuleName $ThisModuleName -CommandName Install-Git {
        }
        mock -ModuleName $ThisModuleName -CommandName Remove-Item {
        }
        Invoke-VSCodeInstaller
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Invoke-GitDownload -Exactly 1 -Scope It
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Install-Git -Exactly 1 -Scope It
    }

    it "should call 'Invoke-PSCoreDownload' and 'Install-PSCore' 1 time if 'PowerShell Core' is not installed." {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName Write-Progress {
        }
        mock -ModuleName $ThisModuleName -CommandName Invoke-PSCoreDownload {
            [System.IO.FileInfo]'C:\Mock'
        }
        mock -ModuleName $ThisModuleName -CommandName Install-PSCore {
        }
        mock -ModuleName $ThisModuleName -CommandName Get-InstalledVSCodeExtension {
            $true
        }
        mock -ModuleName $ThisModuleName -CommandName ForEach-Object {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Install-VSCodeExtension {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName New-ShellLauncherConfiguration {
            $false
        }
        mock -ModuleName $ThisModuleName -CommandName Set-VSCodeUserSetting {
        }
        mock -ModuleName $ThisModuleName -CommandName Remove-Item {
        }
        Invoke-VSCodeInstaller -SkipGitInstallation -Template 'PowerShellCore'
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Invoke-PSCoreDownload -Exactly 1 -Scope It
        Assert-MockCalled -ModuleName $ThisModuleName -CommandName Install-PSCore -Exactly 1 -Scope It
    }
}