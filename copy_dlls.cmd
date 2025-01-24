rem @echo off
setlocal
SetLocal EnableDelayedExpansion
echo DEPRECATED - DO NOT USE!
goto eof
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
rem SET log=\\fti-muc01-prq01\d$\Batch\LOGS\%batchname%_%COMPUTERNAME%_%mydate%.txt
SET log=d:\Batch\LOGS\%batchname%_%COMPUTERNAME%_%mydate%.txt

set DLL_DIR_OTHER=Q:\airquest\install\DLLS-other
set DLL_DIR_UTILS=Q:\AIRQUEST\utils
set DLL_DIR_INSTALL=Q:\airquest\install
rem set DLL_DIR_AMAWS=q:\AIRQUEST\aqvers\dll
set DLL_DIR_AMAWS=Q:\AIRQUEST\install\Amadeus\amaws
set DLL_INSTALL_ENET=q:\airquest\install\eNett\
set DLL_INSTALL_Farelogix=q:\AIRQUEST\install\Farelogix
set DLL_INSTALL_EOS=q:\AIRQUEST\install\EOS
set DLL64=%0\..\DLL

rem for /f %%i in ('Kroet.exe -gs') do set session=%%i

if exist %dll64%\proQuest.airQuest.AmexvPay.dll del %dll64%\proQuest.airQuest.AmexvPay.dll

if (%1) == (UPDATE) goto UPDATE
goto eof

for %%r in (PRQ41 PRQ46 PRQ47 PRQ48 PRQ51 PRQ52 PRQ53 PRQ54 PRQ55  PRQ56  PRQ57 PRQ58  PRQ59) do (
	rem DOES NOT WORK YET!
	psexec \\FTI-MUC01-%%r cmd.exe -u muc01_airquest -p a1rq3st /c \\fti-muc01-prq01\batch\RTU_update_dlls.cmd UPDATE
)

goto eof
:UPDATE

REM -----------------------------------------------------------------------------------------------
Kroet.exe -bsn "%batchname%" -bsf "Update SysWOW64 DLLs" -bsfd "Update SysWO64 DLLs" -ss "%session%"
SET ACTION=Update SysWO64 DLLs 
REM -----------------------------------------------------------------------------------------------
TITLE %ACTION%
ECHO %date% %time% STARTE: %ACTION%>>%log%

pushd
set DLLDIR=%DLL_DIR_OTHER%
cd %DLLDIR%


