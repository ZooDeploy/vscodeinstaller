# Requires -RunAsAdministrator
function Invoke-VSCodeInstaller {
    <#
    .SYNOPSIS
        Installs and sets up Visual Studio Code.
    .DESCRIPTION
        Invoke-VSCodeInstaller downloads, installs and sets up Visual Studio Code and Git as your coding
        environment. You can skip the Git installation by selecting parameter SkipGitInstallation.

        If template 'PowerShell Core' is selected it additionally downloads and installs PowerShell Core, the
        VSCode extensions PowerShell and ShellLauncher and sets PowerShell as the default language in VSCode.
        The ShellLauncher is automatically configured with a shell entry for PowerShell, PowerShellCore, cmd and
        Git bash.

        If template 'PowerShell' is selected it additionally downloads and installs the VSCode extension PowerShell
        and sets PowerShell as the default language in VSCode.
    .PARAMETER Template
        The name of the template to use with the Invoke-VSCodeInstaller command. To see a list of available
        templates use the Get-VSCodeInstallTemplate command.

        You can define your own templates in the VSCodeTemplateData.psd1 file located in the VSCodeInstaller
        module folder.
    .PARAMETER InstallerType
        Specifies if an User oder System Visual Studio Code setup will be downloaded and installed. The
        InstallerType User does not require administrator privileges for installation as the install location will
        be under your user local AppData ($env:LOCALAPPDATA) folder. User setup also provides a smoother background
        update experience.
    .PARAMETER Architecture
        Specifies if the 32-bit or 64-bit Visual Studio Code and Git setup will be downloaded and installed
        provided no SkipGitInstallation option is selected. If Template 'PowerShellCore' is selected, it also
        specifies if the 32-bit oder 64-bit version of the PowerShell Core for Windows will be downloaded and
        installed. Default value is 64-bit.
    .PARAMETER Build
        Specifies if the insider (preview) version or the stable version of the Visual Studio Code setup file will
        be downloaded and installed. If Template 'PowerShellCore' is selected, it also specifies if the preview
        version or the stable version of PowerShell Core for Windows will be downloaded and installed. Default
        value is stable.
    .PARAMETER AdditionalExtensions
        Specifies the full name of the extenisions to install. An array of extension names is accepted.
        Define the full name in the following way: <publisher name>.<extension name>, for example ms-python.python.

        To find the full extension name go the Extensions panel in Visual Studio Code. The full name is located
        on the right to the extension name.

        Alternatively, the full name can also be found in the Visual Studio Marketplace URI of the extension, for
        example: https://marketplace.visualstudio.com/itemdetails?itemName=ms-python.python
    .PARAMETER SkipGitInstallation
        Specifies if Git will be installed or not. If SkipGitInstallation is selected, Git will not be installed.
    .PARAMETER GitUserName
        Specifies the Git user name for commit information. The user name is globally set in the first-time Git
        setup routine.
    .PARAMETER GitUserEmail
        Specifies the Git user email for commit information. The user email is globally set in the first-time Git
        setup routine.
    .EXAMPLE
        Invoke-VSCodeInstaller -Verbose
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
        version and Git for Windows 64-bit version. Git will be configured with the standard username 'gituser'
        and standard user email 'gituser@example.com' globally for the first-time Git setup. The example uses the
        Verbose parameter to display extended installation information like installation return codes.
    .EXAMPLE
        Invoke-VSCodeInstaller -SkipGitInstallation
        This command only downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user
        stable version.
    .EXAMPLE
        Invoke-VSCodeInstaller -Architecture 'x86' -Build 'insider'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 32-bit user insider
        version and the latest Git for Windows 32-bit version.
    .EXAMPLE
        Invoke-VSCodeInstaller -GitUserName 'example' -GitUserEmail 'example@example.com'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
        version and the latest Git for Windows 64-bit version and uses user name  and user email
        'example@example.com' globally for the first-time Git setup.
    .EXAMPLE
        Invoke-VSCodeInstaller -AdditionalExtensions @('ahmadawais.shades-of-purple', 'hoovercj.vscode-power-mode')
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
        version and the latest Git for Windows 64-bit version and the VSCode extensions 'shades-of-purple'and
        'vscode-power-mode'.
    .EXAMPLE
        Invoke-VSCodeInstaller -Template 'PowerShell'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
        version and the latest Git for Windows 64-bit version. When Template 'PowerShell' is selected, it will
        also download and install the VSCode PowerShell extension and sets PowerShell as the default language in
        VSCode.
    .EXAMPLE
        Invoke-VSCodeInstaller -Template 'PowerShellCore' -GitUserName 'example' -GitUserEmail 'example@example.com'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
        version and the latest Git for Windows 64-bit version and uses user name 'example' and user email
        'example@example.com' globally for the first-time Git setup. When Template 'PowerShellCore' is selected,
        it will also download and install the VSCode PowerShell extension, the Tyriar Shell Launcher extension and
        the latest PowerShell Core 64-bit stable version and sets PowerShell as the default language in VSCode.
        The ShellLauncher extension will be configured with a shell entry for PowerShell, PowerShell Core, cmd and
        Git bash.
    .EXAMPLE
        Invoke-VSCodeInstaller -Template 'PowerShellCore' -Architecture 'x86'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 32-bit user stable
        version and the latest Git for Windows 32-bit version and uses user name 'example' and user email
        'example@example.com' globally for the first-time Git setup. When Template 'PowerShellCore' is selected,
        it will also download and install the VSCode PowerShell extension, the Tyriar Shell Launcher extension and
        the latest PowerShell Core 32-bit stable version and sets PowerShell as the default language in VSCode.
        The ShellLauncher extension will be configured with a shell entry for PowerShell, PowerShell Core, cmd and
        Git bash.
    .EXAMPLE
        Invoke-VSCodeInstaller -InstallerType 'System' -GitUserName 'example' -GitUserEmail 'example@example.com'
        This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit system
        stable version and the latest Git for Windows 64-bit version and uses user name 'example' and user email
        'example@example.com' globally for the first-time Git setup.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeInstaller.md
    #>
    [CmdletBinding(
        DefaultParameterSetName='None',
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeInstaller.md'
    )]
    [OutputType([System.String])]
    [Alias('ivsc')]
    param (
        [System.String] $Template,

        [ValidateSet('User', 'System')]
        [System.String] $InstallerType = 'User',

        [ValidateSet('x64', 'x86')]
        [System.String] $Architecture = 'x64',

        [ValidateSet('Stable', 'Insider')]
        [System.String] $Build = 'Stable',

        [System.String[]] $AdditionalExtensions,

        [Parameter(ParameterSetName='SkipGit')]
        [System.Management.Automation.SwitchParameter] $SkipGitInstallation,

        [Parameter(ParameterSetName='InstallGit')]
        [System.String] $GituserName = 'gituser',

        [Parameter(ParameterSetName='InstallGit')]
        [System.String] $GitUserEmail = 'gituser@example.com'
    )

    $installQueue = New-Object System.Collections.Queue
    $removeDownloadedFiles = @()

    if ($PSBoundParameters.ContainsKey('Template')) {
        $ildParam = @{
            BindingVariable = 'VSCodeTemplateData'
            BaseDirectory = ($PSScriptRoot -split '\\public')[0]
            FileName = 'VSCodeTemplateData.psd1'
            ErrorAction = 'SilentlyContinue'
        }
        Import-LocalizedData @ildParam

        ## Add extensions from template
        if ($VSCodeTemplateData) {
            $data = $VSCodeTemplateData.TemplateData | Where-Object Name -eq $Template -ErrorAction SilentlyContinue
            if ($data) {
                if ($AdditionalExtensions) {
                    $templateExtensions = Compare-Object $data.Extensions $AdditionalExtensions -PassThru
                    $AdditionalExtensions += $templateExtensions
                }
                else {
                    $AdditionalExtensions += $data.Extensions
                }
            }
            else {
                Write-Verbose ($localized.TemplateNotFound -f $Template)
            }
        }
        else {
            Write-Verbose $localized.ImportTemplateError
        }
        ## Add PSCore to install queue if not already installed
        if ($Template -eq 'PowerShellCore') {
            $regPath = @(
                'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
                'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
            )
            $PSCore = Get-ChildItem $regPath  | Get-ItemProperty | Select-Object DisplayName
            $PSCore = $PSCore | Where-Object DisplayName -match 'PowerShell [6-99]'

            if (-not $PSCore) {
                $installQueue.enqueue('installPSCore')
            }
            else {
                Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.PSCore)
            }
        }
    }

    $vscodeCmd = @(
        "$env:SYSTEMDRIVE\Program Files*\Microsoft VS Code*\bin\code*.cmd",
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code*\bin\code*.cmd"
    )
    $isVSCodeInstalled = Resolve-Path $vscodeCmd -ErrorAction SilentlyContinue

    ## Add VSCode to install queue if not already installed
    if (-not ($isVSCodeInstalled)) {
        $installQueue.enqueue('installVSCode')
    }
    else {
        Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.VSCode)
    }

    ## Add Git to install queue if not already installed
    if (-not ($SkipGitInstallation)) {
        $pathGit = "$env:SYSTEMDRIVE\Program Files*\Git\git-cmd.exe"
        if (-not (Test-Path $pathGit -PathType Leaf)) {
            $installQueue.enqueue('installGit')
        }
        else {
            Write-Verbose ($localized.SoftwareIsAlreadyInstalled -f $localized.Git)
        }
    }
    else {
        Write-Verbose ($localized.SkipGitInstallation)
    }

    ## Calculating Write-Progress steps
    $currentStep = 1
    $totalSteps = ($installQueue.Count * 2)
    if ($AdditionalExtensions) {
        $totalSteps++
    }
    $wpParam = @{
        Activity = $localized.Activity
        Id = 1
    }

    try {
        while ($installQueue -gt 0) {
            switch ($installQueue.dequeue()) {
                'installVSCode' {
                    $vdParam = @{
                        InstallerType = $InstallerType
                        Architecture = $Architecture
                        Build = $Build
                    }
                    $status = $localized.WriteProgressDownload  -f $currentStep, $totalSteps, $localized.VSCode
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    $vscode = Invoke-VSCodeDownload @vdParam
                    $removeDownloadedFiles += $vscode
                    $status = $localized.WriteProgressInstallation  -f $currentStep, $totalSteps, $localized.VSCode
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    $null = Install-VSCode -FilePath $vscode
                }
                'installGit' {
                    $status = $localized.WriteProgressDownload -f $currentStep, $totalSteps, $localized.Git
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    $git = Invoke-GitDownload -Architecture $Architecture
                    $removeDownloadedFiles += $git
                    $status = $localized.WriteProgressInstallation -f $currentStep, $totalSteps, $localized.Git
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    Install-Git -FilePath $git -UserName $GituserName -UserEmail $GitUserEmail
                }
                'installPSCore' {
                    $status = $localized.WriteProgressDownload  -f $currentStep, $totalSteps, $localized.PSCore
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    if ($Build -eq 'Stable') {
                        $PSCore = Invoke-PSCoreDownload -Architecture $Architecture
                    }
                    else {
                        $PSCore = Invoke-PSCoreDownload -Architecture $Architecture -PreviewVersion
                    }
                    $removeDownloadedFiles += $PSCore
                    $status = $localized.WriteProgressInstallation  -f $currentStep, $totalSteps, $localized.PSCore
                    Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)
                    Install-PSCore -FilePath $PSCore
                }
            }
        }
        ## Install additional VSCode extensions
        if ($AdditionalExtensions) {
            $installedExtensions = Get-InstalledVSCodeExtension
            $status = $localized.WriteProgressInstallation -f $currentStep, $totalSteps, $localized.VSCodeExtensions
            Write-Progress @wpParam -Status $status -PercentComplete ($currentStep++ / $totalSteps * 100)

            $AdditionalExtensions | ForEach-Object {
                $publisher = ($_ -split '\.')[0]
                $name = ($_ -split '\.')[1]

                if (($publisher -in $installedExtensions.Publisher) -and
                   ($name -in $installedExtensions.Name)) {
                    Write-Verbose ($localized.VSCodeExtensionAlreadyInstalled -f $_)
                }
                else {
                    Install-VSCodeExtension -Extension $_
                    ## Set ShellLauncher extension
                    if ($_ -eq 'tyriar.shell-launcher') {
                        $slc = New-ShellLauncherConfiguration
                        Set-VSCodeUserSetting -InputObject $slc
                    }
                    ## Set PowerShell as default language
                    if ($_ -eq 'ms-vscode.powershell') {
                        $psSetDefaultLanguage = @{'files.defaultLanguage' = 'powershell'} | ConvertTo-Json
                        Set-VSCodeUserSetting -InputObject $psSetDefaultLanguage
                    }
                }
            }
        }
    }
    catch {
        throw ($localized.InvokeVSCodeInstallerError -f $_.Exception.Message)
    }
    finally {
        $removeDownloadedFiles | ForEach-Object {
            Remove-Item $_ -Force -ErrorAction SilentlyContinue
        }
        Write-Progress -Activity $localized.Activity -Completed -Id 1
    }
}