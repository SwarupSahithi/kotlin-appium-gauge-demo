# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to non-interactive (prevents prompts during build)
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Gauge
RUN curl -fsSL https://github.com/getgauge/gauge/releases/download/v1.0.0/gauge-1.0.0-linux-amd64.tar.gz \
    | tar -xz -C /usr/local/bin

# Verify installation
RUN gauge --version
