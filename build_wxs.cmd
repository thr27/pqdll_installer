rem @echo off
setlocal
SetLocal EnableDelayedExpansion

if (%1) == ()  goto eof

REM -------------------------------------------------------------------------
SET DBG_WAIT=pause
SET DBG_WAIT=
SET DBG_CMD=echo
SET DBG_CMD=

SET batchname=%~n0
SET year=%date:~-2,2%
SET month=%date:~-7,2%
SET day=%date:~-10,2%
SET datum=%year%%month%%day%
SET HR=%TIME:~0,2%
SET HR0=%TIME:~0,1%
IF "%HR0%"==" " SET HR=0%TIME:~1,1%
SET MIN=%TIME:~3,2%
SET SEC=%TIME:~6,2%
SET MYDATE=%datum%-%HR%%MIN%%SEC%
set DLL64=%0\..\DLL
SET SCRIPTPATH=%~dp0

pushd
cd %SCRIPTPATH%
set DLLDIR=%DLL64%


(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi"^>
echo 	^<Fragment Id="Include All generated Components"^>
echo 		^<Feature Id="WIXInclude"
echo 			 Title="proquestDll Registrations"
echo 			 Level="1"
echo 			 InstallDefault="local"
echo 			 ^>
) > %dll64%\IncludeAll-Generated.wxs

echo Build wxs ...
for %%d in ( proQuest.airQuest.FarelogixWS.dll xxdotnetclient.dll zlib.net.dll proQuest.airQuest.HttpTls12.dll proQuest.airQuest.eNettVAN.dll ChilkatAx-9.5.0-win32.dll) do (
	echo %%d
	%SCRIPTPATH%\..\TlbExp.exe %dll64%\%%d /out:%dll64%\%%d.tlb
	%SCRIPTPATH%\..\regasm.exe %dll64%\%%d /regfile:%dll64%\%%d.reg
	%SCRIPTPATH%\..\wix311-binaries\heat.exe file %dll64%\%%d.tlb -template fragment  -gg -dr SystemFolder -srd -cg %%~nd.tlb -var sys.SOURCEFILEDIR -out %dll64%\%%d.tlb.wxs
	%SCRIPTPATH%\..\wix311-binaries\heat.exe reg %dll64%\%%d.reg -template fragment -gg -dr SystemFolder -srd -cg %%~nd.reg  -var sys.SOURCEFILEDIR -out %dll64%\%%d.reg.wxs
	%SCRIPTPATH%\..\wix311-binaries\heat.exe file %dll64%\%%d -template fragment -gg -dr SystemFolder -srd -cg %%~nd -var sys.SOURCEFILEDIR -out %dll64%\%%d.wxs
	if exist %dll64%\%%d.tlb.wxs (
		echo ^<ComponentGroupRef Id="%%~nd.tlb" /^>
	) >> %dll64%\IncludeAll-Generated.wxs
	if exist %dll64%\%%d.reg.wxs (
		echo ^<ComponentGroupRef Id="%%~nd.reg" /^>
	) >> %dll64%\IncludeAll-Generated.wxs
	if exist %dll64%\%%d.wxs (
		echo ^<ComponentGroupRef Id="%%~nd" /^>
	) >> %dll64%\IncludeAll-Generated.wxs
)
(
echo ^</Feature^>
echo ^</Fragment^>
echo ^</Wix^>
) >> %dll64%\IncludeAll-Generated.wxs

popd
:eof