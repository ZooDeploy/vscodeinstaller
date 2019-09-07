
FormatTaskName "-------- Runing task [{0}] --------"

task default -depends Init, Analyze, UnitTest, BuildPublicDocs, BuildPrivateDocs

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
    $files = (Get-ChildItem "$PSScriptRoot\vscodeinstaller\p*" -Recurse -Include "*.psm1","*.ps1").FullName
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

task BuildPublicDocs -depends Analyze, UnitTest {
    ## Use -Global in BuildPipeline - otherwise Azure Pipelines creates 'module not found' exception
    Import-Module -Name "$PSScriptRoot\vscodeinstaller\vscodeinstaller.psd1" -Force -Global
    $nmhParam = @{
        Module = 'vscodeinstaller'
        OutputFolder = "$PSScriptRoot\docs"
        AlphabeticParamsOrder = $true
        Force = $true
    }
    New-MarkdownHelp @nmhParam
} -description 'Build help files from public functions'

Task BuildPrivateDocs -depends Analyze, UnitTest, BuildPublicDocs {
    Start-Job -ScriptBlock {
        $name = $args[0]
        Import-Module -Name $args[1] -Force
        $module = Get-Module -Name $name -ErrorAction SilentlyContinue
        $scriptBlock = {
            $ExecutionContext.InvokeCommand.GetCommands('*', 'Function', $true)
        }
        $publicFunctions = $module.ExportedCommands.GetEnumerator() |
            Select-Object -ExpandProperty Value |
            Select-Object -ExpandProperty Name
        $privateFunctions = & $module $scriptBlock | Where-Object {$_.Source -eq $name -and $_.Name -notin $publicFunctions}

        foreach ($privateFunction in $privateFunctions) {
            $helpDoc = $privateHelp | Where-Object {$_.Basename -like $privateFunction.Name}
            $functionDefinition = 'Function {0} {{ {1} }}' -f $privateFunction.name, $privateFunction.Definition
            . ([scriptblock]::Create($functionDefinition))

            if (-not $helpDoc) {
                $nmParams = @{
                    Command = $privateFunction.Name
                    Force = $true
                    AlphabeticParamsOrder = $true
                    OutputFolder = $args[2]
                    WarningAction = 'SilentlyContinue'
                }
                New-MarkdownHelp @nmParams
            }
            $umParams = @{
                Path = '{0}\{1}.md' -f $args[2], $privateFunction.Name
                AlphabeticParamsOrder = $true
                WarningAction = 'SilentlyContinue'
            }
            Update-MarkdownHelp @umParams
            Remove-Item "function:\$($privateFunction.name)" -ErrorAction SilentlyContinue
        }
    } -ArgumentList 'vscodeinstaller', "$PSScriptRoot\vscodeinstaller\vscodeinstaller.psd1", "$PSScriptRoot\docs" | Wait-Job | Receive-Job
} -description 'Build help files from private functions'

task FunctionalTest {
    $ivpParam = @{
        Path = "$PSScriptRoot\test\functional"
        PassThru = $true
        OutputFile = "$PSScriptroot\test\Test-Functional.XML"
        OutputFormat = 'NUnitXML'
    }
    $testResults = Invoke-Pester @ivpParam

    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'One or more functional tests failed. Build cannot continue!'
    }
} -description 'Run functional tests'

task PublishToPowerShellGallery {
    $path = "$PSScriptRoot\vscodeinstaller\vscodeinstaller.psd1"
    $version = (Import-PowerShellDataFile -Path $path).ModuleVersion
    Write-Output "Start publishing PowerShell module VSCodeInstaller '$version' to the PowerShell Gallery"
    try {
        $pmParam = @{
            Path = "$PSScriptRoot\vscodeinstaller"
            NuGetApiKey = $env:PSGalleryApiKey
            ErrorAction = 'Stop'
        }
        Publish-Module @pmParam
        Write-Output 'VSCodeInstaller PowerShell module published to the PowerShell Gallery'
    }
    catch {
        throw "Could not publish module to PSGallery: $($_.Exception.Message)"
    }
} -description 'Publish module to PowerShell Gallery'