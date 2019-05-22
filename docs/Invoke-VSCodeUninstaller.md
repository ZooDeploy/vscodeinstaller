---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeUninstaller.md
schema: 2.0.0
---

# Invoke-VSCodeUninstaller

## SYNOPSIS
Uninstalls Visual Studio Code and optional also Git and/or PowerShell Core.

## SYNTAX

```
Invoke-VSCodeUninstaller [-IncludeGit] [-IncludePowerShellCore] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Completly uninstalls Visual Studio Code and optionally also Git and PowerShell Core.

## EXAMPLES

### EXAMPLE 1
```
Invoke-VSCodeUninstaller -Verbose
```

This command uninstalls only Visual Studio Code from the local system.
As parameter Verbose is used, it
will display extended uninstallation information.

### EXAMPLE 2
```
Invoke-VSCodeUninstaller -IncludeGit
```

This command uninstalls Visual Studio Code and Git from the local system.

### EXAMPLE 3
```
Invoke-VSCodeUninstaller -IncludePowerShellCore
```

This command uninstalls Visual Studio Code and PowerShell Core from the local system.

### EXAMPLE 4
```
Invoke-VSCodeUninstaller -IncludeGit -IncludePowerShellCore
```

This command uninstalls Visual Studio Code, Git and PowerShell Core from the local system.

## PARAMETERS

### -IncludeGit
Specifies if Git will be uninstalled or not.
If IncludeGit is selected, Git will be also uninstalled.

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

### -IncludePowerShellCore
Specifies if PowerShell Core will be uninstalled or not.
If IncludePowerShellCore is selected,
PowerShell Core will be also uninstalled.

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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeUninstaller.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeUninstaller.md)

