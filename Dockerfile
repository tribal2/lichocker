ARG OPENJDK_TAG=18-ea-4-slim-buster
FROM openjdk:${OPENJDK_TAG}

WORKDIR /home/lichess

# TZ
ARG TZ=America/Panama
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# NodeJS and Yarn
# https://github.com/nodesource/distributions/blob/master/README.md
ARG NODE_VERSION=lts
RUN apt-get update -y && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get update -y && apt-get install -y nodejs && \
    node -v && \
    npm -v && \
    npm install -g yarn && \
    yarn -v && \
    yarn global add gulp

# SBT
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" > /etc/apt/sources.list.d/sbt.list && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian /" > /etc/apt/sources.list.d/sbt_old.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add && \
    apt-get update -y && apt-get install -y sbt && \
    sbt sbtVersion;

ENV LANG "en_US.UTF-8"
ENV LC_CTYPE "en_US.UTF-8"

ADD run.sh .
