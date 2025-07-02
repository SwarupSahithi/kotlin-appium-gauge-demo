# ── Stage 1: Build & Install Maven + Gauge CLI ───────────────
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /workspace

# Install dependencies: curl, unzip (needed), gnupg, ca-certificates
RUN apt-get update \
 && apt-get install -y curl unzip gnupg2 ca-certificates \
 && curl -SsL https://downloads.gauge.org/stable | sh \
 && gauge install java \
 && gauge install html-report

COPY pom.xml .
COPY src ./src
COPY specs ./specs

# Run Maven build (skipping tests)
RUN mvn clean package -DskipTests

# ── Stage 2: Runtime with JRE, Gauge & Appium ────────────────
FROM eclipse-temurin:17-jre-jammy

WORKDIR /workspace

COPY --from=builder /workspace/target/*.jar app.jar
COPY --from=builder /workspace/specs ./specs
COPY --from=builder /root/.gauge /root/.gauge
ENV PATH=/root/.gauge:$PATH

RUN apt-get update \
 && apt-get install -y nodejs npm \
 && npm install -g appium

EXPOSE 4723 8080

ENTRYPOINT ["bash", "-lc", "\
  appium & \
  sleep 5 && \
  gauge run specs && \
  java -jar app.jar"]
