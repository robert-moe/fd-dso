# escape=`

FROM mcr.microsoft.com/windows/servercore:20H2

# Define Build Variables
ARG SOFTWARE='C:/Software/'
ARG CI_REPO='https://nexus.fires.division:8443/repository/fd-binaries'
ARG CI_IPADDR='192.168.147.1'
ARG BUILDTOOLS='VS_BuildTools_Offline_16.7.4.zip'

SHELL ["cmd", "/S", "/C"]
# TODO: Use CI_IPADDR isntead
RUN echo 192.168.147.1 nexus.fires.division >> C:\windows\system32\drivers\etc\hosts

# SHELL
SHELL ["powershell", "-Command"]

# Install Root Fires Division DevSecOps Certificate
COPY ca.crt C:\Certificates\
RUN Import-Certificate -FilePath C:\Certificates\ca.crt -CertStoreLocation cert:\LocalMachine\Root | Out-Null

# Create new folder to store software ** MIGHT BE ABLE TO DELETE **
RUN New-Item -Path "C:/" -Name "Software" -ItemType "directory" | Out-Null

RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/docker/msbuildtools/' + $ENV:BUILDTOOLS, $ENV:SOFTWARE + $ENV:BUILDTOOLS); `
    Expand-Archive -Path "$ENV:SOFTWARE$ENV:BUILDTOOLS" -DestinationPath "C:/"; `
    Remove-Item "$ENV:SOFTWARE$ENV:BUILDTOOLS"

SHELL ["cmd", "/S", "/C"]
RUN C:\VS_BuildTools_Offline_MIN\vs_buildtools__2019021076.1578939402.exe --quiet --wait --norestart --installPath C:\BuildTools || IF "%ERRORLEVEL%"=="3010" EXIT 0

ENV MSBUILDDISABLENODEREUSE=1

ENTRYPOINT [ "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]
#ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]