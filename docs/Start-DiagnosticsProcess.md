---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Start-DiagnosticsProcess.md
schema: 2.0.0
---

# Start-DiagnosticsProcess

## SYNOPSIS
Starts a process on the local computer.

## SYNTAX

```
Start-DiagnosticsProcess [-FilePath] <FileInfo> [-Arguments] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Start-DiagnosticProcess starts a process on the local computer and displays the output.
To specify the
program that runs in the process, enter an executable file.

## EXAMPLES

### EXAMPLE 1
```
Start-DiagnosticProcess -Filepath 'C:\Program Files\Git\cmd\git.exe' -Arguments 'git config --global user.name'
```

This command executes the program git.exe with the arguments 'config --global user.name'.
The process
output will be send to the standard output stream.

## PARAMETERS

### -Arguments
Specifies parameters or parameter values to use when this command starts the process.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Specifies the path and file name of the program that runs in the process.

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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Start-DiagnosticsProcess.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Start-DiagnosticsProcess.md)

