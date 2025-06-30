# Base image with Java and Maven
FROM maven:3.8.8-openjdk-17

# Set working directory
WORKDIR /app

# Install Gauge and its plugins
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

# Copy project files
COPY . .

# Build the project
RUN mvn clean install -DskipTests

# Run the specs by default
CMD ["gauge", "run", "specs"]
