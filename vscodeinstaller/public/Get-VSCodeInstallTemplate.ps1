function Get-VSCodeInstallTemplate {
    <#
    .SYNOPSIS
        Lists the available Visual Studio Code installation templates.
    .DESCRIPTION
        Lists the available Visual Studio Code installation templates. The templates can be used with the
        Invoke-VSCodeInstaller command for simplified installations.
    .EXAMPLE
        Get-VSCodeInstallTemplate
        Outputs the latest available template content.
    .EXAMPLE
        Get-VSCodeInstallTemplate | Select-Object Template
        Outputs the latest available template names only.
    .EXAMPLE
        Get-VSCodeInstallTemplate | Select-Object Description
        Outputs the latest available template descriptions only.
    .EXAMPLE
        Get-VSCodeInstallTemplate | Select-Object Extensions
        Outputs the latest available template extension names only.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-VSCodeInstallTemplate.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-VSCodeInstallTemplate.md'
    )]
    [OutputType([System.String])]
    [Alias('gvit')]
    Param()

    $ildParam = @{
        BindingVariable = 'VSCodeTemplateData'
        BaseDirectory = ($PSScriptRoot -split '\\public')[0]
        FileName = 'VSCodeTemplateData.psd1'
        ErrorAction = 'SilentlyContinue'
    }
    Import-LocalizedData @ildParam

    if ($VSCodeTemplateData) {
        $VSCodeTemplateData.TemplateData | ForEach-Object {
            $templateObj = [PSCustomObject]@{
                PSTypeName = 'VSCodeInstaller.Template'
                Template = $_.Name
                Description = $_.Description
                Extensions = $_.Extensions
            }
            Write-Output $templateObj
        }
    }
    else {
        'No templata data found.'
        $PSScriptRoot
    }
}