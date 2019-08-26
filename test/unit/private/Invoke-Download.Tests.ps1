$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Invoke-Download' {

        $Uri = 'https://mock/Git-2.20.1-64-bit.exe'
        $destination = "$env:WINDIR\Temp\Git-2.20.1-64-bit.exe"
        $errMsg = $localized.WebResourceDownloadFailedError -f $Uri

        it 'should throw if file download fails' {
            mock -ModuleName $ThisModuleName -CommandName Invoke-Download -MockWith {
                Write-Error $errMsg
            }
            { Invoke-Download -Uri $Uri -DestinationPath $destination -ErrorAction Stop } | should throw $errMsg
        }
    }
}