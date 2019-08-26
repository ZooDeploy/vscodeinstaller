---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCodeExtension.md
schema: 2.0.0
---

# Install-VSCodeExtension

## SYNOPSIS
Installs Visual Studio Code extensions.

## SYNTAX

```
Install-VSCodeExtension [-Extension] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Install-VSCodeExtension installs one or more Visual Studio Code extensions on the local computer.

## EXAMPLES

### EXAMPLE 1
```
Install-VSCodeExtension -Extension 'ms-vscode.PowerShell'
```

This command installs the PowerShell extension for Visual Studio Code.

### EXAMPLE 2
```
Install-VSCodeExtension -Extension @('ms-vscode.PowerShell', 'ms-python.python')
```

This command installs the PowerShell extension and the Python extension for Visual Studio Code.

## PARAMETERS

### -Extension
Specifies the full name of the extenisions to install.
An array of extension names is accepted.
Define the full name in the following way: \<publisher name\>.\<extension name\>, for example ms-python.python.

To find the full extension name go the Extensions panel in Visual Studio Code.
The full name is located
on the right to the extension name.

Alternatively, the full name can also be found in the Visual Studio Marketplace URI of the extension, for example
https://marketplace.visualstudio.com/itemdetails?itemName=ms-python.python

```yaml
Type: String[]
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

## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCodeExtension.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-VSCodeExtension.md)

