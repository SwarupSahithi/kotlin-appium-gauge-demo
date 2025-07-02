FROM openjdk:17-jdk-slim AS builder
WORKDIR /workspace

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    ca-certificates \
    sudo \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Install Gauge CLI
RUN curl -SsL https://downloads.gauge.org/stable | sh

# Initialize Gauge project
RUN gauge --init java

# Copy project files
COPY pom.xml ./
COPY src/ ./src
COPY specs/ ./specs

# Build the project
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy AS runtime
WORKDIR /app
COPY --from=builder /workspace/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
