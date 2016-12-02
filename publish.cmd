@echo off

SET /P _NUGET_API_KEY="API Key [%_NUGET_API_KEY%] "

for %%f in ("%~dp0Output\*.nupkg") do (
     echo %%~f
     nuget.exe push "%%~f" %_NUGET_API_KEY%
)

