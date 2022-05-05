FROM openjdk

# Prerequisites
RUN apt-get update;  \
    apt-get install -y --no-install-recommends \
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
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/sipac/Android/Sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/Sdk/tools
RUN cd Android/Sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/Sdk/tools/bin && ./sdkmanager "build-tools;32.0.0" "patcher;v4" "platform-tools" "platforms;android-32" "sources;android-32"
ENV PATH "$PATH:/home/sipac/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/sipac/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

# Project
RUN mkdir -p sipac_movil

