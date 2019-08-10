# Requires -RunAsAdministrator
function Install-Git {
    <#
    .SYNOPSIS
        Installs Git for Windows.
    .DESCRIPTION
        Install-Git installs Git for Windows on the local computer.
    .PARAMETER FilePath
        Specifies the path to the Git for Windows setup file.
    .PARAMETER UserName
        Specifies the user name for commit information. The user name is globally set in the first-time Git setup
        routine.
    .PARAMETER UserEmail
        Specifies the user email for commit information. The user email is globally set in the first-time Git
        setup routine.
    .EXAMPLE
        Install-Git -FilePath 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
        This command installs Git for Windows using setup file 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
        and uses standard user name 'gituser' and standard user email 'gituser@example.com' globally for the
        first-time Git setup.
    .EXAMPLE
        Install-Git -FilePath 'C:\Windows\Temp\Git-2.20.1-64-bit.exe' -UserName 'example' -UserEmail example@example.com'
        This command install the Git for Windows setup under 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
        and uses user name 'example' and user email 'example@example.com' globally for the first-time Git setup.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-Git.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-Git.md'
    )]
    [OutputType([System.Int32])]
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo] $FilePath,

        [System.String] $UserName = 'gituser',

        [System.String] $UserEmail = 'gituser@example.com'
    )

    if (Test-Path "$env:SYSTEMDRIVE\Program Files*\Git\cmd\git.exe") {
        Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.Git)
        return 1638
    }
    else {
        Write-Verbose ($localized.StartInstallation -f $localized.Git)
        try {
            $startProcessParam = @{
                FilePath = $FilePath
                ArgumentList = '/VERYSILENT /NORESTART'
                Wait = $true
                PassThru = $true
                NoNewWindow = $true
                ErrorAction = 'Stop'
            }
            $result = Start-Process @startProcessParam
        }
        catch {
            throw ($localized.SoftwareInstallationError -f $localized.Git)
        }
        Write-Verbose ($localized.SoftwareInstallationResult -f $localized.Git, $result.ExitCode)
    }

    $gitCmdPath = Resolve-Path "$env:SYSTEMDRIVE\Program Files*\Git\cmd\git.exe" | Select-Object -ExpandProperty Path -First 1

    ## Confige Git first run
    Start-DiagnosticsProcess -FilePath $gitCmdPath -Arguments "config --global user.name $UserName"
    Start-DiagnosticsProcess -FilePath $gitCmdPath -Arguments "config --global user.email $UserEmail"

    ## Check for success
    $arg = @{
        $UserName = @('user.name', 'config --global user.name')
        $UserEmail = @('user.email',  'config --global user.email')
    }
    $arg.GetEnumerator() | ForEach-Object {
        $result =  Start-DiagnosticsProcess -FilePath $gitCmdPath -Arguments $_.Value[1]
        $result = $result -replace "`t|`n|`r",''
        if ($result -eq $_.Key) {
            Write-Verbose ($localized.SetGitFirstRunSuccess -f $_.Value[0], $result)
        }
        else {
            Write-Verbose ($localized.SetGitFirstRunError -f $_.Value[0], $_.Key, $result)
        }
    }
}