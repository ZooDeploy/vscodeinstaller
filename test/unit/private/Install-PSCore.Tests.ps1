$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Install-PSCore' {

        it 'should return exitcode 1638 if PowerShell Core is already installed' {
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
            Install-PSCore -FilePath 'C:\MockFakePath' | should be 1638
        }

        it 'should call Start-Process 1 time if PowerShell Core is not installed' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    DisplayName = 'mock'
                }
            }
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                return 0
            }
            Install-PSCore -FilePath 'C:\MockFakePath'
            Assert-MockCalled -CommandName Start-Process -Exactly 1 -Scope It
        }

        it 'should throw if PowerShell Core installation fails' {
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                Write-Error 'PowerShell Core Mock installation failed.'
            }
            { Install-PSCore -FilePath 'C:\MockFakePath' } | should throw
        }
    }
}