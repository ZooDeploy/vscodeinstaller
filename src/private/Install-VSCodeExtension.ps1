function Install-VSCodeExtension {
    <#
    .SYNOPSIS
        Installs Visual Studio Code extensions.
    .DESCRIPTION
        Install-VSCodeExtension installs one or more Visual Studio Code extensions on the local computer.
    .PARAMETER Extension
        Specifies the full name of the extenisions to install. An array of extension names is accepted.
        Define the full name in the following way: <publisher name>.<extension name>, for example ms-python.python.

        To find the full extension name go the Extensions panel in Visual Studio Code. The full name is located
        on the right to the extension name.

        Alternatively, the full name can also be found in the Visual Studio Marketplace URI of the extension, for example
        https://marketplace.visualstudio.com/itemdetails?itemName=ms-python.python
    .EXAMPLE
        Install-VSCodeExtension -Extension 'ms-vscode.PowerShell'
        This command installs the PowerShell extension for Visual Studio Code.
    .EXAMPLE
        Install-VSCodeExtension -Extension @('ms-vscode.PowerShell', 'ms-python.python')
        This command installs the PowerShell extension and the Python extension for Visual Studio Code.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCodeExtension.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCodeExtension.md'
    )]
    param (
        [Parameter(Mandatory)]
        [System.String[]] $Extension
    )

    $vscodeCmd = @(
        "$env:SYSTEMDRIVE\Program Files*\Microsoft VS Code*\bin\code*.cmd",
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code*\bin\code*.cmd"
    )
    $vscodePath = Resolve-Path $vscodeCmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -First 1

    if ($vscodePath) {
        ## Install extensions
        $Extension | ForEach-Object {
            if ($_ -match '^.+\..+$') {
                $argList = "--verbose --install-extension $($_ ) --force"
                $sdpParam = @{
                    FilePath = $vscodePath
                    Arguments = $argList
                    ErrorAction = 'SilentlyContinue'
                }
                $result = Start-DiagnosticsProcess @sdpParam
                $result = $result -replace '\n|\t|\r', ''
                Write-Verbose "$result"
            }
            else {
                Write-Warning ($localized.ExtensionNameFormatValidationError -f $_)
            }
        }
    }
    else {
        throw ($localized.MandatorySoftwareMissingError -f $localized.VSCode)
    }
}