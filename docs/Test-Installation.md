---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Test-Installation.md
schema: 2.0.0
---

# Test-Installation

## SYNOPSIS
Tests if a given software is already installed.

## SYNTAX

### RegistryUninstallKey
```
Test-Installation -RegistryUninstallKey <String> [<CommonParameters>]
```

### RegistryUninstallString
```
Test-Installation -RegistryUninstallString <String> [<CommonParameters>]
```

### RegistryDisplayName
```
Test-Installation -DisplayName <String> [-Wildcard] [<CommonParameters>]
```

### File
```
Test-Installation -FilePath <FileInfo> [-FileVersion <String>] [<CommonParameters>]
```

## DESCRIPTION
Test-Installation tests if a given software is already installed on the local system.
Returns true or
false.

## EXAMPLES

### EXAMPLE 1
```
Test-Installation -RegistryUninstallKey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}'
```

Returns true if uninstallkey '{26A24AE4-039D-4CA4-87B4-2F32180181F0}' in the registry uninstall hive
exists.

### EXAMPLE 2
```
Test-Installation -RegistryUninstallString 'MsiExec.exe /I{07B92716-BF6D-44D0-8F60-C3C432068784}'
```

Returns true if uninstallstring 'MsiExec.exe /I{07B92716-BF6D-44D0-8F60-C3C432068784}' in the registry
uninstall hive exists.

### EXAMPLE 3
```
Test-Installation -RegistryUninstallString 'C:\Program Files\Sophos\Endpoint Defense\uninstall.exe'
```

Returns true if uninstallstring file '...\uninstall.exe' in the registry uninstall hive exists.

### EXAMPLE 4
```
Test-Installation -DisplayName 'Adobe Acrobat Reader DC'
```

Returns true if displayname 'Adobe Acrobat Reader DC' was exactly found in the registry uninstall hive.

### EXAMPLE 5
```
Test-Installation -DisplayName 'Adobe Acrobat Reader*' -Wildcard
```

Returns true if any displayname beginning with 'Adobe Acrobat Reader DC' was found in the registry
uninstall hive.

### EXAMPLE 6
```
Test-Installation -FilePath 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'
```

Returns true if file '...\AcroRd32.exe' was found.

### EXAMPLE 7
```
Test-Installation -FilePath 'C:\Program Files (x86)\Adobe\AcroRd32.exe' -FileVersion '18.11.20055.290043'
```

Returns true if file '...\AcroRd32.exe' was found and the fileversion matches '18.11.20055.290043'.

## PARAMETERS

### -DisplayName
Specifies the DisplayName that will be searched under the registry uninstall hive.

```yaml
Type: String
Parameter Sets: RegistryDisplayName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Specifies the path where the given software file will be searched.

```yaml
Type: FileInfo
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileVersion
Specifies the file version for the file found under FilePath that will be searched.

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegistryUninstallKey
Specifies the RegistryUninstallKey that will be searched under the registry uninstall hive.

```yaml
Type: String
Parameter Sets: RegistryUninstallKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RegistryUninstallString
Specifies the RegistryUninstallString that will be searched under the registry uninstall hive.

```yaml
Type: String
Parameter Sets: RegistryUninstallString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wildcard
If DisplayName and parameter Wildcard are both selected, the DisplayName will be searched as a wildcard
match.

```yaml
Type: SwitchParameter
Parameter Sets: RegistryDisplayName
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Test-Installation.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Test-Installation.md)

