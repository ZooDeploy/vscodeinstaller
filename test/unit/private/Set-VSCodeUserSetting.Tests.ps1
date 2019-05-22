$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\data" -FileName $lData


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function Set-VSCodeUserSetting' {

        $inputObject = 'mock.json'
        $sourceFile = 'c:\mock\mock.json'
        $verboseCapture = "TestDrive:\Capture.txt"

        mock -ModuleName $ThisModuleName -CommandName 'Resolve-Path' {
                @{path = 'C:\Mock\Code\User'}
        }
        mock -ModuleName $ThisModuleName -CommandName 'Select-Object' {
            'C:\Mock\Code\User'
        }

        it 'should output correct Write-Verbose message if settings.json does not exists.' {

            mock -ModuleName $ThisModuleName -CommandName ConvertFrom-Json -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                return $false
            }
            mock -ModuleName $ThisModuleName -CommandName New-Item -MockWith {
            }
            $verboseCapture = "TestDrive:\Capture.txt"
            (Set-VSCodeUserSetting -InputObject $InputObject -Verbose) 4> $verboseCapture
            $gc = Get-Content $verboseCapture
            $gc[0] | Should Match ([regex]::Escape($localized.JsonMissing))
        }

        it 'should output correct Write-Verbose messages if missing settings.json file was successfully created.' {
            mock -ModuleName $ThisModuleName -CommandName ConvertFrom-Json -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName New-Item -MockWith {
            }
            (Set-VSCodeUserSetting -InputObject $InputObject -Verbose) 4> $verboseCapture
            $gc = Get-Content $verboseCapture
            $gc[1] | Should Match ([regex]::Escape($localized.CreateJsonSuccess))
        }

        it 'should output correct Write-Verbose messages if settings are successfully applied to settings.json file.' {
            $writingMsg = $localized.WritingJson -f 'C:\Mock\Code\User\settings.json'
            $writingSuccessMsg = $localized.WritingJsonSuccess -f 'C:\Mock\Code\User\settings.json'
            $gc = Get-Content $verboseCapture
            $gc[2] | Should Match ([regex]::Escape($writingMsg))
            $gc[3] | Should Match ([regex]::Escape($writingSuccessMsg))
        }

        it 'should throw if json source file was not found.' {
            mock -ModuleName $ThisModuleName -CommandName 'Test-Path' {
                $false
            }
            { Set-VSCodeUserSetting -SourceFile $sourceFile } | should throw ($localized.JsonFileNotFound)
        }

        it 'should throw if json source file could not be imported.' {
            mock -ModuleName $ThisModuleName -CommandName 'Test-Path' {
                $true
            }
            mock -ModuleName $ThisModuleName -CommandName 'ConvertFrom-Json' {
                Write-Error 'ConvertFrom-Json error.'
            }
            { Set-VSCodeUserSetting -SourceFile $sourceFile } | should throw ($localized.ReadingJsonError)
        }

        it 'should throw if input object could not be converted to JSON.' {
            mock -ModuleName $ThisModuleName -CommandName 'ConvertFrom-Json' {
                Write-Error 'ConvertFrom-Json error.'
            }
            { Set-VSCodeUserSetting -InputObject $inputObject } | should throw ($localized.ConvertJsonInputObjectError)
        }

        it 'should throw if writing settings.json fails.' {
            mock -ModuleName $ThisModuleName -CommandName Get-Content -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName Foreach-Object -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName Add-Member -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName ConvertFrom-Json -MockWith {
                ''
            }
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                return $true
            }
            mock -ModuleName $ThisModuleName -CommandName Set-Content -MockWith {
                Write-Error 'Error'
            }
            mock -ModuleName $ThisModuleName -CommandName ConvertTo-Json -MockWith {
                Write-Error 'Error'
            }
            { Set-VSCodeUserSetting -InputObject $inputObject } | should throw $localized.WritingJsonError
        }

        it "should throw if adding values to 'settings.json' fails." {
            mock -ModuleName $ThisModuleName -CommandName ConvertFrom-Json -MockWith {
                'Mock'
            }
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                $true
            }
            mock -CommandName Get-Content -MockWith {
                Write-Error 'get error'
            }
            mock -ModuleName $ThisModuleName -CommandName Foreach-Object -MockWith {
                $true
            }
            mock -CommandName Add-Member -MockWith {
            }
            $file = 'C:\Mock\Code\User\settings.json'
            { Set-VSCodeUserSetting -InputObject $inputObject -ErrorAction Stop } | should throw ($localized.AddJsonValuesError -f $file)

        }

        it "should throw if missing 'settings.json' file could not be created." {
            mock -ModuleName $ThisModuleName -CommandName Test-Path -MockWith {
                $false
            }
            mock -ModuleName $ThisModuleName -CommandName ConvertFrom-Json -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName New-Item -MockWith {
                Write-Error 'Create error.'
            }
            { Set-VSCodeUserSetting -InputObject $inputObject } | should throw ($localized.CreateJsonError)
        }

        it 'should throw if Visual Studio Code APPDATA path was not found.' {
            mock -ModuleName $ThisModuleName -CommandName Select-Object -MockWith {
            }
            mock -ModuleName $ThisModuleName -CommandName Resolve-Path -MockWith {
                $false
            }
            { Set-VSCodeUserSetting -SourceFile $sourceFile } | should throw ($localized.VSCodeNotFound)
        }
    }
}