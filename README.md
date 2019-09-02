# VSCodeInstaller

[![Build Status](https://dev.azure.com/ZooDeploy/VSCodeInstaller/_apis/build/status/ZooDeploy.vscodeinstaller?branchName=master)](https://dev.azure.com/ZooDeploy/VSCodeInstaller/_build/latest?definitionId=1&branchName=master)

Windows PowerShell module for installing and setting up Visual Studio Code.
 
<ul>
   <li>VSCodeInstaller is an easy, fast way to install and setup Visual Studio Code as your coding environment.</li>
   <li>It downloads and installs VSCode and optional Git and additional VSCode extensions automatically for you.</li>
   <li>Are you a PowerShell coder? Use VSCodeInstaller to install and set up Visual Studio Code as your PowerShell coding ecosystem including PowerShell Core, set PowerShell as the VSCode default language and work with multiple shells (PS, PSCore, cmd, Git bash) parallel in the integrated VSCode terminal via the ShellLauncher extension.</li>
   <li>Do you want to uninstall VSCode? Use VSCodeInstaller to completely remove VSCode and optional remove Git and PowerShell Core.</li>
</ul>

![Invoke-VSCodeInstaller](https://github.com/ZooDeploy/VSCodeInstaller/blob/master/img/ivsc01.gif)

## Installation
To install the module from PowerShell Gallery, use the PowerShell Cmdlet:

```powershell
Install-Module -Name VSCodeInstaller
```

## Getting Started ##
Below you will find some examples for using the VSCodeInstaller module.
For more information refer to the provided <a href="https://github.com/ZooDeploy/vscodeinstaller/blob/master/docs/">comment based help</a>.
 
### VSCodeInstaller installation examples ###

#### EXAMPLE 1: Install VSCode and Git
```
Invoke-VSCodeInstaller -Verbose
```
This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version.
It also downloads and install the latest Git for Windows 64-bit version and as parameter GitUserName and GitUserEmail are not used, Git will be configured with the standard username 'gituser' and standard user email 'gituser@example.com' globally for the first-time Git setup. The example uses the Verbose parameter to display extended installation information like installation return codes.

#### EXAMPLE 2: Just install VSCode
```
Invoke-VSCodeInstaller -SkipGitInstallation
```
This command only downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user
stable version.

#### EXAMPLE 3: Install VSCode, Git and PowerShell Core
```
Invoke-VSCodeInstaller -Template 'PowerShellCore' -GitUserName 'example' -GitUserEmail 'example@example.com'
```
This command downloads and installs the latest Visual Studio Code setup for Windows as 64-bit user stable
version and the latest Git for Windows 64-bit version and uses user name 'example' and user email 'example@example.com'
globally for the first-time Git setup. 

When Template 'PowerShellCore' is selected, it will also download and install the VSCode PowerShell extension, the Tyriar Shell Launcher extension and the latest PowerShell Core 64-bit stable version and sets PowerShell as the default language in VSCode.The ShellLauncher extension will be configured with a shell entry for PowerShell, PowerShell Core, cmd and Git bash.

#### EXAMPLE 4: Install VSCode, Git and additional VSCode extension 
```
Invoke-VSCodeInstaller -Architecture 'x86' -Build 'insider' -AdditionalExtensions @('ahmadawais.shades-of-purple')
```
This command downloads and installs the latest Visual Studio Code setup for Windows as 32-bit user insider version and the VSCode extension 'shades-of-purple'. It also downloads and install the latest Git for Windows 32-bit version and uses standard user name 'gituser' and standard user email 'gituser@example.com' globally for the first-time Git setup.
<br/><br/>

### VSCodeInstaller uninstallation examples ###
#### EXAMPLE 1: Uninstall VSCode
```
Invoke-VSCodeUninstaller -Verbose
```
This command uninstalls only Visual Studio Code from the local system. The example uses the Verbose parameter
to display extended uninstallation information.

#### EXAMPLE 2: Uninstall VSCode, Git and PowerShell Core
```
Invoke-VSCodeUninstaller -IncludeGit -IncludePowerShellCore
```
This command uninstalls Visual Studio Code, Git and PowerShell Core from the local system.
<br/><br/>

![Invoke-VSCodeInstaller](https://github.com/ZooDeploy/VSCodeInstaller/blob/master/img/uvsc01.gif)