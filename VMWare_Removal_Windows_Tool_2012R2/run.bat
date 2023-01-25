@echo off
setlocal enabledelayedexpansion
SET "currentpath=%cd%"
echo ::::Uninstallation Tool For VMWare::::
echo ::::Machine Type - SOURCE::::
echo ::::Do not close the opened windows and please wait untill all the windows get closed::::

if not exist "%currentpath%"\logs (
mkdir  "%currentpath%"\logs
)


for /F "skip=1 tokens=1-5 delims=," %%a in ('type "%currentpath%"\inputs\targetvmdetails.csv') do ( 
echo %%~a >> "%currentpath%"\logs\tool_action.log
set "IP=%%~a"
set "username=%%~d"
set "password=%%~e"
rem echo %IP% %username%" "%password%
call:generate_bat_fie
)
goto:script_exec
goto:end

:generate_bat_fie
echo del "%currentpath%\logs\%IP%_status.log" ^>nul > "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -d -c -csrc "%currentpath%\Tools\unzip.exe" C:\Windows\Temp\unzip.exe>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -d -c -csrc "%currentpath%\Tools\vmware_uninstall.zip" C:\Windows\Temp\vmware_uninstall.zip>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -d -c -csrc "%currentpath%\Tools\cleanup.bat" C:\Windows\Temp\cleanup.bat>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c C:\Windows\Temp\unzip.exe C:\Windows\Temp\vmware_uninstall.zip -d C:\Windows\Temp\vmware_uninstall>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c C:\Windows\Temp\vmware_uninstall\run.bat>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c more C:\Windows\Temp\vmware_uninstall\logs\error.log  ^> "%currentpath%"\logs\%IP%_Error.log>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c more C:\Windows\Temp\vmware_uninstall\logs\status.log  ^> "%currentpath%"\logs\%IP%_status.log>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c more C:\Windows\Temp\vmware_uninstall\logs\info.log  ^> "%currentpath%"\logs\%IP%_info.log>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c C:\Windows\Temp\cleanup.bat>> "%currentpath%"\Tools\%IP%.bat
echo "%currentpath%\Tools\surpaas.exe" \\%IP% -u "%username%" -p "%password%" -s -h cmd /c del /S /Q C:\Windows\Temp\cleanup.bat  -d>> "%currentpath%"\Tools\%IP%.bat
echo Exit>> "%currentpath%"\Tools\%IP%.bat
goto:eof

:script_exec
for /F "skip=1 tokens=1-5 delims=," %%a in ('type "%currentpath%"\inputs\targetvmdetails.csv') do ( 
set "IP=%%a"
cd "%currentpath%\Tools"
echo Uninstallation Initiated for the VM - !IP!> "%currentpath%"\logs\tool_action.log
echo Uninstallation Initiated for the VM - !IP!
start !IP!.bat
)

:check_status
for /F "skip=1 tokens=1-5 delims=," %%a in ('type "%currentpath%"\inputs\targetvmdetails.csv') do ( 
set "IP=%%a"
timeout 10>nul
call:status_validation
)
goto:generate_csv

:status_validation
if exist "%currentpath%\logs\%IP%_status.log" (
echo %IP%_status.log found 
timeout 10 >nul
) else (
timeout 30 >nul
goto:status_validation )
goto:eof

:generate_csv
echo IP,VMWare Tool Status>"%currentpath%"\VMWareRemovalReport.csv
for /F "skip=1 tokens=1-5 delims=," %%a in ('type "%currentpath%"\inputs\targetvmdetails.csv') do ( 
set "IP=%%a"
call:validation
)
goto:end

:validation
FOR /F "tokens=3" %%g IN ('find /C "success" "%currentpath%\logs\%IP%_status.log"') do (
set "VAR=%%~g"
)
if "%VAR%" == "1" (
echo %IP%,VMWare Removed Successfully>>"%currentpath%"\VMWareRemovalReport.csv
) else (
echo %IP%,VMWare Removal Failed>>"%currentpath%"\VMWareRemovalReport.csv )
echo Uninstallation Report generated for the VM - %IP%
echo Uninstallation Report generated for the VM - %IP% >> "%currentpath%"\logs\tool_action.log

:end