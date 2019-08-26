---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeDownload.md
schema: 2.0.0
---

# Invoke-VSCodeDownload

## SYNOPSIS
Downloads the latest Visual Studio Code setup for Windows.

## SYNTAX

```
Invoke-VSCodeDownload [[-InstallerType] <String>] [[-Architecture] <String>] [[-Build] <String>]
 [[-DestinationPath] <FileInfo>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-VSCoreDownload downloads the latest Visual Studio Code installer for Windows as 32-bit or 64-bit
version.
It is also possible to choose between the stable version and the insider version and between the
user and system installer type.

## EXAMPLES

### EXAMPLE 1
```
Invoke-VSCodeDownload
```

This command downloads the latest Visual Studio Code setup for Windows as 64-bit user stable version to
standard destination path 'C:\Windows\Temp'.

### EXAMPLE 2
```
Invoke-VSCodeDownload -Architecture 'x86'
```

This command downloads the latest Visual Studio Code setup for Windows as 32-bit user stable version to
standard destination path 'C:\Windows\Temp'.

### EXAMPLE 3
```
Invoke-VSCodeDownload -Destination 'C:\Downloads'
```

This command downloads the latest Visual Studio Code setup for Windows as 64-bit user stable version to
destination path 'C:\Downloads'.

### EXAMPLE 4
```
Invoke-VSCodeDownload -InstallerType 'System'
```

This command downloads the latest Visual Studio Code setup for Windows as 64-bit system stable version to
standard destination path 'C:\Windows\Temp'.

### EXAMPLE 5
```
Invoke-VSCodeDownload -InstallerType 'System' -Build 'Insider'
```

This command downloads the latest Visual Studio Code setup for Windows as 64-bit system insider version to
standard destination path 'C:\Windows\Temp'.

## PARAMETERS

### -Architecture
Specifies if the 32-bit oder 64-bit of Visual Studio Code setup will be downloaded.
Standard is the 64-bit
version.

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

### -Build
Specifies if the insider (preview) version or the stable version of the Visual Studio Code setup file will
be downloaded.
Standard is the stable version.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Stable
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
Specifies the destination path where the Visual Studio Code setup file will be downloaded.
Standard
destination path is 'C:\Windows\Temp'

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: "$env:WINDIR\Temp"
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallerType
Specifies if an User oder System Visual Studio Code setup will be downloaded.
The InstallerType User does
not require administrator privileges as the install location will be under your user local AppData
LOCALAPPDATA) folder.
User setup also provides a smoother background update experience.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: User
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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeDownload.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeDownload.md)

