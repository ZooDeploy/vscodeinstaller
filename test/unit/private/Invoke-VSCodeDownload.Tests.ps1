$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\vscodeinstaller\" -FileName $lData


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Invoke-VSCodeDownload' {

        $verboseCapture = "TestDrive:\Capture.txt"
        $testCases =  @(
            @{
                InstallerType = 'User'
                Architecture = 'x64'
                Build = 'Stable'
                Domain = 'aka.ms'
            }
            @{
                InstallerType = 'User'
                Architecture = 'x86'
                Build = 'Stable'
                Domain = 'aka.ms'
            }
            @{
                InstallerType = 'User'
                Architecture = 'x64'
                Build = 'Insider'
                Domain = 'aka.ms'
            }
            @{
                InstallerType = 'User'
                Architecture = 'x86'
                Build = 'Insider'
                Domain = 'aka.ms'
            }
            @{
                InstallerType = 'System'
                Architecture = 'x64'
                Build = 'Stable'
                Domain = 'go.microsoft.com'
            }
            @{
                InstallerType = 'System'
                Architecture = 'x86'
                Build = 'Stable'
                Domain = 'go.microsoft.com'
            }
            @{
                InstallerType = 'System'
                Architecture = 'x64'
                Build = 'Insider'
                Domain = 'go.microsoft.com'
            }
            @{
                InstallerType = 'System'
                Architecture = 'x86'
                Build = 'Insider'
                Domain = 'go.microsoft.com'
            }
        )

        it 'should try to dowload the [VS Code <Architecture> <InstallerType> <Build> version] if parameter [<Architecture>, <InstallerType>, <Build>] are selected.' -TestCases $testCases {
            param(
            $InstallerType,
            $Build,
            $Architecture,
            $Domain
            )
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock\mock.exe'
            }
            mock -ModuleName $ThisModuleName -CommandName 'Invoke-Download' {
                return 'C:\Mock\mock.exe'
            }
            $ivdParam = @{
                InstallerType = $InstallerType
                Build = $Build
                Architecture = $Architecture
                Verbose = $true
            }
            (Invoke-VSCodeDownload @ivdParam) 4> $verboseCapture
            $file = $localized.VSCodeSetup -f $InstallerType, $Build, $Architecture
            $msg = $localized.TryToDownloadFile -f $file, $Domain
            Get-Content $verboseCapture | Should Match ([regex]::Escape($msg))
        }

        it 'should call Invoke-Download 1 time.' {
            mock -ModuleName $ThisModuleName -CommandName Invoke-Download -MockWith {
                return $true
            }
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock'
            }
            Invoke-VSCodeDownload
            Assert-MockCalled -CommandName Invoke-Download -Exactly 1 -Scope It
        }

        it 'should call Get-Item 1 time.' {
            mock -ModuleName $ThisModuleName -CommandName Invoke-Download -MockWith {
                    return $true
            }
            mock -ModuleName $ThisModuleName -CommandName Get-Item -MockWith {
                'C:\Mock'
            }
            Invoke-VSCodeDownload
            Assert-MockCalled -CommandName Get-Item -Exactly 1 -Scope It
        }
    }
}