$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\vscodeinstaller\" -FileName $lData


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Invoke-PSCoreDownload' {

        $verboseCapture = "TestDrive:\Capture.txt"
        $testCases =  @(
            @{
                Arch  = 'x64'
                PreviewVer = $true
                PreviewVerTxt = ' '
                Previewtxt = 'Preview '
                PSCoreFile = 'PowerShell-6.2.0-preview.3-win-x64.msi'
            }
            @{
                Arch  = 'x64'
                PreviewVer = $false
                PreviewVerTxt = 'not '
                Previewtxt = ' '
                PSCoreFile = 'PowerShell-6.1.1-win-x64.msi'
            }
            @{
                Arch  = 'x86'
                PreviewVer = $true
                PreviewVerTxt = ' '
                Previewtxt = 'Preview '
                PSCoreFile = 'PowerShell-6.2.0-preview.3-win-x86.msi'
            }
            @{
                Arch  = 'x86'
                PreviewVer = $false
                PreviewVerTxt = 'not '
                Previewtxt = ' '
                PSCoreFile = 'PowerShell-6.1.1-win-x86.msi'
            }
        )

        mock -ModuleName $ThisModuleName -CommandName 'Invoke-WebRequest' {
            [pscustomobject]@{
                Links = @(
                    @{ href = '/PowerShell/PowerShell/v6.2.0-preview.3/PowerShell-6.2.0-preview.3-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.2.0-preview.3/PowerShell-6.2.0-preview.3-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.2.0-preview.2/PowerShell-6.2.0-preview.2-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.2.0-preview.2/PowerShell-6.2.0-preview.2-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.1/PowerShell-6.1.1-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.1/PowerShell-6.1.1-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0/PowerShell-6.1.0-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0/PowerShell-6.1.0-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0-rc.1/PowerShell-6.1.0-rc.1-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0-rc.1/PowerShell-6.1.0-rc.1-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.0.4/PowerShell-6.0.4-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.0.4/PowerShell-6.0.4-win-x86.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0-preview.4/PowerShell-6.1.0-preview.4-win-x64.msi'}
                    @{ href = '/PowerShell/PowerShell/v6.1.0-preview.4/PowerShell-6.1.0-preview.4-win-x86.msi'}
                )
            }
        }

        it 'should try to download the <Arch> <Previewtxt>version if parameter Architecture [<Arch>] and parameter PreviewVersion is <PreviewVerTxt>selected' -TestCases $testCases {
            param(
                [System.String] $Architecture,
                $PreviewVer,
                $Previewtxt,
                $PSCoreFile
            )
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock\mock.exe'
            }
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-Download' {
                return 'C:\Mock\mock.exe'
            }
            $ipdParam = @{
                Architecture = $Architecture
                PreviewVersion = $PreviewVer
                Verbose = $true
            }
            (Invoke-PSCoreDownload @ipdParam) 4> $verboseCapture
            $msg = $localized.TryToDownloadFile -f $PSCoreFile, $localized.GitHub
            Get-Content $verboseCapture | Should Match ([regex]::Escape($msg))
        }

        it 'should try to download the latest x64 non preview version if no parameter is selected' {
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock\mock.exe'
            }
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-Download' {
                return 'C:\Mock\mock.exe'
            }
            (Invoke-PSCoreDownload -Verbose) 4> $verboseCapture
            $file = 'PowerShell-6.1.1-win-x64.msi'
            $msg = $localized.TryToDownloadFile -f $file, $localized.GitHub
            Get-Content $verboseCapture | Should Match ([regex]::Escape($msg))
        }

        it 'should throw if call of inner function [Invoke-Webrequest] fails' {
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-WebRequest' {
                $false
            }
            { Invoke-PSCoreDownload } | should throw
        }
    }
}
