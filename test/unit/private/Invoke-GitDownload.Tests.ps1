$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\vscodeinstaller\" -FileName $lData


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Invoke-GitDownload' {

        $verboseCapture = "TestDrive:\Capture.txt"

        mock -ModuleName $ThisModuleName -CommandName 'Invoke-WebRequest' {
            [pscustomobject]@{
                Links = @(
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1.windows.1/Git-2.20.1-32-bit.exe'}
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1.windows.1/Git-2.20.1-64-bit.exe'}
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1.windows.1/Git-1.90.1-32-bit.exe'}
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1.windows.1/Git-1.90.1-64-bit.exe'}
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1/PortableGit-2.20.1-32-bit.7z.exe'}
                    @{ href = 'https://github.com/git-for-windows/git/v2.20.1/PortableGit-2.20.1-64-bit.7z.exe'}
                )
            }
        }

        it 'should download the 64 Bit Git version if parameter Architecture with value x64 is selected' {
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock\mock.exe'
            }

            mock -ModuleName $ThisModuleName -CommandName 'Invoke-Download' {
                return 'C:\Mock\mock.exe'
            }
            (Invoke-GitDownload -Verbose) 4> $verboseCapture
            $file = 'Git-2.20.1-64-bit.exe'
            $msg = $localized.TryToDownloadFile -f $file, 'github.com'
            Get-Content $verboseCapture | Should Match ([regex]::Escape($msg))
        }

        it 'should download the 32 Bit Git version if parameter Architecture with value x86 is selected' {
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock\mock.exe'
            }
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-Download' {
                return 'C:\Mock\mock.exe'
            }
            (Invoke-GitDownload -Architecture 'x86' -Verbose) 4> $verboseCapture
            $file = 'Git-2.20.1-32-bit.exe'
            $msg = $localized.TryToDownloadFile -f $file, 'github.com'
            Get-Content $verboseCapture | Should Match ([regex]::Escape($msg))
        }

        it 'should throw if call of inner function [Invoke-Webrequest] fails' {
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-WebRequest' {
                Write-Error 'Mock Error.'
            }
            $uri = 'https://git-scm.com/download/win'
            $msg = $localized.WebResourceDownloadFailedError -f $uri
            { Invoke-GitDownload } | should throw $msg
        }

        it 'should call Invoke-Download 1 time.' {
            mock -ModuleName $ThisModuleName -CommandName Invoke-Webrequest -MockWith {
                'Mock'
            }
            mock -ModuleName $ThisModuleName -CommandName Select-String -MockWith {
                'Mock'
            }
            mock -ModuleName $ThisModuleName -CommandName Join-Path -MockWith {
                'Mock'
            }
            mock -ModuleName $ThisModuleName -CommandName Invoke-Download -MockWith {
                return $true
            }
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock'
            }
            Invoke-GitDownload
            Assert-MockCalled -CommandName Invoke-Download -Exactly 1 -Scope It
        }

        it 'should call Get-Item 1 time.' {
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock'
            }
            Invoke-GitDownload
            Assert-MockCalled -CommandName Get-Item -Exactly 1 -Scope It
        }
    }
}