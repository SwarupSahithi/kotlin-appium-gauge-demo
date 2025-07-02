# Use a base image that includes apt-get
FROM ubuntu:20.04 AS builder

# Set environment variables to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Java, curl, and other dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    curl \
    gnupg2 \
    ca-certificates \
    sudo \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Add Gauge's official GPG key and repository
RUN curl -fsSL https://dl.bintray.com/gauge/gauge-deb/Release.key | gpg --dearmor > /usr/share/keyrings/gauge-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/gauge-archive-keyring.gpg] https://dl.bintray.com/gauge/gauge-deb stable main" > /etc/apt/sources.list.d/gauge.list \
    && apt-get update

# Install Gauge CLI
RUN apt-get install -y gauge

# Install Gauge plugins
RUN gauge install java html-report

# Set the working directory
WORKDIR /workspace

# Copy the Maven project files
COPY pom.xml .

# Initialize the Gauge project with Java
RUN gauge --init java

# Copy the source and specs directories
COPY src ./src
COPY specs ./specs

# Build the project using Maven
RUN mvn clean package -DskipTests

# Use a runtime image with OpenJDK 17
FROM eclipse-temurin:17-jre-jammy AS runtime

# Set the working directory
WORKDIR /workspace

# Copy the built application from the builder stage
COPY --from=builder /workspace/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
