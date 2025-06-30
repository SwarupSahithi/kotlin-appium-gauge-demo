# Base image with Java and Maven
FROM maven:3.8.8-openjdk-11

# Set working directory
WORKDIR /app

# Install required tools (Gauge, Node.js)
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    gnupg \
    software-properties-common \
    && curl -sS https://dl.gauge.org/stable | sh \
    && gauge install java \
    && gauge install html-report \
    && gauge install screenshot \
    && apt-get clean

# Copy all files into image
COPY . .

# Build the project
RUN mvn clean install -DskipTests

# Expose Appium port if needed (optional)
EXPOSE 4723

# Set default command to run Gauge specs
CMD ["gauge", "run", "specs"]
