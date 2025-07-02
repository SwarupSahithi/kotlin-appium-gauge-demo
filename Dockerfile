# Use official Maven image with JDK
FROM maven:3.9.10-eclipse-temurin-17 AS builder
# Continue with your build steps...


# Set workdir
WORKDIR /app

# Copy all project files
COPY . .

# Build the project
RUN mvn clean compile

# Second stage: runtime (optional for lighter image)
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy compiled classes and dependencies from builder
COPY --from=builder /app /app

# Default command (can be overridden)
CMD ["mvn", "test"]
