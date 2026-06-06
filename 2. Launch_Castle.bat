@echo off
TITLE Castle 13 Command Ops
COLOR 0A

:: Force-launch PowerShell 7 (pwsh) or fallback to Standard (powershell)
WHERE pwsh >nul 2>nul
IF %ERRORLEVEL% EQU 0 (
    pwsh -NoExit -ExecutionPolicy Bypass -File "%~dp0core\engine\castle13.ps1"
) ELSE (
    powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0core\engine\castle13.ps1"
)
