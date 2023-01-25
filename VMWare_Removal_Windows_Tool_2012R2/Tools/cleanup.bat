@echo off
setlocal enabledelayedexpansion
SET "currentpath=C:\Windows\Temp"


:cleanup
find "success"  C:\Windows\Temp\vmware_uninstall\logs\status.log > nul 2>&1
IF %errorlevel% equ 0 (
echo Initiating the cleanup process 
goto:script_removal ) else (
goto:end
)


:script_removal
rd /s /q C:\Windows\Temp\vmware_uninstall > nul 
del C:\Windows\Temp\vmware_uninstall.zip > nul 
del C:\Windows\Temp\unzip.exe > nul 
if exist "C:\Windows\Temp\vmware_uninstall" (
echo Issue in cleanup process 
) else (
echo Cleanup has done Successfully 
)

echo *.*.*Execution completed*.*.*