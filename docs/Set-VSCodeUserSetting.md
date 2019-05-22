---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Set-VSCodeUserSetting.md
schema: 2.0.0
---

# Set-VSCodeUserSetting

## SYNOPSIS
Applies Visual Studio Code user settings.

## SYNTAX

### SourceFile
```
Set-VSCodeUserSetting -SourceFile <FileInfo> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
Set-VSCodeUserSetting -InputObject <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set-VSCodeUserSetting applies Visual Studio Code user settings specified as a JSON file or
JSON object.

## EXAMPLES

### EXAMPLE 1
```
Set-VSCodeUserSettings -FilePath 'C:\Windows\Temp\settings.json'
```

This command applies the Visual Studio Code user settings found in file
'C:\Windows\Temp\settings.json' to the current user.

### EXAMPLE 2
```
$slc = New-ShellLauncherConfiguration; Set-VSCodeUserSetting -InputObject $slc
```

Command New-ShellLauncherConfiguration returns an configuration object that will be stored in $slc.
$slc will then be used as input object in Set-VSCodeUserSetting which applies the configuration to the
current user.

## PARAMETERS

### -InputObject
Specifies the object that contains the Visual Studio Code user settings.

```yaml
Type: Object
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SourceFile
{{ Fill SourceFile Description }}

```yaml
Type: FileInfo
Parameter Sets: SourceFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Set-VSCodeUserSetting.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Set-VSCodeUserSetting.md)

