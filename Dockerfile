# Stage 1: build with Maven
FROM maven:3.9.10-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copy the built JAR from builder stage
COPY --from=builder /app/target/*.jar ./app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
