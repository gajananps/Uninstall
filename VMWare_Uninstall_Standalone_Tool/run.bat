@echo off
setlocal enabledelayedexpansion
SET "currentpath=C:\Windows\Temp\vmware_uninstall"
cd C:\Windows\Temp\vmware_uninstall
if not exist "%currentpath%"\logs (
mkdir "%currentpath%"\logs 
)

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -command "&{ .\uninstallVMwareWokstation.ps1 }"

:end