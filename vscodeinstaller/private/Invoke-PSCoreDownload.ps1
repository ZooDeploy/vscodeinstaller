function Invoke-PSCoreDownload {
     <#
    .SYNOPSIS
        Downloads the latest PowerShell Core installer for Windows.
    .DESCRIPTION
        Invoke-PSCoreDownload downloads the latest PowerShell Core installer for Windows as 32-bit or 64-bit
        version.
    .PARAMETER DestinationPath
        Specifies the destination path where the PowerShell Core installer file will be downloaded. Standard
        destination path is 'C:\Windows\Temp'
    .PARAMETER Architecture
        Specifies the architecture of the PowerShell Core installer file that will be downloaded.
        E.g. 'x64' = 64-bit, 'x86' = 32-bit.
    .PARAMETER PreviewVersion
        Specifies if the preview version of the PowerShell Core installer file will be downloaded instead of the
        stable version.
    .EXAMPLE
        Invoke-PSCoreDownload
        This command downloads the latest PowerShell Core installer for Windows 64-bit stable version to standard
        destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-GitDownload -Architecture 'x86'
        This command downloads the latest PowerShell Core installer for Windows 32-bit stable version to standard
        destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-PSCoreDownload -Destination 'C:\Downloads'
        This command downloads the latest PowerShell Core installer for Windows 64-bit stable version to
        destination path 'C:\Downloads'.
    .EXAMPLE
        Invoke-GitDownload -PreviewVersion
        This command downloads the latest PowerShell Core installer for Windows 64-bit preview version to standard
        destination path 'C:\Windows\Temp'.
    .EXAMPLE
        Invoke-GitDownload -Architecture 'x86' -Destination 'C:\Downloads' -PreviewVersion
        This command downloads the latest PowerShell Core installer for Windows 32-bit preview version to
        destination path 'C:\Downloads'.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-PSCoreDownload.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-PSCoreDownload.md'
    )]
    [OutputType([System.IO.FileInfo])]
    param(
        [System.IO.FileInfo] $DestinationPath = "$env:WINDIR\Temp",

        [ValidateSet('x64', 'x86')]
        [System.String] $Architecture = 'x64',

        [System.Management.Automation.SwitchParameter] $PreviewVersion
    )

    $uri = '{0}PowerShell/PowerShell/releases' -f $localized.github

    try {
        $proxy = [System.Net.WebRequest]::GetSystemWebproxy()
        if ($proxy.IsBypassed($uri)) {
            $web = Invoke-WebRequest $uri -UseBasicParsing -ErrorAction Stop
        }
        else {
            $proxUri = $proxy.GetProxy($uri).AbsoluteUri
            $web = Invoke-WebRequest $uri -UseBasicParsing -Proxy $proxUri -ProxyUseDefaultCredentials -ErrorAction Stop
        }
    }
    catch {
        throw ($localized.WebResourceDownloadFailedError -f $uri)
    }

    ## Get latest PowerShell Core MSI
    if ($PreviewVersion) {
        $uri = $web.Links.href | Select-String -Pattern ".*$Architecture.msi$"
        $uri = ($uri | Where-Object Line -Match 'preview' | Select-Object -First 1).ToString()
    }
    else {
        $uri = $web.Links.href | Select-String -Pattern ".*$Architecture.msi$"
        $uri = $uri | Where-Object {($_.Line -NotMatch 'preview') -and ($_.Line -NotMatch '-rc')}
        $uri = ($uri | Select-Object -First 1).ToString()
    }

    $uri = "{0}$uri" -f $localized.github

    ## Get filename from URL
    $filename = ($uri -split '\/')[-1]
    $destination = Join-Path $DestinationPath -ChildPath $filename
    Write-Verbose ($localized.TryToDownloadFile -f $fileName, $localized.github)
    $path = Invoke-Download -Uri $uri -DestinationPath $destination

    Get-Item -Path $path
}