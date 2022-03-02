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
# HACK This is only needed for my local instance beacsue I do not have a DNS server avaiable.  Simply modifying the host file will do for now
#  But is not a good solution to hardcode the IP address into the image.
RUN Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tjira.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tbitbucket.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tconfluence.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tjenkins.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tnexus.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tnginx.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`trepo.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tregistry-1.fires.division" -Force; `
    Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`r`n192.168.148.128`t`tportainer.fires.division" -Force;

# Install Root Fires Division DevSecOps Certificate into the OS
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
    Remove-Item -Path "C:/$ENV:BUILDTOOLS"

ENV MSBUILDDISABLENODEREUSE=1

# Removed Custom Entrypoint so that it can be used in the Jenkins Environment.  Will be called seperately.
# ENTRYPOINT [ "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]
