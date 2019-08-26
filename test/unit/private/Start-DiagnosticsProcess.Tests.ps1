$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Start-DiagnosticProcess' {

        it 'should throw if executing of the process fails' {
            $filePath = 'C:\Mock.exe'
            $Arguments = '/MOCK /VERYSILENT'
            mock -ModuleName $ThisModuleName -CommandName Start-Process -MockWith {
                Write-Error 'Git Mock installation failed.'
            }
            { Start-DiagnosticProcess -FilePath $filePath -Arguments $Arguments } | should throw
        }
    }
}