FROM androidsdk/android-31:latest

# Prerequisites
RUN apt-get update;  \
    apt-get install -y --no-install-recommends \
              git; \
    rm -rf /var/lib/{apt,dpkg,cache,log}

# Set up new user
RUN useradd -ms /bin/bash sipac
USER sipac
WORKDIR /home/sipac

# Run basic check SDK
RUN sdkmanager --list

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/sipac/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor




