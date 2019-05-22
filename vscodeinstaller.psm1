$lData = 'VSCodeInstallerStrings.psd1'
Import-LocalizedData -BindingVariable localized -BaseDirectory "$PSScriptRoot\data" -FileName $lData

$public = Get-ChildItem -Path "$PSScriptRoot\src\public" -Filter '*.ps1' -ErrorAction SilentlyContinue
$private = Get-ChildItem -Path "$PSScriptRoot\src\private" -Filter '*.ps1' -ErrorAction SilentlyContinue

($public + $private) | ForEach-Object {
    Write-Verbose "Importing $($_.BaseName)"
    . $($_.FullName)
}

Export-ModuleMember -Function $public.BaseName -Alias ('gvit', 'ivsc', 'uvsc')