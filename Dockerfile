# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Set environment variables to non-interactive (prevents some prompts during build)
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unzip \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Gauge
RUN curl -fsSL https://github.com/getgauge/gauge/releases/download/v1.1.8/gauge-1.1.8-linux-amd64.tar.gz \
    | tar -xz -C /usr/local/bin

# Verify Gauge installation
RUN gauge --version

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install project dependencies (if any)
RUN gauge install

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run your app
CMD ["gauge", "run", "specs"]
