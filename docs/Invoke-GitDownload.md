---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeExtensionDownload.md
schema: 2.0.0
---

# Invoke-GitDownload

## SYNOPSIS
Downloads the latest Git for windows.

## SYNTAX

```
Invoke-GitDownload [[-DestinationPath] <FileInfo>] [[-Architecture] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-GitDownload downloads the latest Git for Windows as 32-bit or 64-bit Windows setup.

## EXAMPLES

### EXAMPLE 1
```
Invoke-GitDownload
```

This command downloads the latest Git for Windows 64-bit version to standard destination path
'C:\Windows\Temp'.

### EXAMPLE 2
```
Invoke-GitDownload -Architecture 'x86'
```

This command downloads the latest Git for Windows 32-bit version to standard destination path
'C:\Windows\Temp'.

### EXAMPLE 3
```
Invoke-GitDownload -Destination 'C:\Downloads'
```

This command downloads the latest Git for Windows 64-bit version to destination path 'C:\Downloads'.

### EXAMPLE 4
```
Invoke-GitDownload -Destination 'C:\Downloads' -Architecture 'x86'
```

This command downloads the latest Git for Windows 32-bit version to destination path 'C:\Downloads'.

## PARAMETERS

### -Architecture
Specifies the architecture of the Git Windows setup that will be downloaded.
E.g.
'x64' = 64-bit architecture, 'x86' = 32-bit architecture.

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
Specifies the destination path where the Git setup file will be downloaded.
Standard destination path is
'C:\Windows\Temp'

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$env:WINDIR\temp"
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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeExtensionDownload.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeExtensionDownload.md)

