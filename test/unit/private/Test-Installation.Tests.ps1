$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Test-Installation' {

        it 'Returns true if uninstallkey {26A24AE4-039D-4CA4-87B4-2F32180181F0} exists' {
            mock -ModuleName $ThisModuleName -CommandName 'Test-Path' -MockWith {
                $true
            }
            Test-Installation -RegistryUninstallKey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}' | should be $true
        }

        it 'Returns false if uninstallkey {26A24AE4-039D-4CA4-87B4-2F32180181F0} does not exists' {
            mock -ModuleName $ThisModuleName -CommandName 'Test-Path' -MockWith {
                $false
            }
            Test-Installation -RegistryUninstallKey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}' | should be $false
        }

        it 'Returns true if uninstallstring [C:\Program Files\Mock\uninstall.exe] exists' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    UninstallString = 'C:\Program Files\Mock\uninstall.exe'
                }
            }
            Test-Installation -RegistryUninstallString 'C:\Program Files\Mock\uninstall.exe'  | should be $true
        }

        it 'Returns true if DisplayName [MockSoftwareName] was found' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    DisplayName = 'MockSoftwareName'
                }
            }
            Test-Installation -DisplayName 'MockSoftwareName'  | should be $true
        }

        it 'Returns false if DisplayName [MockSoftwareNameNotExists] was not found' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    DisplayName = 'MockSoftwareName'
                }
            }
            Test-Installation -DisplayName 'MockSoftwareNameNotExists'  | should be $false
        }

        it 'Returns true if DisplayName [MockSoft*Name] was found with wildcard use' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    DisplayName = 'MockSoftwareName'
                }
            }
            Test-Installation -DisplayName 'MockSoft*Name' -Wildcard  | should be $true
        }

        it 'Returns false if DisplayName [MockSoft*Name] was not found with wildcard use' {
            mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty -MockWith {
                [PSCustomObject]@{
                    DisplayName = 'MockSoftwareName'
                }
            }
            Test-Installation -DisplayName 'MockSoft*NameNotExists' -Wildcard  | should be $false
        }

        it 'Returns false if uninstallstring [C:\Program Files\Mock\uninstall.exe] does not exists' {
            mock -ModuleName VSCodeInstaller -CommandName Get-ItemProperty -MockWith {
                #No UninstallString found
                [PSCustomObject]@{
                    UninstallString = $null
                }
            }
            Test-Installation -RegistryUninstallString 'C:\Program Files\Mock\Mockuninstall.exe' | should be $false
        }

        it 'Returns true if file mock.exe exists' {
            mock -ModuleName VSCodeInstaller -CommandName 'Test-Path' -MockWith {
                $true
            }
            Test-Installation -FilePath "C:\Program Files (x86)\mock.exe" | should be $true
        }

        it 'Returns false if file mock.exe does not exists' {
            mock -ModuleName VSCodeInstaller -CommandName 'Test-Path' -MockWith {
                $false
            }
            Test-Installation -FilePath "C:\Program Files (x86)\mock.exe" | should be $false
        }

        it 'returns true if file mock.exe exists and fileversion is 1.0.0.0' {
            mock -ModuleName VSCodeInstaller -CommandName 'Test-Path' -MockWith {
                $true
            }
            mock -ModuleName VSCodeInstaller Get-Item {
                [PSCustomObject]@{
                    VersionInfo = @{
                        FileVersion = '1.0.0.0'
                    }
                }
            }
            Test-Installation -FilePath "C:\Program Files (x86)\mock.exe" -FileVersion '1.0.0.0'  | Should be $true
        }

        it 'returns false if file mock.exe exists and fileversion is not 1.0.0.0' {
            mock -ModuleName VSCodeInstaller -CommandName 'Test-Path' -MockWith {
                $true
            }
            mock -ModuleName VSCodeInstaller Get-Item {
                [PSCustomObject]@{
                    VersionInfo = @{
                        FileVersion = '6.6.6.6'
                    }
                }
            }
            Test-Installation -FilePath 'C:\abc\mock.exe' -FileVersion '1.0.0.0' | Should be $false
        }
    }
}