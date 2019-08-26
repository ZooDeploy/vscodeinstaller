function Get-InstalledVSCodeExtension {
    <#
    .SYNOPSIS
        Gets installed Visual Studio Code extensions.
    .DESCRIPTION
        Get-InstalledVSCodeExtension returns all Visual Studio Code extensions that are installed on the local system.
    .EXAMPLE
        Get-InstalledVSCodeExtension
        Returns all installed Visual Studio Code extensions.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-InstalledVSCodeExtension.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-InstalledVSCodeExtension.md'
    )]
    [OutputType([System.String])]
    param ()

    $vscodeCmd = @(
        "$env:SYSTEMDRIVE\Program Files*\Microsoft VS Code*\bin\code*.cmd",
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code*\bin\code*.cmd"
    )
    $filePath = Resolve-Path $vscodeCmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -First 1

    if ($filePath) {
        try {
            $argList = "--list-extensions --show-versions --force"
            $result = Start-DiagnosticsProcess -FilePath $filePath -Arguments $argList -ErrorAction Stop

            ForEach ($line in $($result.Split("`r`n"))) {
                if ($line -ne '') {
                    $extensionObj = [PSCustomObject] @{
                        PSTypeName = 'VSCode.Extension'
                        Publisher = ($line -split '\.')[0]
                        Name = (($line -split '@')[0] -split '\.')[1]
                        Version = ($line -split '@')[1]
                    }
                    Write-Output $extensionObj
                }
            }
        }
        catch {
            throw $localized.GettingInstalledExtensionError
        }
    }
    else {
        throw ($localized.MandatorySoftwareIsNotInstalled -f $localized.VSCode)
    }
}