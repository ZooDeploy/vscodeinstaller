function Invoke-VSCodeDownload {
    <#
    .SYNOPSIS
        Downloads the latest Visual Studio Code setup for Windows.
    .DESCRIPTION
        Invoke-VSCoreDownload downloads the latest Visual Studio Code installer for Windows as 32-bit or 64-bit
        version. It is also possible to choose between the stable version and the insider version and between the
        user and system installer type.
    .PARAMETER InstallerType
        Specifies if an User oder System Visual Studio Code setup will be downloaded. The InstallerType User does
        not require administrator privileges as the install location will be under your user local AppData
        LOCALAPPDATA) folder. User setup also provides a smoother background update experience.
    .PARAMETER Architecture
        Specifies if the 32-bit oder 64-bit of Visual Studio Code setup will be downloaded. Standard is the 64-bit
        version.
    .PARAMETER Build
        Specifies if the insider (preview) version or the stable version of the Visual Studio Code setup file will
        be downloaded. Standard is the stable version.
    .PARAMETER DestinationPath
        Specifies the destination path where the Visual Studio Code setup file will be downloaded. Standard
        destination path is 'C:\Windows\Temp'
    .EXAMPLE
        Invoke-VSCodeDownload
        This command downloads the latest Visual Studio Code setup for Windows as 64-bit user stable version to
        standard destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-VSCodeDownload -Architecture 'x86'
        This command downloads the latest Visual Studio Code setup for Windows as 32-bit user stable version to
        standard destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-VSCodeDownload -Destination 'C:\Downloads'
        This command downloads the latest Visual Studio Code setup for Windows as 64-bit user stable version to
        destination path 'C:\Downloads'.
    .EXAMPLE
        Invoke-VSCodeDownload -InstallerType 'System'
        This command downloads the latest Visual Studio Code setup for Windows as 64-bit system stable version to
        standard destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-VSCodeDownload -InstallerType 'System' -Build 'Insider'
        This command downloads the latest Visual Studio Code setup for Windows as 64-bit system insider version to
        standard destination path 'C:\Windows\Temp'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeDownload.md
    #>
    [OutputType([System.IO.FileInfo])]
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeDownload.md'
    )]
    param (
        [ValidateSet('User', 'System')]
        [System.String] $InstallerType = 'User',

        [ValidateSet('x64', 'x86')]
        [System.String] $Architecture = 'x64',

        [ValidateSet('Stable', 'Insider')]
        [System.String] $Build = 'Stable',

        [System.IO.FileInfo] $DestinationPath = "$env:WINDIR\Temp"
    )

    ## User installer stable/insider x64/x86
    if ($InstallerType -eq 'User') {
        switch ($Architecture) {
            'x64' { $uri = "https://aka.ms/win32-{0}-user-{1}" -f $Architecture, $Build }
            'x86' { $uri = "https://aka.ms/win32-user-{0}" -f $Build }
        }
    }
    ## System installer stable/insider x64/x86
    else {
        if ($Build -eq 'stable') {
             switch ($Architecture) {
                'x64' { $uri = 'https://go.microsoft.com/fwlink/?Linkid=852157' }
                'x86' { $uri = 'https://go.microsoft.com/fwlink/?LinkID=623230s' }
            }
        }
        else {
            switch ($Architecture) {
                'x64' { $uri = 'https://go.microsoft.com/fwlink/?Linkid=852155' }
                'x86' { $uri = 'https://go.microsoft.com/fwlink/?LinkId=723965' }
            }
        }
    }

    $destination = "{0}\VSCodeSetup-{1}.exe" -f $DestinationPath, $Architecture
    $file = 'VSCode{0}{1}Setup-{2}.exe' -f $InstallerType, $Build, $Architecture
    $uriParent = ($uri -split '\/')[2]
    Write-Verbose ($localized.TryToDownloadFile -f $file, $uriParent)
    $path = Invoke-Download -Uri $uri -DestinationPath $destination

    Get-Item -Path $path
}