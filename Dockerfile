FROM ubuntu:20.04

# Prerequisites
RUN apt-get update;  \
    apt-get install -y --no-install-recommends \
              default-jdk \
              curl \
              git \
              lib32stdc++6 \
              libglu1-mesa \
              wget \
              ssh \
              unzip \
              ca-certificates \
              xz-utils \
              lcov \
              git-crypt; \
    rm -rf /var/lib/{apt,dpkg,cache,log}

# Set up new user
RUN useradd -ms /bin/bash sipac
USER sipac
WORKDIR /home/sipac

# Prepare Android directories and system variables
RUN mkdir -p android_sdk
ENV ANDROID_SDK_ROOT /home/sipac/Android/Sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
RUN unzip sdk-cmdline-tools.zip && rm sdk-cmdline-tools.zip
RUN mv cmdline-tools android_sdk/
RUN ls  android_sdk/
RUN ls  android_sdk/cmdline-tools
RUN cd android_sdk/cmdline-tools/bin && yes | ./sdkmanager --licenses
RUN cd android_sdk/cmdline-tools/bin && ./sdkmanager --list
RUN cd android_sdk/cmdline-tools/bin && ./sdkmanager "build-tools;32.0.0" "patcher;v4" "platform-tools" "platforms;android-32" "sources;android-32"
#ENV PATH "$PATH:/home/sipac/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/sipac/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

# Project
RUN mkdir -p sipac_movil

