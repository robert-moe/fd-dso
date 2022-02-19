# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=repo.fires.division/jadocs-windows-1809
ARG BASE_TAG=2020v1

FROM $BASE_IMAGE:$BASE_TAG

# SHELL
SHELL ["powershell", "-Command", "$ErrorActionPrefrence = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Write-Host "Downloading Source Code Zip from CI Repo...."; `
    Invoke-WebRequest -URI "https://nexus.fires.division/repository/fd-binaries/stresstest/2_0_integration.zip" -OutFile "C:/2_0_integration.zip"; `
    Write-Host "Expanding Source Code Zip File...."; `
    Expand-Archive -Path "C:/2_0_integration.zip" -DestinationPath "C:/"; `
    Write-Host "Deleting Source Code Zip File...."; `
    Remove-Item -Path "C:/2_0_integration.zip"

COPY ["buildjadocs.ps1", "C:"]

ENTRYPOINT [ "C:\\BuildTool\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]
CMD ["./buildjadocs.ps1"]

