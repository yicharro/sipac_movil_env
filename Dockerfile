FROM ubuntu:20.04

LABEL maintainer="SIPAC <sipac@uci.cu>"

ENV ANDROID_SDK_HOME /home/sipac/android-sdk-linux
ENV ANDROID_SDK_ROOT /home/sipac/android-sdk-linux
ENV ANDROID_HOME /home/sipac/android-sdk-linux
ENV ANDROID_SDK /home/sipac/android-sdk-linux

ENV DEBIAN_FRONTEND noninteractive

# Install required tools
# Dependencies to execute Android builds

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  make \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  openjdk-11-jdk \
  wget \
  unzip \
  vim \
  openssh-client \
  locales \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8

# Set up new user
RUN useradd -ms /bin/bash sipac
USER sipac
RUN mkdir - p android-sdk-linux
WORKDIR /home/sipac/android-sdk-linux

COPY tools /opt/tools

COPY licenses /opt/licenses

RUN sdkmanager --list

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/sipac/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

RUN /opt/tools/entrypoint.sh built-in

CMD /opt/tools/entrypoint.sh built-in




