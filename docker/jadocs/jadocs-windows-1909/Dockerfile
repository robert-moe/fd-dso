# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=msbuildtools-windows-1909
ARG BASE_TAG=16.7.4

FROM ${BASE_IMAGE}:${BASE_TAG}

# SHELL
SHELL ["powershell", "-Command"]

# Define Build Variables
ARG CI_REPO='https://nexus.fires.division:8443/repository/fd-binaries'
ARG SOFTWARE='C:/Software/'
ARG JAVA='jdk-8u321-windows-x64.zip'
ARG GIT='Git-2.21.0-64-bit.zip'
ARG ANT='apache-ant-1.9.4-bin-mod.zip'
ARG POSTGRES='postgresql-13.4-1-windows-x64.exe'
ARG INSTALLSHIELD='InstallShield2019R3StandaloneBuild.exe'
ARG NODE='node-v16.13.2-x64.msi'
ARG 7ZIP='7-zip.zip'
ARG M2ZIP='.m2.zip'

##### Install JAVA #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/java/' + $ENV:JAVA, $ENV:SOFTWARE + $ENV:JAVA); ` 
    # Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/java/$ENV:JAVA" -OutFile "C:/Software/$ENV:JAVA"; `
    Expand-Archive -Path "$ENV:SOFTWARE$ENV:JAVA" -DestinationPath "C:/"; `
    Remove-Item "$ENV:SOFTWARE$ENV:JAVA"

##### Install 7-Zip #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/7zip/' + $ENV:7ZIP, $ENV:SOFTWARE + $ENV:7ZIP); ` 
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/7-zip.zip" -OutFile "C:/Software/7-zip.zip"; `
    Expand-Archive $ENV:SOFTWARE$ENV:7ZIP -DestinationPath "C:/"; `
    Remove-Item $ENV:SOFTWARE$ENV:7ZIP

##### Install GIT #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/git/' + $ENV:GIT, $ENV:SOFTWARE + $ENV:GIT); `  
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/git/$ENV:GIT" -OutFile "C:/Software/$ENV:GIT"; `
    Expand-Archive -Path "$ENV:SOFTWARE$ENV:GIT" -DestinationPath "C:/"; `
    Remove-Item "$ENV:SOFTWARE$ENV:GIT"

##### Install ANT #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/ant/' + $ENV:ANT, $ENV:SOFTWARE + $ENV:ANT); ` 
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/$ENV:ANT" -OutFile "C:/Software/$ENV:ANT"; `
    Expand-Archive -Path "$ENV:SOFTWARE$ENV:ANT" -DestinationPath "C:/"; `
    Remove-Item "$ENV:SOFTWARE/$ENV:ANT"

##### Install .m2 Maven Library #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/maven/' + $ENV:M2ZIP , $ENV:SOFTWARE + $ENV:M2ZIP); ` 
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/.m2.zip" -OutFile "C:/Software/.m2.zip"; `
    Expand-Archive -Path "$ENV:SOFTWARE$ENV:M2ZIP" -DestinationPath "C:/Users/ContainerAdministrator/"; `
    Remove-Item "$ENV:SOFTWARE$ENV:M2ZIP

##### Install Postgres #####
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/postgres/' + $ENV:POSTGRES, $ENV:SOFTWARE + $ENV:POSTGRES); ` 
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/$ENV:POSTGRES" -OutFile "C:/Software/$ENV:POSTGRES"; `
    Start-Process -FilePath "$ENV:SOFTWARE$ENV:POSTGRES" -ArgumentList '--mode unattended --unattendedmodeui none --datadir C:\Postgres\13\data --prefix C:\Postgres\13 --superpassword qwerQWER1234!@#$ --serverport 5432' -Wait; `
    Remove-Item "$ENV:SOFTWARE$ENV:POSTGRES"

##### Install Installshield #####
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/$ENV:INSTALLSHIELD" -OutFile "C:/Software/$ENV:INSTALLSHIELD"; `
#    Start-Process -FilePath "C:/Software/$ENV:INSTALLSHIELD" -ArgumentList '/s /v"INSTALLEVEL=101 SABCONTAINER=1 /qn"' -Wait; `
#    Remove-Item "C:/Software/$ENV:INSTALLSHIELD"
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/installshield/' + $ENV:INSTALLSHIELD, $ENV:SOFTWARE + $ENV:INSTALLSHIELD)
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/$ENV:INSTALLSHIELD" -OutFile "C:/Software/$ENV:INSTALLSHIELD"
# Restore the default Windows shell.
SHELL ["cmd", "/S", "/C"]
RUN C:\Software\InstallShield2019R3StandaloneBuild.exe /s /v"INSTALLEVEL=101 SABCONTAINER=1 /qn"
SHELL ["powershell", "-Command"]

RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x64/'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/msxml6_x64.msi" -OutFile "$DestinationFolderPath/msxml6_x64.msi" `
    $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/installshield/msxml6_x64.msi', $DestinationFolderPath + 'msxml6_x64.msi'); 

RUN $DestinationFolderPath = 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x86/'; `
    IF (!(Test-Path -Path $DestinationFolderPath)) {New-Item $DestinationFolderPath -Type Directory | Out-Null}; `
    #Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/msxml6_x86.msi" -OutFile "$DestinationFolderPath/msxml6_x86.msi" `
    $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/installshield/msxml6_x86.msi', $DestinationFolderPath + 'msxml6_x86.msi'); 

RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/installshield/vcredist_x86.exe', 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/vcredist_x86.exe')
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/vcredist_x86.exe" -OutFile 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/vcredist_x86.exe'

RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/installshield/vs2012_redist.prq', 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/vs2012_redist.prq')
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/installshield/vs2012_redist.prq" -OutFile 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/vs2012_redist.prq'

COPY ["Config/License.lic", "C:/Program Files (x86)/Installshield/2019 SAB/System/"]

##### Install Node #####
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/$ENV:NODE" -OutFile "C:\Software\$ENV:NODE"; `
#   Start-Process -FilePath MsiExec.exe -Wait -ArgumentList '/i C:/Software/$ENV:NODE /qn4'; `
#   Remove-Item "C:\Software\$ENV:NODE";
RUN $WC=New-Object System.Net.WebClient; `
    $WC.DownloadFile($ENV:CI_REPO + '/node/' + $ENV:NODE, $ENV:SOFTWARE + $ENV:NODE)
#RUN Invoke-WebRequest -URI "$ENV:CI_REPO/docker/jadocsbuild/$ENV:NODE" -OutFile "C:\Software\$ENV:NODE"
# Restore the default Windows shell.
SHELL ["cmd", "/S", "/C"]
RUN CMD /S /C MsiExec.exe /i C:\Software\node-v16.13.2-x64.msi /qn4
SHELL ["powershell", "-Command"]

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
RUN SETX /M PATH "%JAVA_HOME_64%\bin;%GIT_HOME%\bin;%ANT_HOME%\bin;%7ZIP_HOME%;%PG_HOME%\bin;%PATH%;"
