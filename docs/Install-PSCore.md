---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-PSCore.md
schema: 2.0.0
---

# Install-PSCore

## SYNOPSIS
Installs PowerShell Core for windows.

## SYNTAX

```
Install-PSCore [-FilePath] <FileInfo> [<CommonParameters>]
```

## DESCRIPTION
Install-PSCore installs PowerShell Core for Windows on the local computer.

## EXAMPLES

### EXAMPLE 1
```
Install-PSCore -FilePath 'C:\Windows\Temp\PowerShell-6.1.2-win-x64.msi'
```

This command installs PowerShell Core using setup file
'C:\Windows\Temp\PowerShell-6.1.2-win-x64.msi'.

## PARAMETERS

### -FilePath
Specifies the path to the PowerShell Core installer setup file.

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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-PSCore.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-PSCore.md)

