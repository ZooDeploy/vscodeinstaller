# Requires -RunAsAdministrator
function Set-VSCodeUserSetting {
    <#
    .SYNOPSIS
        Applies Visual Studio Code user settings.
    .DESCRIPTION
        Set-VSCodeUserSetting applies Visual Studio Code user settings specified as a JSON file or
        JSON object.
    .PARAMETER InputObject
        Specifies the object that contains the Visual Studio Code user settings.
    .PARAMETER SourcePath
        Specifies the path to the VSCode user settings JSON file.
    .EXAMPLE
        Set-VSCodeUserSettings -FilePath 'C:\Windows\Temp\settings.json'
        This command applies the Visual Studio Code user settings found in file
        'C:\Windows\Temp\settings.json' to the current user.
    .EXAMPLE
        $slc = New-ShellLauncherConfiguration; Set-VSCodeUserSetting -InputObject $slc
        Command New-ShellLauncherConfiguration returns an configuration object that will be stored in $slc.
        $slc will then be used as input object in Set-VSCodeUserSetting which applies the configuration to the
        current user.

    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Set-VSCodeUserSetting.md
    #>
    [OutputType([System.String])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        [Parameter(ParameterSetName='SourceFile', Mandatory, ValueFromPipeline)]
        [System.IO.FileInfo] $SourceFile,

        [Parameter(ParameterSetName='InputObject', Mandatory, ValueFromPipeline)]
        [System.Object] $InputObject
    )

    $destination = Resolve-Path "$env:APPDATA\Code*\User" | Select-Object -ExpandProperty Path -First 1

    if (-not($destination)) {
        throw ($localized.VSCodeNotFound)
    }

    $file = Join-Path $destination -ChildPath 'settings.json'

    if ($SourceFile) {
        if (Test-Path $SourceFile) {
            try {
                $json = Get-Content $SourceFile -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            }
            catch {
                throw ($localized.ReadingJsonError)
            }
        }
        else {
            throw ($localized.JsonFileNotFound)
        }
    }
    elseif ($InputObject) {
        try {
            $json = ($InputObject | ConvertFrom-Json -ErrorAction Stop)
        }
        catch {
            throw ($localized.ConvertJsonInputObjectError)
        }
    }

    ## Add values to existing settings.json
    if (Test-Path -LiteralPath $file -PathType Leaf) {
        try {
            $localSettingsJson = Get-Content $file -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            $localSettingsJson.PSObject.Properties | ForEach-Object {
                $json | Add-Member -MemberType $_.MemberType -Name $_.Name -Value $_.Value -Force -ErrorAction Stop
            }
            Write-Verbose ($localized.AddJsonValuesSuccess -f $file)
        }
        catch {
            throw ($localized.AddJsonValuesError -f $file)
        }
    }
    else {
        try {
            Write-Verbose ($localized.JsonMissing)
            New-Item $file -ItemType File -Force -ErrorAction Stop | Out-Null
            Write-Verbose ($localized.CreateJsonSuccess)
        }
        catch {
            throw ($localized.CreateJsonError)
        }
    }
    try {
        write-Verbose ($localized.WritingJson -f $file)
        $json | ConvertTo-Json -Depth 100 -ErrorAction Stop | Set-Content $file -ErrorAction Stop -Force
        Write-Verbose ($localized.WritingJsonSuccess -f $file)
    }
    catch {
        throw ($localized.WritingJsonError)
    }
}