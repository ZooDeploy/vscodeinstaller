function Start-DiagnosticsProcess {
    <#
    .SYNOPSIS
        Starts a process on the local computer.
    .DESCRIPTION
        Start-DiagnosticProcess starts a process on the local computer and displays the output. To specify the
        program that runs in the process, enter an executable file.
    .PARAMETER FilePath
        Specifies the path and file name of the program that runs in the process.
    .PARAMETER Arguments
        Specifies parameters or parameter values to use when this command starts the process.
    .EXAMPLE
        Start-DiagnosticProcess -Filepath 'C:\Program Files\Git\cmd\git.exe' -Arguments 'git config --global user.name'
        This command executes the program git.exe with the arguments 'config --global user.name'. The process
        output will be send to the standard output stream.
    .LINK
        https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Start-DiagnosticsProcess.md
    #>
    [CmdletBinding(
        SupportsShouldProcess, ConfirmImpact='Medium',
        HelpURI='https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-InstalledVSCodeExtension.md'
    )]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory)]
        [System.IO.FileInfo] $FilePath,

        [Parameter(Mandatory)]
        [System.String] $Arguments
    )
    if ($PSCmdlet.ShouldProcess('ShouldProcess?')) {
        try{
            $procStart = New-Object System.Diagnostics.ProcessStartInfo
            $procStart.FileName = $FilePath
            $procStart.RedirectStandardError = $true
            $procStart.RedirectStandardOutput = $true
            $procStart.UseShellExecute = $false
            $procStart.Arguments = $Arguments
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $procStart
            $process.Start() | Out-Null
            $process.WaitForExit()
            $output = $process.StandardOutput.ReadToEnd()
        }
        catch{
            throw ($localized.StartDiagnosticsProcessError -f $FilePath)
        }
    }
    Write-Output $output
}