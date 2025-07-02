FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unzip \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/getgauge/gauge/releases/download/v1.6.12/gauge-1.6.12-linux-amd64.tar.gz | tar -xz -C /usr/local/bin

# Add your application setup here
