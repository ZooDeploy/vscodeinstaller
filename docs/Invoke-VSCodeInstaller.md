---
external help file: vscodeinstaller-help.xml
Module Name: vscodeinstaller
online version: https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeInstaller.md
schema: 2.0.0
---

# Invoke-VSCodeInstaller

## SYNOPSIS
Installs and sets up Visual Studio Code.

## SYNTAX

### None (Default)
```
Invoke-VSCodeInstaller [-Template <String>] [-InstallerType <String>] [-Architecture <String>]
 [-Build <String>] [-AdditionalExtensions <String[]>] [<CommonParameters>]
```

### SkipGit
```
Invoke-VSCodeInstaller [-Template <String>] [-InstallerType <String>] [-Architecture <String>]
 [-Build <String>] [-AdditionalExtensions <String[]>] [-SkipGitInstallation] [<CommonParameters>]
```

### InstallGit
```
Invoke-VSCodeInstaller [-Template <String>] [-InstallerType <String>] [-Architecture <String>]
 [-Build <String>] [-AdditionalExtensions <String[]>] [-GituserName <String>] [-GitUserEmail <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Invoke-VSCodeInstaller downloads, installs and sets up Visual Studio Code and Git as your coding
environment.
You can skip the Git installation by selecting parameter SkipGitInstallation.

If template 'PowerShell Core' is selected it additionally downloads and installs PowerShell Core, the
VSCode extensions PowerShell and ShellLauncher and sets PowerShell as the default language in VSCode.
The ShellLauncher is automatically configured with a shell entry for PowerShell, PowerShellCore, cmd and
Git bash.

If template 'PowerShell' is selected it additionally downloads and installs the VSCode extension PowerShell
and sets PowerShell as the default language in VSCode.

## EXAMPLES

### EXAMPLE 1
```
Invoke-VSCodeInstaller -Verbose
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and Git for Windows 64-bit version.
Git will be configured with the standard username 'gituser'
and standard user email 'gituser@example.com' globally for the first-time Git setup.
The example uses the
Verbose parameter to display extended installation information like installation return codes.

### EXAMPLE 2
```
Invoke-VSCodeInstaller -SkipGitInstallation
```

This command only downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user
stable version.

### EXAMPLE 3
```
Invoke-VSCodeInstaller -Architecture 'x86' -Build 'insider'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 32-bit user insider
version and the latest Git for Windows 32-bit version.

### EXAMPLE 4
```
Invoke-VSCodeInstaller -GitUserName 'example' -GitUserEmail 'example@example.com'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and the latest Git for Windows 64-bit version and uses user name  and user email
'example@example.com' globally for the first-time Git setup.

### EXAMPLE 5
```
Invoke-VSCodeInstaller -AdditionalExtensions @('ahmadawais.shades-of-purple', 'hoovercj.vscode-power-mode')
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and the latest Git for Windows 64-bit version and the VSCode extensions 'shades-of-purple'and
'vscode-power-mode'.

### EXAMPLE 6
```
Invoke-VSCodeInstaller -Template 'PowerShell'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and the latest Git for Windows 64-bit version.
When Template 'PowerShell' is selected, it will
also download and install the VSCode PowerShell extension and sets PowerShell as the default language in
VSCode.

### EXAMPLE 7
```
Invoke-VSCodeInstaller -Template 'PowerShellCore' -GitUserName 'example' -GitUserEmail 'example@example.com'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and the latest Git for Windows 64-bit version and uses user name 'example' and user email
'example@example.com' globally for the first-time Git setup.
When Template 'PowerShellCore' is selected,
it will also download and install the VSCode PowerShell extension, the Tyriar Shell Launcher extension and
the latest PowerShell Core 64-bit stable version and sets PowerShell as the default language in VSCode.
The ShellLauncher extension will be configured with a shell entry for PowerShell, PowerShell Core, cmd and
Git bash.

### EXAMPLE 8
```
Invoke-VSCodeInstaller -Template 'PowerShellCore' -Architecture 'x86'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 32-bit user stable
version and the latest Git for Windows 32-bit version and uses user name 'example' and user email
'example@example.com' globally for the first-time Git setup.
When Template 'PowerShellCore' is selected,
it will also download and install the VSCode PowerShell extension, the Tyriar Shell Launcher extension and
the latest PowerShell Core 32-bit stable version and sets PowerShell as the default language in VSCode.
The ShellLauncher extension will be configured with a shell entry for PowerShell, PowerShell Core, cmd and
Git bash.

### EXAMPLE 9
```
Invoke-VSCodeInstaller -InstallerType 'System' -GitUserName 'example' -GitUserEmail 'example@example.com'
```

This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit system
stable version and the latest Git for Windows 64-bit version and uses user name 'example' and user email
'example@example.com' globally for the first-time Git setup.

## PARAMETERS

### -AdditionalExtensions
Specifies the full name of the extenisions to install.
An array of extension names is accepted.
Define the full name in the following way: \<publisher name\>.\<extension name\>, for example ms-python.python.

To find the full extension name go the Extensions panel in Visual Studio Code.
The full name is located
on the right to the extension name.

Alternatively, the full name can also be found in the Visual Studio Marketplace URI of the extension, for
example: https://marketplace.visualstudio.com/itemdetails?itemName=ms-python.python

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Architecture
Specifies if the 32-bit or 64-bit Visual Studio Code and Git setup will be downloaded and installed
provided no SkipGitInstallation option is selected.
If Template 'PowerShellCore' is selected, it also
specifies if the 32-bit oder 64-bit version of the PowerShell Core for Windows will be downloaded and
installed.
Default value is 64-bit.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: X64
Accept pipeline input: False
Accept wildcard characters: False
```

### -Build
Specifies if the insider (preview) version or the stable version of the Visual Studio Code setup file will
be downloaded and installed.
If Template 'PowerShellCore' is selected, it also specifies if the preview
version or the stable version of PowerShell Core for Windows will be downloaded and installed.
Default
value is stable.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Stable
Accept pipeline input: False
Accept wildcard characters: False
```

### -GitUserEmail
Specifies the Git user email for commit information.
The user email is globally set in the first-time Git
setup routine.

```yaml
Type: String
Parameter Sets: InstallGit
Aliases:

Required: False
Position: Named
Default value: Gituser@example.com
Accept pipeline input: False
Accept wildcard characters: False
```

### -GituserName
Specifies the Git user name for commit information.
The user name is globally set in the first-time Git
setup routine.

```yaml
Type: String
Parameter Sets: InstallGit
Aliases:

Required: False
Position: Named
Default value: Gituser
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallerType
Specifies if an User oder System Visual Studio Code setup will be downloaded and installed.
The
InstallerType User does not require administrator privileges for installation as the install location will
be under your user local AppData ($env:LOCALAPPDATA) folder.
User setup also provides a smoother background
update experience.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipGitInstallation
Specifies if Git will be installed or not.
If SkipGitInstallation is selected, Git will not be installed.

```yaml
Type: SwitchParameter
Parameter Sets: SkipGit
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template
The name of the template to use with the Invoke-VSCodeInstaller command.
To see a list of available
templates use the Get-VSCodeInstallTemplate command.

You can define your own templates in the VSCodeTemplateData.psd1 file located in the VSCodeInstaller
module folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

[https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeInstaller.md](https://github.com/zoodeploy/vscodeinstaller/blob/master/docs/Invoke-VSCodeInstaller.md)

