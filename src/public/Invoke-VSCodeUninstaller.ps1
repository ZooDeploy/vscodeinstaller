# Requires -RunAsAdministrator
function Invoke-VSCodeUninstaller {
    <#
    .SYNOPSIS
        Uninstalls Visual Studio Code and optional also Git and/or PowerShell Core.
    .DESCRIPTION
        Completly uninstalls Visual Studio Code and optionally also Git and PowerShell Core.
    .PARAMETER IncludeGit
        Specifies if Git will be uninstalled or not. If IncludeGit is selected, Git will be also uninstalled.
    .PARAMETER IncludePowerShellCore
        Specifies if PowerShell Core will be uninstalled or not. If IncludePowerShellCore is selected,
        PowerShell Core will be also uninstalled.
    .EXAMPLE
        Invoke-VSCodeUninstaller -Verbose
        This command uninstalls only Visual Studio Code from the local system. As parameter Verbose is used, it
        will display extended uninstallation information.
    .EXAMPLE
        Invoke-VSCodeUninstaller -IncludeGit
        This command uninstalls Visual Studio Code and Git from the local system.
    .EXAMPLE
        Invoke-VSCodeUninstaller -IncludePowerShellCore
        This command uninstalls Visual Studio Code and PowerShell Core from the local system.
    .EXAMPLE
        Invoke-VSCodeUninstaller -IncludeGit -IncludePowerShellCore
        This command uninstalls Visual Studio Code, Git and PowerShell Core from the local system.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeUninstaller.md
    #>
    [CmdletBinding(
        SupportsShouldProcess, ConfirmImpact='High',
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeUninstaller.md'
    )]
    [OutputType([System.String])]
    [Alias('uvsc')]
    param (
        [System.Management.Automation.SwitchParameter] $IncludeGit,
        [System.Management.Automation.SwitchParameter] $IncludePowerShellCore
    )

    if ($PSCmdlet.ShouldProcess("Continue uninstallation?")) {
        ## VSCode uninstall
        $uninstallerPath = @(
            'C:\Users\*\AppData\Local\Programs\Microsoft VS Code*\unins*.exe',
            'C:\Program Files*\Microsoft VS Code*\unins*.exe'
        )
        $vscodeUninst = Resolve-Path $uninstallerPath -ErrorAction SilentlyContinue
        $vscodeUninst = $vscodeUninst | Select-Object -ExpandProperty Path -First 1 -ErrorAction SilentlyContinue

        if ($vscodeUninst) {
            Write-Verbose ($localized.StartUninstallation -f $localized.VSCode)
            try{
                $spParam = @{
                    FilePath = $vscodeUninst
                    ArgumentList ='/VERYSILENT'
                    Wait = $true
                    PassThru = $true
                    ErrorAction = 'Stop'
                }
                $result = Start-Process @spParam
                Write-Verbose ($localized.SoftwareUninstallationResult -f $localized.VSCode, $result.ExitCode)
            }
            catch{
                throw ($localized.SoftwareUninstallationError -f $localized.VSCode)
            }
            ## Remove still existing VSCode folder structure
            $folderToRemove = @(
                "$env:APPDATA\Code",
                "$env:APPDATA\Visual Studio Code",
                "$env:USERPROFILE\.vscode"
            )
            $folderToRemove | ForEach-Object {
                if (Test-Path -LiteralPath $_ -PathType Container) {
                    Write-Verbose ($localized.StillExistingFileFolder -f $_)
                    try{
                        Remove-Item $_ -Recurse -Force -ErrorAction Stop
                        Write-Verbose ($localized.RemoveFileFolderSuccess -f $_)
                    }
                    catch {
                        Write-Warning ($localized.RemoveFileFolderError -f $_)
                    }
                }
            }
        }
        else {
            Write-Verbose ($localized.SoftwareIsNotInstalled -f $localized.VSCode)
        }
        ## Git uninstall
        if ($PSBoundParameters.ContainsKey('IncludeGit')) {
            $path = "$env:SYSTEMDRIVE\Program Files*\Git\unins*.exe"
            $gitUninstaller = Resolve-Path -Path $path -ErrorAction SilentlyContinue
            $gitUninstaller = $gitUninstaller | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue

            if ($gitUninstaller) {
                Write-Verbose ($localized.StartUninstallation -f $localized.Git)
                $gitProgramFilesFolder = Split-Path $gitUninstaller -Parent -ErrorAction SilentlyContinue
                try{
                    $spParam = @{
                        FilePath = $gitUninstaller
                        ArgumentList = '/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS'
                        Wait = $true
                        PassThru = $true
                        ErrorAction = 'Stop'
                    }
                    $result = Start-Process @spParam
                    Write-Verbose ($localized.SoftwareUninstallationResult -f $localized.Git, $result.ExitCode)
                }
                catch {
                    throw ($localized.SoftwareUninstallationError -f $localized.Git)
                }
                ## Remove still existing Git file/folder structure
                $folderOrFileToRemove = @(
                    $gitProgramFilesFolder,
                    "$env:ProgramData\Git",
                    "$env:USERPROFILE\.gitconfig"
                )
                $folderOrFileToRemove | ForEach-Object {
                    if (Test-Path -LiteralPath $_ -PathType Any) {
                        Write-Verbose ($localized.StillExistingFileFolder -f $_)
                        try{
                            Remove-Item $_ -Recurse -Force -ErrorAction Stop
                            Write-Verbose ($localized.RemoveFileFolderSuccess -f $_)
                        }
                        catch {
                            Write-Warning ($localized.RemoveFileFolderError -f $_)
                        }
                    }
                }
            }
            else {
                Write-Verbose ($localized.SoftwareIsNotInstalled -f $localized.Git)
            }
        }
        ## PSCore uninstall
        if ($PSBoundParameters.ContainsKey('includePowerShellCore')) {
            $regPath = @(
                'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
                'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
            )
            $PSCore = Get-ChildItem $regPath | Get-ItemProperty -ErrorAction SilentlyContinue
            $PSCore = $PSCore | Where-Object DisplayName -like '*PowerShell*6*' -ErrorAction SilentlyContinue

            if ($PSCore) {
                $psCoreUninstallString = $PSCore | Select-Object -ExpandProperty UninstallString
                $ProductCode = ($psCoreUninstallString -split '/x')[1]
                try {
                    Write-Verbose ($localized.StartUninstallation -f $localized.PSCore)
                    $fPath = '{0}\system32\msiexec.exe' -f $env:WINDIR
                    $aList = '/x "{0}" /QN /L*v "{1}\Temp\PowerShellCore_Uninstall.log"' -f $productCode, $env:WINDIR
                    $startProcessParam = @{
                        FilePath = $fPath
                        ArgumentList = $aList
                        Wait = $true
                        PassThru = $true
                        NoNewWindow = $true
                        ErrorAction = 'Stop'
                    }
                    $result = Start-Process @startProcessParam
                    Write-Verbose ($localized.SoftwareUninstallationResult -f $localized.PSCore, $result.ExitCode)
                }
                catch {
                    throw ($localized.SoftwareUninstallationError -f $localized.PSCore)
                }
            }
            else {
                Write-Verbose ($localized.SoftwareIsNotInstalled -f $localized.PSCore)
            }
        }
    }
}