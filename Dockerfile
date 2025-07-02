# Use Maven with OpenJDK 17 as the base image
FROM maven:3.8.5-openjdk-17 AS builder

# Set the working directory
WORKDIR /workspace

# Copy the Maven project files
COPY pom.xml .

# Initialize the Gauge project
RUN gauge --init java

# Copy the source and specs directories
COPY src specs .

# Build the project
RUN mvn clean package -DskipTests
