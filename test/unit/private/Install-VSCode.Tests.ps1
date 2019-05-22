$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Install-VSCode' {

        it 'should throw if Visual Studio Code installation fails' {
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                Write-Error 'PowerShell Core Mock installation failed.'
            }
            { Install-VSCode -FilePath } | should throw
        }

        it 'should return exitcode 1638 if Visual Studio Code is already installed' {
            mock -ModuleName $ThisModuleName -CommandName Resolve-Path -MockWith {
                [PSCustomObject]@{
                    Path = 'C:\Program Files\Microsoft VS Code\binx\code.cmd'
                }
            }
            Install-VSCode -FilePath 'C:\MockFakePath' | should be 1638
        }
    }
}