@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'vscodeinstaller.psm1'

    # Version number of this module.
    ModuleVersion = '0.1.0'

    # ID used to uniquely identify this module
    GUID = '120f17b8-f844-4d60-bd25-223eb2add354'

    # Author of this module
    Author = 'Chris Rossi'

    # Company or vendor of this module
    CompanyName = 'ZooDeploy'

    # Copyright statement for this module
    Copyright = '(c) 2019 Chris Rossi. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Windows PowerShell module for installing/uninstalling and setting up Visual Studio Code and optional Git, PSCore and additional VSCode extensions.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '3.0'

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @('vscodeinstaller.format.ps1xml')

    # Functions to export from this module
    FunctionsToExport = @(
        'Get-VSCodeInstallTemplate',
        'Invoke-VSCodeInstaller',
        'Invoke-VSCodeUninstaller'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @(
        'gvit',
        'ivsc',
        'uvsc'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('vscode','install', 'uninstall', 'VisualStudioCode', 'git', 'PSEdition_Desktop', 'Windows')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/ZooDeploy/vscodeinstaller'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''
        }
    }

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/ZooDeploy/vscodeinstaller/tree/master/docs'
}
