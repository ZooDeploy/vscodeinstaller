$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable VSCodeTemplateData -BaseDirectory "$ThisModulePath\data" -FileName 'VSCodeTemplateData.psd1'


Describe 'Unit tests for function Get-VSCodeInstallTemplate' {

    it 'Should return a PSCustomObject' {
        Get-VSCodeInstallTemplate | should BeOfType System.Management.Automation.PSCustomObject
    }

    it 'Should return a PSCustomObject with member name [Template]' {
        $result = Get-VSCodeInstallTemplate | Get-Member | select-Object -ExpandProperty Name
        $result[6] | should be 'Template'
    }

    it 'Should return a PSCustomObject with member name [Description]' {
        $result = Get-VSCodeInstallTemplate | Get-Member | select-Object -ExpandProperty Name
        $result[4] | should be 'Description'
    }

    it 'Should return a PSCustomObject with member name [Extensions]' {
        $result = Get-VSCodeInstallTemplate | Get-Member | select-Object -ExpandProperty Name
        $result[5] | should be 'Extensions'
    }
}