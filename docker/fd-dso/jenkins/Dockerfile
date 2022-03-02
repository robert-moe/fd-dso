# escape=`
# Use a specific tagged image. Tags can be changed, though that is unlikely for most images.
# default base image
#ARG BASE_REGISTRY=registry1.dso.mil
#ARG BASE_IMAGE=jenkins/jenkins
#ARG BASE_TAG=lts

FROM jenkins/jenkins:lts

USER root

COPY config/ca.crt /

RUN keytool -keystore -cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias fddso -file /ca.crt

RUN cp /ca.crt /usr/local/share/ca-certificates/ca.crt `
    &&  update-ca-certificates

COPY config/.gitconfig /var/jenkins_home

USER jenkins
