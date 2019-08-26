---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCode.md
schema: 2.0.0
---

# Install-VSCode

## SYNOPSIS
Installs Visual Studio Code for windows.

## SYNTAX

```
Install-VSCode [-FilePath] <FileInfo> [<CommonParameters>]
```

## DESCRIPTION
Install-VSCode installs Visual Studio Code on the local computer.

## EXAMPLES

### EXAMPLE 1
```
Install-VSCode -FilePath 'C:\Windows\Temp\VSCodeSetup-x64.exe'
```

This command installs Visual Studio Code using setup file
'C:\Windows\Temp\VSCodeSetup-x64.exe'.

## PARAMETERS

### -FilePath
Specifies the path to the Visual Studio Code setup file.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Int32
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCode.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCode.md)

