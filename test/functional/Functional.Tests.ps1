$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {
    Describe "Functional tests for PowerShell module 'VSCodeInstaller'" {

        Context 'Running VSCode functional tests - installation modus' {
            $testCases =  @(
                @{
                    extName = 'vscode-power-mode'
                    extPublisher = 'hoovercj'
                }
                @{
                    extName = 'theme-cobalt2'
                    extPublisher = 'wesbos'
                }
                @{
                    extName = 'shades-of-purple'
                    extPublisher = 'ahmadawais'
                }
                @{
                    extName = 'shell-launcher'
                    extPublisher = 'tyriar'
                }
                @{
                    extName = 'powershell'
                    extPublisher = 'ms-vscode'
                }
            )

            $verboseCapture = "TestDrive:\Capture.txt"

            $iviParam = @{
                Template = 'PowerShellCore'
                GitUserName = 'ZooDeploy'
                GitUserEmail = 'zoodeploy@example.com'
                Verbose = $true
                AdditionalExtensions = @(
                    'ahmadawais.shades-of-purple',
                    'hoovercj.vscode-power-mode',
                    'wesbos.theme-cobalt2'
                )
            }
            ## Install VSCode and additional software
            (Invoke-VSCodeInstaller @iviParam) 4> $verboseCapture

            it "should download and install 'Visual Studio Code' correctly with installation return code '0'" {
                $desiredResult = @(
                    "Trying to download file 'VSCodeUserStableSetup-x[6,8][4,6].exe' from 'aka.ms'.",
                    "Starting 'Visual Studio Code' installation.",
                    "'Visual Studio Code' installation finished with exit code '0'."
                )
                $desiredResult | ForEach-Object {
                    ## -FileContentMatch requires Pester v4
                    $verboseCapture | Should -FileContentMatch $_
                }
            }

            it "should download and install 'Git' correctly with installation return code '0'" {
                $desiredResult = @(
                    "^Trying to download file 'Git-[\d\.]+-[\d]+-bit.exe' from 'github.com'.$",
                    "Starting 'Git' installation.",
                    "'Git' installation finished with exit code '0'."
                )
                $desiredResult | ForEach-Object {
                    $verboseCapture | Should -FileContentMatch $_
                }
            }

            it "should set Git 'user.email correctly'" {
                $verboseCapture | Should -FileContentMatch "Successfully set Git 'user.email' to 'zoodeploy@example.com'."
            }

            it "should set Git 'user.name correctly'" {
                $verboseCapture | Should -FileContentMatch "Successfully set Git 'user.name' to 'ZooDeploy'."
            }

            it "should download and install 'PowerShell Core' correctly with installation return code '0'" {
                $desiredResult = @(
                    "^Trying to download file 'PowerShell-[\d\.]+-win-x64.msi' from 'https://github.com/'.$",
                    "Starting 'PowerShell Core' installation.",
                    "'PowerShell Core' installation finished with exit code '0'."
                )
                $desiredResult | ForEach-Object {
                    $verboseCapture | Should -FileContentMatch $_
                }
            }

            it "should successfully install Visual Studio Code extension '<extName>.<extPublisher>'" -TestCases $testCases {
                param(
                    $extName,
                    $extPublisher
                )
                $installedExtensions = Get-InstalledVSCodeExtension
                ## -Contain requires Pester v4
                $installedExtensions.Publisher | Should -Contain $extPublisher
                $installedExtensions.Name | Should -Contain $extName
            }

            it "should set 'PowerShell' as the default language in 'Visual Studio Code'" {
                $settings =  (Resolve-Path "$env:APPDATA\Code*\User\settings.json").Path
                $settings | Should -FileContentMatch '"files.defaultLanguage":  "powershell"'
            }

            it "should configure Visual Studio Code extension 'ShellLauncher' correctly in settings.json" {
                $pathGit = (Resolve-Path "$env:SYSTEMDRIVE\Program Files*\Git\bin\bash.exe").Path
                $pathPSCore = (Resolve-Path "$env:SYSTEMDRIVE\Program Files*\PowerShell\*\pwsh.exe").Path
                $pathGit = $pathGit -replace '\\', '\\'
                $pathPSCore = $pathPSCore -replace '\\', '\\'

                ## Mock settings.json ShellLauncher configuration
                $desiredConfig = '{"shellLauncher.shells.windows":[{"shell":"C:\\WINDOWS\\system32\\cmd.exe","label":'
                $desiredConfig += '"cmd"},{"shell":"C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe",'
                $desiredConfig += "`"label`":`"PowerShell`"},{`"shell`":`"$pathPSCore`",`"label`":`"PowerShellCore`"},"
                $desiredConfig += "{`"shell`":`"$pathGit`",`"label`":`"Gitbash`"}]}"
                ## Transform to a single line string for comparison
                $desiredConfig = $desiredConfig -replace '\s|\n|\t|\r', ''

                ## Get real settings.json ShellLauncher configuration
                $settings =  (Resolve-Path "$env:APPDATA\Code*\User\settings.json").Path
                [System.String]$config = Get-Content $settings
                ## Remove defaultLanguage entry
                $config = $config -replace '"files.defaultLanguage":  "powershell",', ''
                $config = $config -replace '"files.defaultLanguage":  "powershell"', ''
                $config = $config -replace '\],', ']'
                ## Transform to a single line string for comparison
                $config = $config -replace '\s|\n|\t|\r', ''
                $config | should be $desiredConfig
            }
        }

        Context 'Running VSCode functional tests - uninstallation modus' {

            $verboseCapture = "TestDrive:\Capture.txt"

            $ivuParam = @{
                IncludeGit = $true
                IncludePowerShellCore = $true
                Verbose = $true
            }
            ## Uninstall VSCode and additional software
            (Invoke-VSCodeUninstaller @ivuParam -Confirm:$false) 4> $verboseCapture

            @('Visual Studio Code', 'Git', 'PowerShell Core') | ForEach-Object {

                it "should uninstall '$($_)' correctly with return code '0'" {
                    $desiredVerbose = "'$($_)' uninstallation finished with exit code '0'."
                    $verboseCapture | Should -FileContentMatch $desiredVerbose
                }
            }
        }
    }
}
