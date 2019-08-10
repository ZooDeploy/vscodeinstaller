function Test-Installation {
    <#
    .SYNOPSIS
        Tests if a given software is already installed.
    .DESCRIPTION
        Test-Installation tests if a given software is already installed on the local system. Returns true or
        false.
    .PARAMETER RegistryUninstallKey
        Specifies the RegistryUninstallKey that will be searched under the registry uninstall hive.
    .PARAMETER RegistryUninstallString
        Specifies the RegistryUninstallString that will be searched under the registry uninstall hive.
    .PARAMETER DisplayName
        Specifies the DisplayName that will be searched under the registry uninstall hive.
    .PARAMETER Wildcard
        If DisplayName and parameter Wildcard are both selected, the DisplayName will be searched as a wildcard
        match.
    .PARAMETER FilePath
        Specifies the path where the given software file will be searched.
    .PARAMETER FileVersion
        Specifies the file version for the file found under FilePath that will be searched.
    .EXAMPLE
        Test-Installation -RegistryUninstallKey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}'
        Returns true if uninstallkey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}' in the registry uninstall hive
        exists.
    .EXAMPLE
        Test-Installation -RegistryUninstallString 'MsiExec.exe /I{07B92716-BF6D-44D0-8F60-C3C432068784}'
        Returns true if uninstallstring 'MsiExec.exe /I{07B92716-BF6D-44D0-8F60-C3C432068784}' in the registry
        uninstall hive exists.
    .EXAMPLE
        Test-Installation -RegistryUninstallString 'C:\Program Files\Sophos\Endpoint Defense\uninstall.exe'
        Returns true if uninstallstring file '...\uninstall.exe' in the registry uninstall hive exists.
    .EXAMPLE
        Test-Installation -DisplayName 'Adobe Acrobat Reader DC'
        Returns true if displayname 'Adobe Acrobat Reader DC' was exactly found in the registry uninstall hive.
    .EXAMPLE
        Test-Installation -DisplayName 'Adobe Acrobat Reader*' -Wildcard
        Returns true if any displayname beginning with 'Adobe Acrobat Reader DC' was found in the registry
        uninstall hive.
    .EXAMPLE
        Test-Installation -FilePath 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
        Returns true if file '...\AcroRd32.exe' was found.
    .EXAMPLE
        Test-Installation -FilePath 'C:\Program Files (x86)\Adobe\AcroRd32.exe' -FileVersion '18.11.20055.290043'
        Returns true if file '...\AcroRd32.exe' was found and the fileversion matches '18.11.20055.290043'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Test-Installation.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Test-Installation.md'
    )]
    [OutputType([System.Boolean])]
    Param(
        [Parameter(ParameterSetName='RegistryUninstallKey', Mandatory)]
        [System.String] $RegistryUninstallKey,

        [Parameter(ParameterSetName='RegistryUninstallString', Mandatory)]
        [System.String] $RegistryUninstallString,

        [Parameter(ParameterSetName='RegistryDisplayName', Mandatory)]
        [System.String] $DisplayName,

        [Parameter(ParameterSetName='RegistryDisplayName')]
        [Switch] $Wildcard,

        [Parameter(ParameterSetName='File', Mandatory)]
        [System.IO.FileInfo] $FilePath,

        [Parameter(ParameterSetName='File')]
        [System.String] $FileVersion
    )

    $result = $false
    $regPath = @(
        'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    )

    if ($PSBoundParameters.ContainsKey('RegistryUninstallKey')) {
        if ($RegistryUninstallKey -notlike "{*}") {
            $RegistryUninstallKey = "{$RegistryUninstallKey}"
        }
        foreach ($reg in $regPath) {
            $path = Join-Path $reg -ChildPath $RegistryUninstallKey

            if(Test-Path $path){
                $result = $true
            }
        }
    }
    elseif ($PSBoundParameters.ContainsKey('RegistryUninstallString')) {
        $items = Get-ChildItem $regPath
        $uStr = $items | Get-ItemProperty | Select-Object UninstallString
        $uStr = $uStr | Where-Object UninstallString -eq $RegistryUninstallString
        if($uStr) {
            $result = $true
        }
    }
    elseif ($PSBoundParameters.ContainsKey('DisplayName')) {
        $items = Get-ChildItem $regPath
        ## Wildcard match
        if ($PSBoundParameters.ContainsKey('Wildcard')) {
            $dName = $items | Get-ItemProperty | Select-Object DisplayName
            $dName = $dName | Where-Object DisplayName -like $DisplayName
        }
        ## Exact match
        else {
            $dName = $items | Get-ItemProperty | Select-Object DisplayName
            $dName = $dName | Where-Object DisplayName -eq $DisplayName
        }
        if ($dName) {
            $result = $true
        }
    }
    elseif ($PSBoundParameters.ContainsKey('FilePath')) {
        if (Test-Path -LiteralPath $FilePath) {
            if (-not ($PSBoundParameters.ContainsKey('FileVersion'))) {
                $result = $true
            }
            else {
                $fileInfo = Get-Item  $FilePath -ErrorAction SilentlyContinue
                $CheckFileVersion = $fileInfo.VersionInfo.FileVersion
                ## Check if given fileversion or newer already exists
                if ($CheckFileVersion -eq $FileVersion) {
                    $result = $true
                }
            }
        }
    }
    $result
}