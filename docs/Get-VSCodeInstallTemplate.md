---
external help file: vscodeinstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-VSCodeInstallTemplate.md
schema: 2.0.0
---

# Get-VSCodeInstallTemplate

## SYNOPSIS
Lists the available Visual Studio Code installation templates.

## SYNTAX

```
Get-VSCodeInstallTemplate [<CommonParameters>]
```

## DESCRIPTION
Lists the available Visual Studio Code installation templates.
The templates can be used with the
Invoke-VSCodeInstaller command for simplified installations.

## EXAMPLES

### EXAMPLE 1
```
Get-VSCodeInstallTemplate
```

Outputs the latest available template content.

### EXAMPLE 2
```
Get-VSCodeInstallTemplate | Select-Object Template
```

Outputs the latest available template names only.

### EXAMPLE 3
```
Get-VSCodeInstallTemplate | Select-Object Description
```

Outputs the latest available template descriptions only.

### EXAMPLE 4
```
Get-VSCodeInstallTemplate | Select-Object Extensions
```

Outputs the latest available template extension names only.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-VSCodeInstallTemplate.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Get-VSCodeInstallTemplate.md)

