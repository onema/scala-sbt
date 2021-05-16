#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM openjdk:8u171-alpine3.8

# Env variables
ENV SCALA_VERSION 2.13.5
ENV SCALA_HOME /usr/share/scala
ENV PATH ${PATH}:${SCALA_HOME}/bin

ENV SBT_VERSION 1.5.2
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin

RUN cd /tmp && \
    apk upgrade --update && \
    apk add --no-cache --virtual=build-dependencies ca-certificates wget curl tar gzip && \
    apk add --no-cache --update bash

# ------------------------------------------------------------------------
# Install Scala
# ------------------------------------------------------------------------
RUN mkdir -p ${SBT_HOME} && \
    mkdir -p ${SCALA_HOME} && \
    cd /root
    
ENV SCALA_TAR https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz
RUN apk --update add bash wget curl tar git && \
    wget $SCALA_TAR -O scala-$SCALA_VERSION.tgz && \
    tar -xf scala-$SCALA_VERSION.tgz && \
    mv "scala-${SCALA_VERSION}/bin" "scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    echo -ne "- with scala $SCALA_VERSION\n" >> /root/.built && \
    scala -version && \
    rm scala-$SCALA_VERSION.tgz

# ------------------------------------------------------------------------
# Install SBT
# ------------------------------------------------------------------------
ENV SBT_TAR https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz
RUN wget $SBT_TAR -O sbt-$SBT_VERSION.tgz && \
    tar -xf sbt-$SBT_VERSION.tgz -C /usr/local && \
    echo -ne "- with sbt sbt-$SBT_VERSION\n" >> /root/.built && \
    rm sbt-$SBT_VERSION.tgz && \
#    sbt sbtVersion && \
    apk del wget tar && \
    rm -rf /var/cache/apk/*

# ------------------------------------------------------------------------
# Install Python
# ------------------------------------------------------------------------
RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# ------------------------------------------------------------------------
# Define working directory
# ------------------------------------------------------------------------
WORKDIR /root