rem for %%d in (*.DLL) do (
for %%d in ( proQuest.airQuest.AmexvPay.dll APIv2_COM.dll COMWRAPPER4MANAGED.dll Encryption.dll GdiPlus.dll ICSharpCode.SharpZipLib.dll itextsharp.dll Log4Fox.dll log4net.dll msvcp71.dll msvcr71.dll NETExtenderDLL.dll NetExtenderSupport.dll PdfSharp-WPF.dll proQuest.airQuest.AirPlusXml.dll proQuest.airQuest.DatamixxLookup.dll proQuest.airQuest.DatamixxLookup.XmlSerializers.dll proQuest.airQuest.LocalEmailClient.dll proQuest.airQuest.Pdf2Text.dll proQuest.airQuest.WmiPerformance.dll txmsCrypto.dll ) do (
	dir /b %%d
	if not exist %dll64%\%%d %DBG_CMD% echo Update %DLLDIR%\%%d TO %dll64%\%%d >> %log%
	if not exist %dll64%\%%d %DBG_CMD% rem copy %DLLDIR%\%%d %dll64%\%%d >> %log%
	
	rem regsvr32 /s %dll64%\%%d
)
popd
pushd

set DLLDIR=%DLL_DIR_INSTALL%
cd %DLLDIR%
rem for %%d in (*.DLL) do (
for %%d in (uApi\proQuest.airQuest.uAPI.dll uApi\proQuest.airQuest.uAPI.XmlSerializers.dll TLS12\proQuest.airQuest.HttpTls12.dll) do (
	dir /b %%d
	::if not exist %dll64%\%%d 
	%DBG_CMD% echo Update %DLLDIR%\%%d TO %dll64%\ >> %log%
	::if not exist 	%dll64%\%%d 
	copy %DLLDIR%\%%d %dll64%\ >> %log%
	 
	dir %DLLDIR%\%%d %dll64%\
)

popd

set DLLDIR=%DLL_DIR_UTILS%
cd %DLLDIR%
rem for %%d in (*.DLL) do (
for %%d in (proQuest.airQuest.ImapClient.dll LumiSoft.Net.dll ) do (
	dir /b %%d
	::if not exist %dll64%\%%d 
	%DBG_CMD% echo Update %DLLDIR%\%%d TO %dll64%\%%d >> %log%
	::if not exist 	%dll64%\%%d 
	%DBG_CMD% rem copy %DLLDIR%\%%d %dll64%\%%d >> %log%
	 
	dir %DLLDIR%\%%d %dll64%\%%d
)

popd
:: flx nach q:\airquest kopieren
rem c:\Windows\SysWOW64\regsvr32.exe /s Q:\AIRQUEST\xxclientx.dll 
rem c:\Windows\SysWOW64\regsvr32.exe /s %dll64%\txmsCrypto.dll

pushd
set DLLDIR=%DLL_DIR_AMAWS%
cd %DLLDIR%
rem for %%d in (*.DLL) do (
for %%d in (proQuest.airQuest.AmaWs4.dll) do (
	dir /b %%d
	echo Update %DLLDIR%\%%d TO %dll64%\%%d >> %log%
	if exist %dll64%\%%d ren %dll64%\%%d %%d.old.%MYDATE%
	copy %DLLDIR%\%%d %dll64%\%%d >> %log%
)
popd

pushd


set DLLDIR=%DLL_INSTALL_EOS%
cd %DLLDIR%
rem for %%d in (*.DLL) do (
for %%d in (proQuest.airQuest.TICKeos.dll proQuest.airQuest.TICKeos.XmlSerializers.dll) do (
	dir /b %%d
	if exist %dll64%\%%d ren %dll64%\%%d %%d.old.%MYDATE% 
	echo Update %DLLDIR%\%%d TO %dll64%\%%d
	echo Update %DLLDIR%\%%d TO %dll64%\%%d >> %log%
	copy %DLLDIR%\%%d %dll64%\%%d >> %log%
	echo rem copy Done ...

)
popd
pushd

set DLLDIR=%DLL_INSTALL_Farelogix%
cd %DLLDIR%
rem for %%d in (*.DLL) do (
for %%d in (proQuest.airQuest.FarelogixWS.dll zlib.net.dll xxdotnetclient.dll) do (
	dir /b %%d
	if exist %dll64%\%%d ren %dll64%\%%d %%d.old.%MYDATE% 
	echo Update %DLLDIR%\%%d TO %dll64%\%%d
	echo Update %DLLDIR%\%%d TO %dll64%\%%d >> %log%
	copy %DLLDIR%\%%d %dll64%\%%d >> %log%
	echo rem copy Done ...

)
echo Regasm ...
for %%d in ( proQuest.airQuest.FarelogixWS.dll xxdotnetclient.dll zlib.net.dll proQuest.airQuest.HttpTls12.dll) do (
	echo %%d
	echo Regasm codebase from %dll64%\%%d	
	
	echo Regasm codebase from %dll64%\%%d >> %log%
	rem %SystemRoot%\Microsoft.Net\Framework\v4.0.30319\regasm  %dll64%\%%d /u  >> %log%
	rem %SystemRoot%\Microsoft.Net\Framework\v4.0.30319\regasm  %dll64%\%%d /codebase  >> %log%
	"C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\TlbExp.exe" %dll64%\%%d /out:%dll64%\%%d.tlb
	"C:\Program Files (x86)\WixEdit\wix-3.0.5419.0\heat.exe" file %dll64%\%%d.tlb -out %dll64%\%%d.tlb.wxs
	"C:\Program Files (x86)\WixEdit\wix-3.0.5419.0\heat.exe" file %dll64%\%%d -out %dll64%\%%d.wxs

)
popd

pushd

set DLLDIR=%DLL_INSTALL_ENET%
cd %DLLDIR%

for %%d in (proquest.airquest.eNettVAN.dll) do (
	rem %SystemRoot%\Microsoft.Net\Framework\v4.0.30319\regasm  %DLLDIR%\%%d /u  >> %log%
	rem %SystemRoot%\Microsoft.Net\Framework\v4.0.30319\regasm  %DLLDIR%\%%d /codebase  >> %log%
	"C:\Program Files (x86)\WixEdit\wix-3.0.5419.0\heat.exe" file %dll64%\%%d.tlb -out %dll64%\%%d.tlb.wxs
	"C:\Program Files (x86)\WixEdit\wix-3.0.5419.0\heat.exe" file %dll64%\%%d -out %dll64%\%%d.wxs

	echo Regasm codebase from %DLLDIR%\%%d >> %log%
)
popd	

pushd

set DLLDIR=Q:\airquest\install\dlls-galileo
cd %DLLDIR%

for %%d in (de.proquest.airquest.galileows.dll de.proquest.airquest.galileows.xmlserializers.dll galileohttputil.dll icsharpcode.sharpziplib.dll) do (
	dir /b %%d
	if not exist %dll64%\%%d rem copy %DLLDIR%\%%d %dll64%\%%d >> %log%
)
popd	

set DLLDIR=Q:\airquest\install\neoCore
cd %DLLDIR%

for %%d in (airquest.neoapi.dll airquest.neoapi.http.dll Interop.VisualFoxpro.dll mswinsck.ocx ) do (
	dir /b %%d
	if not exist %dll64%\%%d rem copy %DLLDIR%\%%d %dll64%\%%d >> %log%
)
rem regsvr32 /s %WINDIR%\SysWOW64\mswinsck.ocx
popd	

set mysql_odbc="Q:\RTU_Batch\MySQL\mysql-connector-odbc-5.3.6-win32.msi"
set vcredist="Q:\RTU_Batch\MySQL\vcredist_2013_x86.exe"

if not exist "C:\Program Files (x86)\MySQL\Connector ODBC 5.3\README.TXT"  (
	%vcredist%  /passive /norestart >> %log%
	msiexec /qn /i %mysql_odbc% /L* %log%
	echo ODBC Connector installed...  >> %log%
)


Kroet.exe -ss "%session%" -end "true"

dir %dll64%\*proquest*.*
dir %dll64%\*gali*.*


rem port oeffnen fuer NEOAPI Engine
netsh http add urlacl url=http://*:9781/ user=fromuc\muc01_airquest 
for /L %%i in (9781,1,9800) do netsh http add urlacl url=http://*:%%i/ user=fromuc\muc01_airquest

rem amex vpayment zertifikat
certutil -f -p To12uri%%s^^!t -importpfx  Q:\airquest\utils\GmbHProdTouristikFTI.p12


xcopy /y q:\AIRQUEST\aqvers\xfrx\*.* q:\airquest\ 
xcopy /y q:\AIRQUEST\aqvers\xfrx\*.* q:\airquest\lib\vfp9\ 
xcopy /y q:\AIRQUEST\aqvers\xfrx\*.* q:\airquest\utils\ 
xcopy /y q:\AIRQUEST\aqvers\xfrx\*.* q:\airquest\utils\lib\vfp9\ 
xcopy /y q:\AIRQUEST\aqvers\xfrx\*.* q:\airquest\utils\libs\vfp9\ 


:eof
%DBG_WAIT% 
