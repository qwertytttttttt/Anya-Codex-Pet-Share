@echo off
setlocal
chcp 65001 >nul

echo Installing Anya for Codex...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-Anya.ps1"
set "INSTALL_RESULT=%ERRORLEVEL%"

echo.
if not "%INSTALL_RESULT%"=="0" (
  echo Installation failed. Review the error above; no existing files were deleted.
) else (
  echo Installation completed.
)

pause
exit /b %INSTALL_RESULT%

