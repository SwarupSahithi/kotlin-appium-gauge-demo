# Use a base image with Java and Maven
FROM maven:3.8.8-openjdk-11 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Build the project (download dependencies, compile classes)
RUN mvn clean install -DskipTests

# Use Gauge official image with Node.js support for final execution
FROM gauge/gauge:latest

# Set working directory
WORKDIR /app

# Copy from previous build stage
COPY --from=build /app .

# Install Gauge plugins
RUN gauge install java \
 && gauge install html-report \
 && gauge install screenshot

# Set environment variable for Appium if needed
ENV APPIUM_HOST=127.0.0.1
ENV APPIUM_PORT=4723

# Default command to run specs
CMD ["gauge", "run", "specs"]
