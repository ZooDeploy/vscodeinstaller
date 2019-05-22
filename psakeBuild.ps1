
FormatTaskName "-------- Runing task [{0}] --------"

task default -depends Init, Analyze, UnitTest, BuildHelpFiles

task Init {
    "STATUS: Testing with PowerShell $($PSVersionTable.PSVersion)"
    'Build System Details:'
    Get-Item $env:BH*
} -description 'Initialize build environment'

task Analyze {
    $ivpParam = @{
        Script = "$PSScriptRoot\test\PSSCriptAnalyzer.tests.ps1"
        CodeCoverage = $files
        PassThru = $true
        OutputFile = "$PSScriptroot\test\Test-PSScripAnalyzer.XML"
        OutputFormat = 'NUnitXML'
    }
    $lintResults = Invoke-Pester @ivpParam

    if ($lintResults.FailedCount -gt 0) {
        $lintResults | Format-List
        Write-Error -Message 'One or more PSScriptAnalyzer tests failed. Build cannot continue!'
    }
} -description 'Run PSScriptAnalyzer'

task UnitTest {
    $files = (Get-ChildItem "$PSScriptRoot\src\p*" -Recurse -Include "*.psm1","*.ps1").FullName
    $ivpParam = @{
        Path = "$PSScriptRoot\test\unit"
        CodeCoverage = $files
        PassThru = $true
        OutputFile = "$PSScriptroot\test\Test-Unit.XML"
        OutputFormat = 'NUnitXML'
    }
    $unitTestResults = Invoke-Pester @ivpParam

    if ($unitTestResults.FailedCount -gt 0) {
        $unitTestResults | Format-List
        Write-Error -Message 'One or more unit tests failed. Build cannot continue!'
    }
} -description 'Run unit tests'

task BuildHelpFiles -depends Analyze, UnitTest {
    ## Use -Global in BuildPipeline - otherwise Azure Pipelines creates 'module not found' exception
    Import-Module -Name "$PSScriptRoot\vscodeinstaller.psd1" -Force -Global
    $nmhParam = @{
        Module = 'vscodeinstaller'
        OutputFolder = "$PSScriptRoot\docs"
        AlphabeticParamsOrder = $true
        Force = $true
    }
    New-MarkdownHelp @nmhParam
}