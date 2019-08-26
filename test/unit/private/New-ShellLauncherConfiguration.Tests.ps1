$ThisModulePath = ($PSScriptRoot -split '\\test')[0]
$ThisModuleName = 'vscodeinstaller'
Import-Module -Name "$ThisModulePath\vscodeinstaller\$ThisModuleName.psd1" -Force


InModuleScope $ThisModuleName {

    Describe 'Unit tests for function New-ShellLauncherConfiguration' {

        it 'should generate a config file with cmd and PowerShell entries if Git and PS Core are not installed.'{
            ## Build mock config file with cmd + PowerShell entries
            $config = '{"shellLauncher.shells.windows":[{"shell":"C:\\WINDOWS\\system32\\cmd.exe","label":"cmd"},'
            $config += '{"shell":"C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\powershell.exe","label":'
            $config += '"PowerShell"}]}'

            mock -ModuleName $ThisModuleName -CommandName 'Get-ChildItem' {
            }
            mock -ModuleName $ThisModuleName -CommandName 'Resolve-Path' {
            }
            ((New-ShellLauncherConfiguration) -replace '\s', '') | should be ($config -replace '\s', '')
        }

        it 'should generate a config file with cmd and PowerShell and Git entries if Git is installed.' {
            ## Build mock config file with cmd + PowerShell + Git entries
            $config = '{"shellLauncher.shells.windows":[{"shell":"C:\\WINDOWS\\system32\\cmd.exe","label":"cmd"},'
            $config += '{"shell":"C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe","label":'
            $config += '"PowerShell"},{"shell":"C:\\ProgramFiles\\Git\\bin\\bash.exe","label":"Gitbash"}]}'

            mock -ModuleName $ThisModuleName -CommandName 'Get-ChildItem' {
            }
            mock -ModuleName $ThisModuleName -CommandName 'Resolve-Path' {
                [PSCustomObject]@{
                    Path = 'C:\Program Files\Git\bin\bash.exe'
                }
            }
            ((New-ShellLauncherConfiguration) -replace '\s', '') | should be ($config -replace '\s', '')
        }

        it 'should generate a config file with cmd, PowerShell and PS Core entries if PS Core is installed.' {
            ## Build mock config file with cmd + PowerShell + Git entries
            $config = '{"shellLauncher.shells.windows":[{"shell":"C:\\WINDOWS\\system32\\cmd.exe","label":"cmd"},'
            $config += '{"shell":"C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe","label":"PowerShell'
            $config += '"},{"shell":"C:\\ProgramFiles\\PowerShell\\6\\pwsh.exe","label":"PowerShellCore"}]}'

            mock -ModuleName $ThisModuleName -CommandName 'Get-ChildItem' {
                [PSCustomObject]@{
                    FullName = 'C:\Program Files\PowerShell\6\pwsh.exe'
                }
            }
            mock -ModuleName $ThisModuleName -CommandName 'Resolve-Path' {
            }
            ((New-ShellLauncherConfiguration) -replace '\s', '') | should be ($config -replace '\s', '')
        }

        it 'should generate a config file with cmd, PowerShell, Git and PS Core entries if Git and PS Core are installed.' {
            ## Build mock config file with cmd + PowerShell + Git + PowerShellCore entries
            $config = '{"shellLauncher.shells.windows":[{"shell":"C:\\WINDOWS\\system32\\cmd.exe","label":"cmd"},'
            $config += '{"shell":"C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe","label":'
            $config += '"PowerShell"},{"shell":"C:\\ProgramFiles\\PowerShell\\6\\pwsh.exe","label":"PowerShellCore"},'
            $config += '{"shell":"C:\\ProgramFiles\\Git\\bin\\bash.exe","label":"Gitbash"}]}'

            mock -ModuleName $ThisModuleName -CommandName 'Get-ChildItem' {
                [PSCustomObject]@{
                    FullName = 'C:\Program Files\PowerShell\6\pwsh.exe'
                }
            }
            mock -ModuleName $ThisModuleName -CommandName 'Resolve-Path' {
                [PSCustomObject]@{
                    Path = 'C:\Program Files\Git\bin\bash.exe'
                }
            }
            ((New-ShellLauncherConfiguration) -replace '\s', '') | should be ($config -replace '\s', '')
        }
    }
}