---
external help file: VSCodeInstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-Download.md
schema: 2.0.0
---

# Invoke-Download

## SYNOPSIS
Downloads files via the System.Net.WebClient class.

## SYNTAX

```
Invoke-Download [-DestinationPath] <FileInfo> [-Uri] <String> [<CommonParameters>]
```

## DESCRIPTION
Invoke-Download lets you receive data from a resource indentified by a URI.

## EXAMPLES

### EXAMPLE 1
```
$Uri = 'https://github.com/git-for-windows/Git-2.20.1-64-bit.exe'; $destination = "$env:WINDIR\Temp\Git-2.20.1-64-bit.exe"; Invoke-Download -Uri $Uri -DestinationPath $destination
```

Downloads Git-2.20.1-64-bit.exe to destination $env:WINDIR\Temp.

## PARAMETERS

### -DestinationPath
Specifies the destiantion path where the resource will be saved.
Enter a path and file name.

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

### -Uri
Specifies the Uniform Resource Identifier (URI) of the Internet resource to which the web request is sent.
Enter a URI.
This parameter supports HTTP or HTTPS only.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.IO.FileInfo
## NOTES

## RELATED LINKS

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-Download.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-Download.md)

