# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=msbuildtools
ARG BASE_TAG=20H2v1

FROM ${BASE_IMAGE}:${BASE_TAG}

COPY software/ C:\Software

# Extract BUILD_TOOLS zip file
SHELL ["powershell", "-Command"]

RUN Expand-Archive -Path 'C:\Software\java\jdk-8u321-windows-x64.zip' -DestinationPath 'C:\'
RUN Expand-Archive -Path 'C:\Software\7-zip.zip' -DestinationPath 'C:\'
RUN Expand-Archive -Path 'C:\Software\Git\Git-2.21.0-64-bit.zip' -DestinationPath 'C:\'
RUN Expand-Archive -Path 'C:\Software\apache-ant-1.9.4-bin-mod.zip' -DestinationPath 'C:\'
RUN Expand-Archive -Path 'C:\Software\.m2.zip' -DestinationPath 'C:\Users\ContainerAdministrator\'

# Set environment variables
ENV JAVA_HOME="C:\jdk1.8.0_321"
ENV JAVA_HOME_64="C:\jdk1.8.0_321"
ENV GIT_HOME="C:\Git-2.21.0-64-bit"
ENV ANT_HOME="C:\apache-ant-1.9.4"
ENV 7ZIP_HOME="C:\7-zip"
ENV PG_HOME="C:\Postgres\13"
ENV NPM_CONFIG_REGISTRY="https://nexus.fires.division:8443/repository/npm-proxy"
ENV PGPASSWORD='qwerQWER1234!@#$'

# COPY oledlg.dll msvbvm60.dll glu32.dll opengl32.dll C:\Windows\SysWOW64\

RUN Start-Process -FilePath 'C:\Software\postgresql-13.4-1-windows-x64.exe' -ArgumentList '--mode unattended --unattendedmodeui none --datadir C:\Postgres\13\data --prefix C:\Postgres\13 --superpassword qwerQWER1234!@#$ --serverport 5432' -Wait

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Add needed programs to path
#RUN setx PATH '%PATH%;C:\Program Files\postgresql\13\bin;C:\Java\jdk1.8.0_321\bin;C:\Program Files\7-Zip;C:\apache-ant\bin;C:\Program Files\nodejs;C:\\TOOLS\\Git\\cmd;'
RUN SETX /M PATH %JAVA_HOME_64%\bin;%GIT_HOME%\bin;%ANT_HOME%\bin;%7ZIP_HOME%;%PG_HOME%\bin;%PATH%;

# Install install shield 2019
RUN C:\Software\InstallShield\InstallShield2019R3StandaloneBuild.exe /s /v"INSTALLEVEL=101 SABCONTAINER=1 /qn"

COPY ["Software/InstallShield/License.lic", "C:/Program Files (x86)/Installshield/2019 SAB/System/"]
COPY ["Software/InstallShield/msxml6_x64.msi", "C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x64/"]
COPY ["Software/InstallShield/msxml6_x86.msi", "C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/MSXML 6.0 SP1/x86/"]
COPY ["Software/InstallShield/vcredist_x86.exe","Software/InstallShield/vs2012_redist.prq", "C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/"]
COPY ["Config/.jadocs.build.properties", "C:/Users/ContainerAdministrator/"]

# Install NodeJS
RUN MsiExec.exe /i C:\Software\node-v16.13.2-x64.msi /qn4

#RUN MsiExec.exe /i C:\TEMP\msxml6_x64.msi /qn

#RUN 'C:/Program Files (x86)/Installshield/2019 SAB/SetupPrerequisites/vcredist_x86.exe'

#ENV _JAVA_OPTIONS="-Xmx1024M" 

# GIT Clone at run time
#COPY EntryPoint.bat C:\TOOLS

# GIT Clone at run time
#COPY gitclone.bat C:\TOOLS

# Clean TEMP folder
#RUN rm C:\TEMP\*.*

#ENTRYPOINT ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]