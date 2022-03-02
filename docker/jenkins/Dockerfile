# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=repo.fires.division/jadocs-windows-1809
ARG BASE_TAG=2020v1

FROM $BASE_IMAGE:$BASE_TAG

# SHELL
SHELL ["powershell", "-Command", "$ErrorActionPrefrence = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#### BELOW WAS COPIED/MODIFIED FROM Jenkins/docker-agent Dockerfile.

ARG user=jenkins

ARG AGENT_FILENAME=agent.jar
ARG AGENT_HASH_FILENAME=$AGENT_FILENAME.sha1

RUN net accounts /maxpwage:unlimited ; `
    net user "$env:user" /add /expire:never /passwordreq:no ; `
    net localgroup Administrators /add $env:user ; `
    Set-LocalUser -Name $env:user -PasswordNeverExpires 1; `
    New-Item -ItemType Directory -Path C:/ProgramData/Jenkins | Out-Null

ARG AGENT_ROOT=C:/Users/$user
ARG AGENT_WORKDIR=${AGENT_ROOT}/Work

ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# Get the Agent from the Jenkins Artifacts Repository
ARG VERSION=4.12
LABEL Description="This is a base image, which provides the Jenkins agent executable (agent.jar)" Vendor="Jenkins project" Version="${VERSION}"
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
    Invoke-WebRequest $('https://nexus.fires.division/repository/fd-binaries/jenkins-agent/remoting-{0}.jar' -f $env:VERSION) -OutFile $(Join-Path C:/ProgramData/Jenkins $env:AGENT_FILENAME) -UseBasicParsing ; `
    Invoke-WebRequest $('https://nexus.fires.division/repository/fd-binaries/jenkins-agent/remoting-{0}.jar.sha1' -f $env:VERSION) -OutFile (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME) -UseBasicParsing ; `
    if ((Get-FileHash (Join-Path C:/ProgramData/Jenkins $env:AGENT_FILENAME) -Algorithm SHA1).Hash -ne (Get-Content (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME))) {exit 1} ; `
    Remove-Item -Force (Join-Path C:/ProgramData/Jenkins $env:AGENT_HASH_FILENAME)

USER $user

RUN New-Item -Type Directory $('{0}/.jenkins' -f $env:AGENT_ROOT) | Out-Null ; `
    New-Item -Type Directory $env:AGENT_WORKDIR | Out-Null

VOLUME ${AGENT_ROOT}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR ${AGENT_ROOT}

RUN keytool -keystore $ENV:JAVA_HOME\jre\lib\security\cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias fddso1 -file C:\Certificates\ca.crt

COPY jenkins-agent.ps1 C:/ProgramData/Jenkins

COPY ["Config/.jadocs.build.properties", "Config/.npmrc", "Config/.gitconfig", "C:/Users/Jenkins/"]

USER ${user}
ENTRYPOINT ["powershell.exe", "-f", "C:/ProgramData/Jenkins/jenkins-agent.ps1"]