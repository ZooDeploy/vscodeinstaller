---
external help file:
Module Name:
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/New-ShellLauncherConfiguration.md
schema: 2.0.0
---

# New-ShellLauncherConfiguration

## SYNOPSIS
Generates a ShellLauncher extension configuration.

## SYNTAX

```
New-ShellLauncherConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
New-ShellLauncherConfiguration generates a ShellLauncher extension configuration and sends it to the
standard output stream.
The configuration contains a shell entry for cmd, PowerShell and if installed also
for Git and PowerShell Core.
The configuration can then be imported into the settings.json file in VSCode.

## EXAMPLES

### EXAMPLE 1
```
New-ShellLauncherConfiguration
```

This command generates a ShellLauncher extension configuration and sends it to the standard output stream.

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/New-ShellLauncherConfiguration.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/New-ShellLauncherConfiguration.md)

