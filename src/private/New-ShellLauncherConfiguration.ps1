function New-ShellLauncherConfiguration {
    <#
    .SYNOPSIS
        Generates a ShellLauncher extension configuration.
    .DESCRIPTION
        New-ShellLauncherConfiguration generates a ShellLauncher extension configuration and sends it to the
        standard output stream. The configuration contains a shell entry for cmd, PowerShell and if installed also
        for Git and PowerShell Core. The configuration can then be imported into the settings.json file in VSCode.
    .EXAMPLE
        New-ShellLauncherConfiguration
        This command generates a ShellLauncher extension configuration and sends it to the standard output stream.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/New-ShellLauncherConfiguration.md
    #>
    [CmdletBinding(
        SupportsShouldProcess, ConfirmImpact='None',
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-InstalledVSCodeExtension.md'
    )]
    [OutputType([System.String])]
    Param()

    ## Generate cmd + PowerShell entry
    $slc = @{
        'shellLauncher.shells.windows' = @(
            @{
                'shell' = "$env:WINDIR\system32\cmd.exe"
                'label' = 'cmd'
            },
            @{
                'shell' = "$env:WINDIR\system32\WindowsPowerShell\v1.0\powershell.exe"
                'label' = 'PowerShell'
            }
        )
    }
    if ($PSCmdlet.ShouldProcess('ShouldProcess?')) {
        $gciParam = @{
            Path = "$env:SYSTEMDRIVE\"
            Recurse = $true
            Filter = 'pwsh.exe'
            Depth = 6
            ErrorAction = 'SilentlyContinue'
        }
        $pscorePath = Get-ChildItem @gciParam | Select-Object -ExpandProperty FullName -First 1
        ## Generate PowerShell Core entry
        if ($pscorePath) {
            $pscoreElement = @{
                'shell' = $pscorePath
                'label' = 'PowerShell Core'
            }
            $slc.'shellLauncher.shells.windows' += $psCoreElement
        }

        $gitPath = Resolve-Path "$env:SYSTEMDRIVE\Program Files*\Git\bin\bash.exe" | Select-Object -ExpandProperty Path
        ## Generate Git entry
        if ($gitPath) {
            $gitElement = @{
                'shell' = $gitPath
                'label' = 'Git bash'
            }
            $slc.'shellLauncher.shells.windows' += $gitElement
        }

        Write-Output ($slc | ConvertTo-Json)
    }
}
