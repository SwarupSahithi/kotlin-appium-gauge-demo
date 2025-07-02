# ── Stage 1: Build with Maven & Gauge CLI ─────────────────────────
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /workspace

# Install Gauge CLI dependencies and plugins
RUN apt-get update \
 && apt-get install -y curl unzip gnupg2 ca-certificates \
 && curl -SsL https://downloads.gauge.org/stable | sh \
 && gauge install java \
 && gauge install html-report

# Copy source and build
COPY pom.xml .
COPY src ./src
COPY specs ./specs

RUN mvn clean package -DskipTests

# ── Stage 2: Runtime with JRE, Gauge & Appium ────────────────────
FROM eclipse-temurin:17-jre-jammy
WORKDIR /workspace

# Copy built artifact and Gauge setup
COPY --from=builder /workspace/target/*.jar app.jar
COPY --from=builder /workspace/specs ./specs
COPY --from=builder /root/.gauge /root/.gauge
ENV PATH=/root/.gauge:$PATH

# Install Appium
RUN apt-get update \
 && apt-get install -y nodejs npm \
 && npm install -g appium

EXPOSE 4723 8080

ENTRYPOINT ["bash", "-lc", "\
  appium & \
  sleep 5 && \
  gauge run specs && \
  java -jar app.jar"]
