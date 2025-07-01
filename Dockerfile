FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common

# Install Gauge CLI
RUN curl -sS https://dl.gauge.org/stable | sh

# Ensure Gauge is available in PATH
ENV PATH="/usr/local/bin:$PATH"

# Install Gauge plugins
RUN gauge --version && \
    gauge install java && \
    gauge install html-report && \
    gauge install screenshot

# Clean up
RUN apt-get clean
