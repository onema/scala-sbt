#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM openjdk:8u151

# Env variables
ENV SCALA_VERSION 2.12.4
ENV SBT_VERSION 0.13.16

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion


# INSTALL DOCKER

# Uninstall old versions of docker
RUN apt-get remove docker docker.io

# Run updates
RUN \
  apt-get update && \
  apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Add docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

# Use the stabale repositor 
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

# Install docker CE
RUN \
  apt-get update && \
  apt-get install -y docker-ce

# Start the docker service
RUN service docker start


# Define working directory
WORKDIR /root
