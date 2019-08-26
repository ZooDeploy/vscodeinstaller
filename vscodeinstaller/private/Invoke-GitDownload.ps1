function Invoke-GitDownload {
     <#
    .SYNOPSIS
        Downloads the latest Git for windows.
    .DESCRIPTION
        Invoke-GitDownload downloads the latest Git for Windows as 32-bit or 64-bit Windows setup.
    .PARAMETER DestinationPath
        Specifies the destination path where the Git setup file will be downloaded. Standard destination path is
        'C:\Windows\Temp'
    .PARAMETER Architecture
        Specifies the architecture of the Git Windows setup that will be downloaded.
        E.g. 'x64' = 64-bit architecture, 'x86' = 32-bit architecture.
    .EXAMPLE
        Invoke-GitDownload
        This command downloads the latest Git for Windows 64-bit version to standard destination path
        'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-GitDownload -Architecture 'x86'
        This command downloads the latest Git for Windows 32-bit version to standard destination path
        'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-GitDownload -Destination 'C:\Downloads'
        This command downloads the latest Git for Windows 64-bit version to destination path 'C:\Downloads'.
    .EXAMPLE
        Invoke-GitDownload -Destination 'C:\Downloads' -Architecture 'x86'
        This command downloads the latest Git for Windows 32-bit version to destination path 'C:\Downloads'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeExtensionDownload.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-GitDownload.md'
    )]
    [OutputType([System.IO.FileInfo])]
    param(
        [System.IO.FileInfo] $DestinationPath = "$env:WINDIR\temp",

        [ValidateSet('x64', 'x86')]
        [System.String] $Architecture = 'x64'
    )
    ## Transform architecture to find pattern on Git download page (e.g. x64 -> 64, x86 -> 32)
    $arch = $Architecture -replace 'x', '' -replace '86', '32'
    $uri = 'https://git-scm.com/download/win'
    $pattern = "{0}-bit.exe" -f $arch

    try{
        $web = Invoke-WebRequest -Uri $uri -UseBasicParsing -ErrorAction Stop
    }
    catch{
        throw ($localized.WebResourceDownloadFailedError -f $uri)
    }

    $uri = ($web.Links.href | Select-String -Pattern $pattern | Select-Object -First 1).ToString()
    $uriParent = ($uri -split '\/')[2]
    $filename = ($uri -split '\/')[-1]
    Write-Verbose ($localized.TryToDownloadFile -f $filename, $uriParent)
    $destination = Join-Path $DestinationPath -ChildPath $filename
    $path = Invoke-Download -Uri $uri -DestinationPath $destination

    Get-Item -Path $path
}