# ── Stage 1: Build & package with Maven + Gauge CLI ─────────────
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /workspace

# Install Gauge CLI + plugins
RUN apt-get update && apt-get install -y curl gnupg2 ca-certificates \
 && curl -SsL https://downloads.gauge.org/stable | sh \
 && gauge install java \
 && gauge install html-report

# Copy project and run Maven build (skip tests)
COPY pom.xml .
COPY src ./src
COPY specs ./specs

RUN mvn clean package -DskipTests

# ── Stage 2: Test runtime environment ─────────────────────────────
FROM eclipse-temurin:17-jre-jammy

WORKDIR /workspace

# Copy built JAR and specs from builder
COPY --from=builder /workspace/target/*.jar app.jar
COPY --from=builder /workspace/specs ./specs

# Ensure Gauge is in PATH (from builder install) — copy CLI
COPY --from=builder /root/.gauge /root/.gauge
ENV PATH=/root/.gauge:$PATH

# Install Appium + dependencies
RUN apt-get update && apt-get install -y nodejs npm openjdk-17-jdk \
 && npm install -g appium

# Expose ports
EXPOSE 4723 8080

# Start Appium server and run Gauge specs via entrypoint
ENTRYPOINT ["bash", "-lc", "\
  appium & \
  echo 'Waiting for Appium…' && sleep 5 && \
  gauge run specs && \
  java -jar app.jar \
"]
