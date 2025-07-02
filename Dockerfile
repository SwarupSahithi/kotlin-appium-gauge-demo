FROM maven:3.8.5-openjdk-17-slim AS builder

WORKDIR /workspace

# Copy project files
COPY pom.xml src specs ./ 

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y curl unzip gnupg2 ca-certificates && \
    curl -SsL https://downloads.gauge.org/stable | sh && \
    gauge install java html-report

# Build the project
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy AS runtime

WORKDIR /app

# Copy necessary files from the builder stage
COPY --from=builder /workspace/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
