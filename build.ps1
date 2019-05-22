[CmdletBinding()]
Param(
    [string[]]$Task = 'default'
)

## Install NuGet provider
if ((Get-PackageProvider).Name -notcontains 'NuGet') {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

## Install mandatory PowerShell modules
$mandatoryModules = @('PSScriptAnalyzer', 'Pester', 'psake', 'PlatyPS')

$mandatoryModules | ForEach-Object {
    if (-not (Get-Module -Name $_ -ListAvailable)) {
        Install-Module -Name $_ -Scope CurrentUser -SkipPublisherCheck -Force
    }
}

## Kick off psake
Invoke-psake -buildFile "$PSScriptRoot\psakeBuild.ps1" -taskList $Task

## Return non zero code if psake fails
exit ([int]( -not $psake.build_success))
