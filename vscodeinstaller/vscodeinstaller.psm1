$lData = 'VSCodeInstallerStrings.psd1'
Import-LocalizedData -BindingVariable localized -BaseDirectory $PSScriptRoot -FileName $lData

$public = Get-ChildItem -Path "$PSScriptRoot\public" -Filter '*.ps1' -ErrorAction SilentlyContinue
$private = Get-ChildItem -Path "$PSScriptRoot\private" -Filter '*.ps1' -ErrorAction SilentlyContinue

($public + $private) | ForEach-Object {
    Write-Verbose "Importing $($_.BaseName)"
    . $($_.FullName)
}

Export-ModuleMember -Function $public.BaseName -Alias ('gvit', 'ivsc', 'uvsc')