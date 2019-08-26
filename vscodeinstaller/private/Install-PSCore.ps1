# Requires -RunAsAdministrator
function Install-PSCore {
    <#
    .SYNOPSIS
        Installs PowerShell Core for windows.
    .DESCRIPTION
        Install-PSCore installs PowerShell Core for Windows on the local computer.
    .PARAMETER FilePath
        Specifies the path to the PowerShell Core installer setup file.
    .EXAMPLE
        Install-PSCore -FilePath 'C:\Windows\Temp\PowerShell-6.1.2-win-x64.msi'
        This command installs PowerShell Core using setup file
        'C:\Windows\Temp\PowerShell-6.1.2-win-x64.msi'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-PSCore.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-PSCore.md'
    )]
    [OutputType([System.Int32])]
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo] $FilePath
    )

    $regPath = @(
                'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
                'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    )
    ## Check if PowerShell Core is already installed
    $PSCore = Get-ChildItem $regPath  | Get-ItemProperty | Select-Object DisplayName
    $PSCore = $PSCore | Where-Object DisplayName -match 'PowerShell [6-99]'

    if ($PSCore) {
        Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.PSCore)
        return 1638
    }
    else {
        Write-Verbose ($localized.StartInstallation -f $localized.PSCore)
        try {
            $filename = ($FilePath -split '\\')[-1]
            $fPath = '{0}\system32\msiexec.exe' -f $env:WINDIR
            $aList = '/i "{0}" ALLUSERS=1 /QN /L*v "{1}\Temp\{2}_Install.log"' -f $FilePath, $env:WINDIR, $filename
            $startProcessParam = @{
                FilePath = $fPath
                ArgumentList = $aList
                Wait = $true
                PassThru = $true
                NoNewWindow = $true
                ErrorAction = 'Stop'
            }
            $result = Start-Process @startProcessParam
            Write-Verbose ($localized.SoftwareInstallationResult -f $localized.PSCore, $result.ExitCode)
        }
        catch {
            throw ($localized.SoftwareInstallationError -f $localized.PSCore)
        }
    }
}