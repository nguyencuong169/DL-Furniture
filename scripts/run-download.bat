@echo off
setlocal enabledelayedexpansion

REM Run the PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0download-walnut-images.ps1"

pause
