$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force


$rules = Get-ScriptAnalyzerRule
Describe "Testing Module [$ThisModuleName] against default PSScriptAnalyzer rule-set" {

    $rules | ForEach-Object {
        It "passes the PSScriptAnalyzer Rule $($_)" {
            (Invoke-ScriptAnalyzer -Path $ThisModulePath -Recurse -IncludeRule $_.RuleName ).Count | Should Be 0
        }
    }
}
