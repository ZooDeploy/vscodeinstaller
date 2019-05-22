---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-Git.md
schema: 2.0.0
---

# Install-Git

## SYNOPSIS
Installs Git for Windows.

## SYNTAX

```
Install-Git [-FilePath] <FileInfo> [[-UserName] <String>] [[-UserEmail] <String>] [<CommonParameters>]
```

## DESCRIPTION
Install-Git installs Git for Windows on the local computer.

## EXAMPLES

### EXAMPLE 1
```
Install-Git -FilePath 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
```

This command installs Git for Windows using setup file 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
and uses standard user name 'gituser' and standard user email 'gituser@example.com' globally for the
first-time Git setup.

### EXAMPLE 2
```
Install-Git -FilePath 'C:\Windows\Temp\Git-2.20.1-64-bit.exe' -UserName 'example' -UserEmail example@example.com'
```

This command install the Git for Windows setup under 'C:\Windows\Temp\Git-2.20.1-64-bit.exe'
and uses user name 'example' and user email 'example@example.com' globally for the first-time Git setup.

## PARAMETERS

### -FilePath
Specifies the path to the Git for Windows setup file.

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

### -UserEmail
Specifies the user email for commit information.
The user email is globally set in the first-time Git
setup routine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Gituser@example.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Specifies the user name for commit information.
The user name is globally set in the first-time Git setup
routine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Gituser
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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-Git.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Install-Git.md)

