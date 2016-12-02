@echo off

IF '%_PKG_VERSION%'=='' SET _PKG_VERSION=1.0.0.0-Beta
SET /P _PKG_VERSION="Versie [%_PKG_VERSION%] "

:: Cleanup
if not exist "%~dp0Output" mkdir "%~dp0Output"

del /S /F /Q "%~dp0Output"

:: Package

setlocal
SET BUILD_PARAMS=-OutputDirectory "%~dp0Output" -version %_PKG_VERSION%

"nuget.exe" pack "%~dp0\TrueLime.Kentico.FluentCaching.Sources.nuspec" %BUILD_PARAMS% 

endlocal