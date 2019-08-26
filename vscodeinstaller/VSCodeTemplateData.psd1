@{
    ## Data for Get-VSCodeInstallTemplate
    TemplateData = @(
        @{
            Name = 'PowerShell'
            Description =  'This template installs the PowerShell VSCode extension and sets PowerShell as the VSCode default language.'
            Extensions = @('ms-vscode.powershell')
        }
        @{
            Name = 'PowerShellCore'
            Description =  'This template installs PowerShell Core, the PowerShell VSCode extension, the ShellLauncher VSCode extension and sets PowerShell as the VSCode default language. The ShellLauncher extension will be configured with shell entries for cmd, PS, PSCore and Git bash.'
            Extensions = @('ms-vscode.powershell', 'tyriar.shell-launcher')
        }
    )
}