$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
$lData = 'VSCodeInstallerStrings.psd1'
Import-Module -Name "$ThisModulePath\$ThisModuleName.psd1" -Force
Import-LocalizedData -BindingVariable localized -BaseDirectory "$ThisModulePath\data" -FileName $lData


Describe 'Unit tests for function Invoke-VSCodeUninstaller' {

    $verboseCapture = "TestDrive:\Capture.txt"

    it "should display the correct Write-Verbose message if 'Visual Studio Code' is not installed" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            return $false
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $false
        }
        $msg = $localized.SoftwareIsNotInstalled -f $localized.VSCode
        (Invoke-VSCodeUninstaller -Verbose -Confirm:$false) 4> $verboseCapture
        (Get-Content $verboseCapture)[1] | Should Match ([regex]::Escape($msg))
    }

    it "should throw if 'Visual Studio Code' uninstallation fails" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Start-Process {
            Write-Error 'Start-Process failed'
        }
        $msg = ($localized.SoftwareUninstallationError -f $localized.VSCode)
        { Invoke-VSCodeUninstaller -Confirm:$false } | should throw $msg
    }

    it "should return exit code '0' if 'Visual Studio Code' was successfull uninstalled" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Start-Process {
            @{ExitCode = 0}
        }
        mock -ModuleName $ThisModuleName -CommandName ForEach-Object {
            $false
        }
        $msg = ($localized.SoftwareUninstallationResult -f $localized.VSCode, '0')
        (Invoke-VSCodeUninstaller -Verbose -Confirm:$false) 4> $verboseCapture
        (Get-Content $verboseCapture)[2] | Should Match ([regex]::Escape($msg))
    }

    it "should return exit code '0' if 'Git' was successfull uninstalled" {
        mock -ModuleName $ThisModuleName -CommandName Resolve-Path {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Start-Process {
            @{ExitCode = 0}
        }
        mock -ModuleName $ThisModuleName -CommandName ForEach-Object {
            $false
        }
        $msg = $localized.SoftwareUninstallationResult -f $localized.Git, '0'
        (Invoke-VSCodeUninstaller -IncludeGit -Verbose -Confirm:$false) 4> $verboseCapture
        (Get-Content $verboseCapture)[4] | Should Match ([regex]::Escape($msg))
    }

    it "should display the correct Write-Verbose message if 'PowerShell Core' is not installed" {
        mock -ModuleName $ThisModuleName -CommandName Get-ChildItem {
            return $false
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $false
        }
        $msg = $localized.SoftwareIsNotInstalled -f $localized.PSCore
        (Invoke-VSCodeUninstaller -IncludePowerShellCore -Verbose -Confirm:$false) 4> $verboseCapture
        (Get-Content $verboseCapture)[2] | Should Match ([regex]::Escape($msg))
    }

    it "should return exit code '0' if 'PowerShell Core' was successfull uninstalled" {
        mock -ModuleName $ThisModuleName -CommandName Get-ChildItem {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Get-ItemProperty {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Where-Object {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Select-Object {
            return $true
        }
        mock -ModuleName $ThisModuleName -CommandName Start-Process {
            @{ExitCode = 0}
        }
        $msg = $localized.SoftwareUninstallationResult -f $localized.PSCore, '0'
        (Invoke-VSCodeUninstaller -IncludePowerShellCore -Verbose -Confirm:$false) 4> $verboseCapture
        (Get-Content $verboseCapture)[4] | Should Match ([regex]::Escape($msg))
    }
}