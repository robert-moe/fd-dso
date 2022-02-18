# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=jadocs-windows-20h2
ARG BASE_TAG=2020v1

FROM $BASE_IMAGE:$BASE_TAG

# SHELL
SHELL ["powershell", "-Command"]

COPY ["2_0_integration.zip", "C:"]

##### Install .m2 Maven Library #####
RUN Expand-Archive -Path '2_0_integration.zip' -DestinationPath 'C:\';

COPY ["buildjadocs.ps1", "C:"]

ENTRYPOINT [ "C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass" ]
CMD ["./buildjadocs.ps1"]

