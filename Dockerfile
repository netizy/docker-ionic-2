FROM node:slim
MAINTAINER netizy <docker@netizy.com>

# auto validate license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

# update repos
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update

# install java
RUN apt-get install oracle-java8-installer -y

RUN apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y unzip

RUN npm install -g grunt-cli@"1.2.0" gulp@"3.9.1" bower@"1.8.0" cordova@"6.5.0" ionic@"2.2.1"

RUN npm cache clear

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl libqt5widgets5 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# To know all possibilities, just run: android list sdk --all
# Install Android SDK
RUN cd /opt && wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip && \
  unzip tools_r25.2.3-linux.zip -d android-sdk-linux && \
  rm tools_r25.2.3-linux.zip && \
    (echo y | android-sdk-linux/tools/android update sdk -u -a -t 1,2,3,6,10,14,16,23,32,33,34,35,36,38,124,160,166,167,168,169,170,171,172)


ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Cleaning
RUN apt-get clean
