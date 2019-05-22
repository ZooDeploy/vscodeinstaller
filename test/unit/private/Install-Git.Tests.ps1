$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Install-Git' {

        mock -ModuleName $ThisModuleName -CommandName Start-DiagnosticsProcess -MockWith {
            'Mock User Mock Email'
        }

        it 'should return exitcode 1603 if Git is already installed' {
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                return $true
            }
            Install-Git -FilePath 'C:\MockFakePath' | should be 1638
        }

        it 'should call Start-DiagnosticsProcess 4 times' {
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                $false
            }
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                return 0
            }
            mock -ModuleName $ThisModuleName -CommandName Resolve-Path -MockWith {
                [PSCustomObject]@{
                    Path = 'C:\Program Files\Microsoft VS Code\binx\code.cmd'
                }
            }
            mock -ModuleName $ThisModuleName -CommandName Start-DiagnosticsProcess -Verifiable -MockWith {
                'Mock User Mock Email'
            }
            Install-Git -FilePath 'C:\MockFakePath'
            Assert-MockCalled -CommandName Start-DiagnosticsProcess -Exactly 4 -Scope It
        }

        it 'should throw if Git installation fails' {
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                $false
            }
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                Write-Error 'Git Mock installation failed.'
            }
            { Install-Git -FilePath 'C:\MockFakePath' } | should throw
        }
    }
}