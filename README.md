## Setup Builder for proQuest DLLs ##

We use WarSetup from here to compile Wix Files into MSI projects

git@github.com:thr27/WarSetup-Fork.git

Version 3.13.12

Add wix binaries from Installer repro: ..\wix311-binaries


## proquestDll.warsetup ##

This is for proquestDLLs.

Please put new versions of DLLs into subfolder DLL and re-run 
build_wxs.cmd

Add any new wix files in Include Tab
IncludeAll-Generated.wxs will pull the new DLL configuration into the final MSI
This file is updated by build_wxs.cmd automatically

## airQuestTSSetup.warsetup ##

This is to install aq_cli.cmd as an application on RemoteDesktop
You need to have an installed app to share it as RemoteApp on new RemoteDesktop Server

