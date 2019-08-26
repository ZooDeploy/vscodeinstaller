---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-PSCoreDownload.md
schema: 2.0.0
---

# Invoke-PSCoreDownload

## SYNOPSIS
Downloads the latest PowerShell Core installer for Windows.

## SYNTAX

```
Invoke-PSCoreDownload [[-DestinationPath] <FileInfo>] [[-Architecture] <String>] [-PreviewVersion]
 [<CommonParameters>]
```

## DESCRIPTION
Invoke-PSCoreDownload downloads the latest PowerShell Core installer for Windows as 32-bit or 64-bit
version.

## EXAMPLES

### EXAMPLE 1
```
Invoke-PSCoreDownload
```

This command downloads the latest PowerShell Core installer for Windows 64-bit stable version to standard
destination path 'C:\Windows\Temp'.

### EXAMPLE 2
```
Invoke-GitDownload -Architecture 'x86'
```

This command downloads the latest PowerShell Core installer for Windows 32-bit stable version to standard
destination path 'C:\Windows\Temp'.

### EXAMPLE 3
```
Invoke-PSCoreDownload -Destination 'C:\Downloads'
```

This command downloads the latest PowerShell Core installer for Windows 64-bit stable version to
destination path 'C:\Downloads'.

### EXAMPLE 4
```
Invoke-GitDownload -PreviewVersion
```

This command downloads the latest PowerShell Core installer for Windows 64-bit preview version to standard
destination path 'C:\Windows\Temp'.

### EXAMPLE 5
```
Invoke-GitDownload -Architecture 'x86' -Destination 'C:\Downloads' -PreviewVersion
```

This command downloads the latest PowerShell Core installer for Windows 32-bit preview version to
destination path 'C:\Downloads'.

## PARAMETERS

### -Architecture
Specifies the architecture of the PowerShell Core installer file that will be downloaded.
E.g.
'x64' = 64-bit, 'x86' = 32-bit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: X64
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
Specifies the destination path where the PowerShell Core installer file will be downloaded.
Standard
destination path is 'C:\Windows\Temp'

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:WINDIR\Temp"
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreviewVersion
Specifies if the preview version of the PowerShell Core installer file will be downloaded instead of the
stable version.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.FileInfo
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-PSCoreDownload.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-PSCoreDownload.md)

