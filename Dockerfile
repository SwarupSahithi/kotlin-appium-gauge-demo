FROM maven:3.8.5-openjdk-17-slim AS builder
WORKDIR /workspace

RUN apt-get update \
 && apt-get install -y curl unzip gnupg2 ca-certificates \
 && curl -sL https://downloads.gauge.org/stable | sh \
 && gauge install java html-report

COPY pom.xml src specs ./
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy AS runtime
WORKDIR /workspace

COPY --from=builder /workspace/target/*.jar app.jar

# If you use specs:
# COPY --from=builder /workspace/specs ./specs
# And copy Gauge CLI if needed:
# COPY --from=builder /root/.gauge /root/.gauge
# ENV PATH=/root/.gauge:$PATH

RUN apt-get update \
 && apt-get install -y curl gnupg2 ca-certificates \
 && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g appium

EXPOSE 4723 8080

ENTRYPOINT ["bash", "-lc", "appium & sleep 5 && java -jar app.jar"]
