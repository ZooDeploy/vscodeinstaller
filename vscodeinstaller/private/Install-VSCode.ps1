# Requires -RunAsAdministrator
function Install-VSCode {
    <#
    .SYNOPSIS
        Installs Visual Studio Code for windows.
    .DESCRIPTION
        Install-VSCode installs Visual Studio Code on the local computer.
    .PARAMETER FilePath
        Specifies the path to the Visual Studio Code setup file.
    .EXAMPLE
        Install-VSCode -FilePath 'C:\Windows\Temp\VSCodeSetup-x64.exe'
        This command installs Visual Studio Code using setup file
        'C:\Windows\Temp\VSCodeSetup-x64.exe'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCode.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCode.md'
    )]
    [OutputType([System.Int32])]
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo] $FilePath
    )

    $vscodeCmd = @(
        "$env:SYSTEMDRIVE\Program Files*\Microsoft VS Code*\bin\code*.cmd",
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code*\bin\code*.cmd"
    )

    $isInstalled = Resolve-Path $vscodeCmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -First 1

    if ($isInstalled) {
        Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.VSCode)
        return 1638
    }
    else{
        ## Install
        Write-Verbose ($localized.StartInstallation -f $localized.VSCode)
        try{
            $startProcessParam = @{
                FilePath = $FilePath
                ArgumentList = '/verysilent /norestart /mergetasks=!runcode'
                Wait = $true
                PassThru = $true
                NoNewWindow = $true
                ErrorAction = 'Stop'
            }
            $result = Start-Process @startProcessParam
            Write-Verbose ($localized.SoftwareInstallationResult -f $localized.VSCode, $result.ExitCode)
        }
        catch{
            throw ($localized.SoftwareInstallationError -f $localized.VSCode)
        }
    }
}