# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=repo.fires.division/msbuildtools-windows-1809
ARG BASE_TAG=16.7.4

FROM $BASE_IMAGE:$BASE_TAG

# SHELL
SHELL ["powershell", "-Command", "$ErrorActionPrefrence = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Define Build Variables
ARG CI_REPO='https://nexus.fires.division/repository/fd-binaries'

##### Install JAVA #####
ARG JAVA='jdk-8u321-windows-x64.zip'
RUN Write-Host "Downloading Java from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/java/$ENV:JAVA" -OutFile "C:/$ENV:JAVA"; `
    Write-Host "Expanding Java Zip File...."; `
    Expand-Archive -Path "C:/$ENV:JAVA" -DestinationPath "C:/"; `
    Write-Host "Deleting Java Zip File...."; `
    Remove-Item -Path "C:/$ENV:JAVA"

##### Install 7-Zip #####
ARG 7ZIP='7-zip.zip'
RUN Write-Host "Downloading 7Zip from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/7zip/$ENV:7ZIP" -OutFile "C:/$ENV:7ZIP"; `
    Write-Host "Expanding 7Zip Zip File...."; `
    Expand-Archive -Path "C:/$ENV:7ZIP" -DestinationPath "C:/"; `
    Write-Host "Deleting 7Zip Zip File...."; `
    Remove-Item -Path "C:/$ENV:7ZIP"

##### Install GIT #####
ARG GIT='Git-2.21.0-64-bit.zip'
RUN Write-Host "Downloading Git from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/git/$ENV:GIT" -OutFile "C:/$ENV:GIT"; ` 
    Write-Host "Expanding Git Zip File...."; `
    Expand-Archive -Path "C:/$ENV:GIT" -DestinationPath "C:/"; `
    Write-Host "Deleting Git Zip File...."; `
    Remove-Item "C:/$ENV:GIT"

##### Install ANT #####
ARG ANT='apache-ant-1.9.4-bin-mod.zip'
RUN Write-Host "Downloading Ant from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/ant/$ENV:ANT" -OutFile "C:/$ENV:ANT"; `
    Write-Host "Expanding Ant Zip File...."; `
    Expand-Archive -Path "C:/$ENV:ANT" -DestinationPath "C:/"; `
    Write-Host "Deleting Ant Zip File...."; `
    Remove-Item "C:/$ENV:ANT"

##### Install .m2 Maven Library #####
## TODO: Remove this option and always pull from nexus repo during build.
ARG M2ZIP='.m2.zip'
RUN Write-Host "Downloading M2 from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/maven/.m2.zip" -OutFile "C:/.m2.zip"; `
    Write-Host "Expanding M2 Zip File...."; `
    Expand-Archive -Path "C:/$ENV:M2ZIP" -DestinationPath "C:/Users/ContainerAdministrator/"; `
    Write-Host "Deleting M2 Zip File...."; `
    Remove-Item "C:/$ENV:M2ZIP

##### Install Postgres #####
ARG POSTGRES='postgresql-13.4-1-windows-x64.exe'
RUN Write-Host "Downloading Postgres from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/postgres/$ENV:POSTGRES" -OutFile "C:/$ENV:POSTGRES"; `
    Write-Host "Installing Postgres...."; `
    $proc = Start-Process -FilePath "C:/$ENV:POSTGRES" -ArgumentList '--mode unattended --unattendedmodeui none --datadir C:\Postgres\13\data --prefix C:\Postgres\13 --superpassword qwerQWER1234!@#$ --serverport 5432' -Wait -Passthru;`
    $proc.WaitforExit() ; `
    if($proc.ExitCode -ne 0) { `
        Write-Host "Exit Code: " + $proc.ExitCode; `
        Write-Host 'FAIED Installing Postgres'; `
        exit 1; `
    }; `
    Write-Host "Deleting Postgres Installer...."; `
    Remove-Item "C:/$ENV:POSTGRES"

##### Install Installshield #####
ARG INSTALLSHIELD='InstallShield2019R3StandaloneBuild.exe'
RUN Write-Host "Downloading Installshield from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/installshield/$ENV:INSTALLSHIELD" -OutFile "C:/$ENV:INSTALLSHIELD"; `
    Write-Host "Installing Installshield...."; `
    $proc = Start-Process -FilePath "C:/$ENV:INSTALLSHIELD" -ArgumentList '/s /v\"INSTALLEVEL=101 SABCONTAINER=1 /qn\"' -Wait -Passthru; `
    $proc.WaitforExit() ; `
    if($proc.ExitCode -ne 0) { `
        Write-Host "Exit Code: " $proc.ExitCode; `
        Write-Host 'FAIED Installing Installshield'; `
        exit 1; `
    }; `
    Write-Host "Deleting Installshield Installer...."; `
    Remove-Item "C:/$ENV:INSTALLSHIELD"
# Restore the default Windows shell.
#SHELL ["cmd", "/S", "/C"]
#RUN C:\InstallShield2019R3StandaloneBuild.exe /s /v"INSTALLEVEL=101 SABCONTAINER=1 /qn"
#SHELL ["powershell", "-Command"]

## TODO: Copy these files for servercore
## Oledlg.dll, msvbvm60.dll, glu32.dll, opengl32.dll, srpapi.dll

RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x64/'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/installshield/msxml6_x64.msi" -OutFile "$DestinationFolderPath/msxml6_x64.msi" 

RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x86/'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/installshield/msxml6_x86.msi" -OutFile "$DestinationFolderPath/msxml6_x86.msi" 

RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/installshield/vcredist_x86.exe" -OutFile "$DestinationFolderPath/vcredist_x86.exe"
  
RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/installshield/vs2012_redist.prq" -OutFile "$DestinationFolderPath/vs2012_redist.prq"

COPY ["Config/License.lic", "C:/Program Files (x86)/Installshield/2019 SAB/System/"]

##### Install Node #####
ARG NODE='node-v16.13.2-x64.msi'
RUN Write-Host "Downloading Node from CI Repo...."; `
    Invoke-WebRequest -URI "$ENV:CI_REPO/node/$ENV:NODE" -OutFile "C:/$ENV:NODE"; `
    Write-Host "Installing Node...."; `
    $proc = Start-Process msiexec.exe -ArgumentList '/i', "C:\\$ENV:NODE", '/qn4' -Wait -Passthru; `
    $proc.WaitforExit() ; `
    if($proc.ExitCode -ne 0) { `
        Write-Host "Exit Code: " + $proc.ExitCode; `
        Write-Host 'FAIED installing Node'; `
        exit 1; `
    }; `
    Write-Host "Deleting Node Installer...."; `
    Remove-Item "C:\$ENV:NODE";

##### Set environment variables #####
## TODO: Somehow tie them to the ARG values for the filenames
ENV JAVA_HOME="C:\jdk1.8.0_321"
ENV JAVA_HOME_64="C:\jdk1.8.0_321"
ENV GIT_HOME="C:\Git-2.21.0-64-bit"
ENV ANT_HOME="C:\apache-ant-1.9.4"
ENV 7ZIP_HOME="C:\7-zip"
ENV PG_HOME="C:\Postgres\13"
ENV NPM_CONFIG_REGISTRY="https://nexus.fires.division:8443/repository/fd-npm"
ENV PGPASSWORD='qwerQWER1234!@#$'

# COPY oledlg.dll msvbvm60.dll glu32.dll opengl32.dll C:\Windows\SysWOW64\

COPY ["Config/.jadocs.build.properties", "Config/.npmrc", "C:/Users/ContainerAdministrator/"]

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Add needed programs to path
#RUN SETX /M PATH "%JAVA_HOME_64%\bin;%GIT_HOME%\bin;%ANT_HOME%\bin;%7ZIP_HOME%;%PG_HOME%\bin;%PATH%;"
RUN SETX /M PATH "%JAVA_HOME%\bin;%JAVA_HOME_64%\bin;%GIT_HOME%\bin;%ANT_HOME%\bin;%7ZIP_HOME%;%PG_HOME%\bin;%PATH%;"
