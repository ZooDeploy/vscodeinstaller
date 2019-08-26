function Invoke-Download {
    <#
    .SYNOPSIS
        Downloads files via the System.Net.WebClient class.
    .DESCRIPTION
        Invoke-Download lets you receive data from a resource indentified by a URI.
    .PARAMETER DestinationPath
        Specifies the destiantion path where the resource will be saved. Enter a path and file name.
    .PARAMETER Uri
        Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent.
        Enter a URI. This parameter supports HTTP or HTTPS only.
    .EXAMPLE
        $Uri = 'https://github.com/git-for-windows/Git-2.20.1-64-bit.exe'; $destination = "$env:WINDIR\Temp\Git-2.20.1-64-bit.exe"; Invoke-Download -Uri $Uri -DestinationPath $destination
        Downloads Git-2.20.1-64-bit.exe to destination $env:WINDIR\Temp.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-Download.md
    #>
    [CmdletBinding(
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-Download.md'
    )]
    [OutputType([System.IO.FileInfo])]
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo] $DestinationPath,

        [Parameter(Mandatory)]
        [System.String] $Uri
    )

    try {
        [System.Net.WebClient] $webClient = New-Object -TypeName 'System.Net.WebClient'
        $webClient.Proxy = [System.Net.WebRequest]::GetSystemWebProxy()
        $webClient.UseDefaultCredentials = $true

        ## Proxy is required
        if (-not $webClient.Proxy.IsBypassed($Uri)) {
            $webClient.Proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
            $proxyInfo = $webClient.Proxy.GetProxy($Uri)
            Write-Verbose ($localized.UsingProxy -f $proxyInfo.AbsoluteUri)
        }

        if ($Uri -match 'https'){
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        }

        $inputStream = $webClient.OpenRead($Uri)
        [System.UInt64] $contentLength = $webClient.ResponseHeaders['Content-Length']
        $path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)
        $outputStream = [System.IO.File]::Create($path)
        $bufferSize = 64KB
        $buffer = New-Object -TypeName System.Byte[] -ArgumentList $bufferSize
        $bytesRead = 0
        $totalBytes = 0

        do {
            $bytesRead = $inputStream.Read($buffer, 0, $buffer.Length)
            $totalBytes += $bytesRead
            $downloadedMB = ($totalBytes / 1024 / 1024)
            $totalMB = ($contentLength / 1024 / 1024)
            $outputStream.Write($buffer, 0, $bytesRead)

            if ($contentLength -gt 0) {
                [System.Byte] $percentComplete = ($totalBytes/$contentLength) * 100
                $wpParam = @{
                    Activity = $localized.DownloadActivity -f $Uri
                    PercentComplete = $percentComplete
                    Status = $localized.DownloadStatus -f $percentComplete, $downloadedMB, $totalMB
                }
                Write-Progress @wpParam
            }
        }
        while ($bytesRead -ne 0)

        Get-Item -Path $path
    }
    catch {
        throw ($localized.WebResourceDownloadFailedError -f $Uri)
    }
    finally {
        Write-Progress -Activity ($localized.DownloadActivity -f $Uri) -Completed

        if ($null -ne $outputStream) {
            $outputStream.Close()
        }
        if ($null -ne $inputStream) {
            $inputStream.Close()
        }
        if ($null -ne $webClient) {
            $webClient.Dispose()
        }
    }
}