@echo off
setlocal enabledelayedexpansion

REM Run the PowerShell script for retrying failed downloads
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0retry-failed-images.ps1"

pause
