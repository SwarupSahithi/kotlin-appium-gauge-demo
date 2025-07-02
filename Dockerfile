# Stage 1: Build Stage
FROM maven:3.8.6-openjdk-17-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Install Kotlin compiler
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.3.71/kotlin-compiler-1.3.71.zip && \
    unzip kotlin-compiler-1.3.71.zip && \
    mv kotlinc /usr/local/bin/ && \
    rm kotlin-compiler-1.3.71.zip

# Install Gauge
RUN apt-get install -y apt-transport-https && \
    curl -fsSL https://dl.bintray.com/gauge/gauge-deb/ubuntu/gauge-ubuntu.list | tee /etc/apt/sources.list.d/gauge.list && \
    curl -fsSL https://dl.bintray.com/gauge/gauge-deb/ubuntu/gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y gauge

# Install Appium
RUN npm install -g appium

# Install Gauge plugins
RUN gauge install java html-report json-report xml-report spectacle flash

# Build the project
RUN mvn clean package

# Stage 2: Runtime Stage
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/kotlin-appium-gauge-demo-1.0-SNAPSHOT.jar /app/kotlin-appium-gauge-demo.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/kotlin-appium-gauge-demo.jar"]
