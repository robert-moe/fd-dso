# escape=`

ARG BASE_IMAGE=repo.fires.division/windows
ARG BASE_TAG=1809

FROM $BASE_IMAGE:$BASE_TAG

# Define Build Variables
ARG CI_REPO='https://nexus.fires.division/repository/fd-binaries'
ARG BUILDTOOLS='VS_BuildTools_Offline_16.7.4.zip'

########################################################################################################
## Alternate to Invoke-WebRequst to download files
# $WC=New-Object System.Net.WebClient; `
# $WC.DownloadFile($ENV:CI_REPO + '/buildtools/' + $ENV:BUILDTOOLS, $ENV:SOFTWARE + $ENV:BUILDTOOLS); `
#
## Alternate to Modify host file
# SHELL ["cmd", "/S", "/C"]
# RUN echo 192.168.148.128 nexus.fires.division >> C:\windows\system32\drivers\etc\hosts
#
## Alternate to Install Build Tools
# SHELL ["cmd", "/S", "/C"]
# RUN C:\VS_BuildTools_Offline_MIN\vs_buildtools__2019021076.1578939402.exe --quiet --wait --norestart --installPath C:\BuildTools || IF "%ERRORLEVEL%"=="3010" EXIT 0
#
# TODO: Use CI_IPADDR instead
# TODO: Use CI_IPADDR Build Command Line Argument Instead
########################################################################################################

SHELL ["powershell", "-Command", "$ErrorActionPrefrence = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# HACK because the --add-host=nexus.fires.division:192.168.148.128 rarely works, even with the --network="nat" option set.
RUN Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tnexus.fires.division" -Force

# Install Root Fires Division DevSecOps Certificate
COPY config\ca.crt C:\Certificates\
RUN Import-Certificate -FilePath C:\Certificates\ca.crt -CertStoreLocation cert:\LocalMachine\Root | Out-Null

# Install MSBuildTools 16.7.4
RUN Write-Host "Downloading MSBuildTools from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/buildtools/$ENV:BUILDTOOLS" -OutFile "C:/$ENV:BUILDTOOLS" ; `
    Write-Host "Expanding MSBuildTools...."; `
    Expand-Archive -Path "C:/$ENV:BUILDTOOLS" -DestinationPath "C:/"; `
    Write-Host "Installing MSBuildTools...."; `
    Start-Process -FilePath 'C:\VS_BuildTools_Offline_MIN\vs_buildtools__2019021076.1578939402.exe' -ArgumentList '--quiet --wait --norestart --installPath C:\BuildTool' -Wait; `
    Write-Host "Deleting MSBuildTools...."; `
    Remove-Item -Path C:\VS_BuildTools_Offline_MIN -Recurse | Out-Null; `
    Remove-Item "C:/$ENV:BUILDTOOLS"

ENV MSBUILDDISABLENODEREUSE=1

# Removed Custom Entrypoint so that it can be used in the Jenkins Environment.  Will be called seperately.
# ENTRYPOINT [ "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]
