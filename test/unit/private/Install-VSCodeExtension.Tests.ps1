$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\vscodeinstaller" -FileName $lData


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Install-VSCodeExtension' {

    $extensions = @(
            'dracula-theme.theme-dracula',
            'ms-vscode.PowerShell',
            'wesbos.theme-cobalt2'
        )

        mock -ModuleName $ThisModuleName -CommandName Resolve-Path -MockWith {
            [PSCustomObject]@{
                Path = 'C:\Program Files\Microsoft VS Code\binx\code.cmd'
            }
        }

        it 'should display correct warning message if extension format is not valid' {
            mock -ModuleName $ThisModuleName -CommandName Start-DiagnosticsProcess -MockWith {
                "Mock"
            }
            $warningCapture = "TestDrive:\Capture.txt"
            $errorExtension = @('publisher,name')
            $msg = ($localized.ExtensionNameFormatValidationError -f $errorExtension)
            (Install-VSCodeExtension -Extension $errorExtension) 3> $warningCapture
            (Get-Content $warningCapture) | Should Match ([regex]::Escape($msg))
        }

        it 'should call Start-DiagnosticsProcess 3 times if 3 extensions should be installed' {
            Install-VSCodeExtension -Extension $extensions
            Assert-MockCalled -CommandName Start-DiagnosticsProcess -Exactly 3 -Scope It
        }

        it 'should call Start-DiagnosticsProcess 1 time if 1 extension should be installed' {
            Install-VSCodeExtension -Extension $extensions[0]
            Assert-MockCalled -CommandName Start-DiagnosticsProcess -Exactly 1 -Scope It
        }

        it 'should throw if Visual Studio Code is not installed' {
            mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
                return $false
            }
            mock -ModuleName $ThisModuleName -CommandName Select-Object {
            }
            { Install-VSCodeExtension -SourcePath 'C:\MockFakePath' } | should throw
        }
    }
}
