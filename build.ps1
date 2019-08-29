[CmdletBinding()]
Param(
    [System.String[]] $Task = 'default'
)

## Install NuGet provider
if ((Get-PackageProvider).Name -notcontains 'NuGet') {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

## Install mandatory PowerShell modules
$mandatoryModules = @('PSScriptAnalyzer', 'psake', 'PlatyPS')

$mandatoryModules | ForEach-Object {
    if (-not (Get-Module -Name $_ -ListAvailable)) {
        Install-Module -Name $_ -Force
    }
}

## Requires Pester v4 for unit tests
if (((Get-module 'Pester' -ListAvailable | Sort-Object Version)[-1]).Version.Major -lt 4) {
    Install-Module -Name 'Pester' -SkipPublisherCheck -Force
}

Import-Module psake

## Kick off psake
Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task

## Return non zero code if psake fails
exit ([System.Int32](-not $psake.build_success))
