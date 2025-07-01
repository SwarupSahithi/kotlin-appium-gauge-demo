# Use a valid Maven + Java base image
FROM maven:3.8.8-eclipse-temurin-11

# Set working directory
WORKDIR /app

# Install Gauge and plugins
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common \
 && curl -sS https://dl.gauge.org/stable | sh \
 && export PATH=$PATH:/usr/local/bin \
 && gauge --version \
 && gauge install java \
 && gauge install html-report \
 && gauge install screenshot \
 && apt-get clean


# Copy project files
COPY . .

# Build the Maven project
RUN mvn clean install -DskipTests

# Default command to run Gauge tests
CMD ["gauge", "run", "specs"]
