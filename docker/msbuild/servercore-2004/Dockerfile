# escape=`

FROM mcr.microsoft.com/windows/servercore:2004

SHELL ["cmd", "/S", "/C"]

ADD ..\VS_BuildTools_Offline_MIN C:\VS_BuildTools_Offline

RUN C:\VS_BuildTools_Offline\vs_buildtools__2019021076.1578939402.exe --quiet --wait --norestart --installPath C:\BuildTools || IF "%ERRORLEVEL%"=="3010" EXIT 0

ENV MSBUILDDISABLENODEREUSE=1

ENTRYPOINT [ "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]