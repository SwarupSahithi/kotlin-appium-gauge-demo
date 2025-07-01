FROM openjdk:8-jdk

# Set environment variables
ENV GAUGE_VERSION=latest \
    DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip wget gnupg software-properties-common git \
    libgtk-3-0 libxss1 libgconf-2-4 libnss3 libasound2 libxdamage1 libxrandr2 libgbm-dev libu2f-udev libxi6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Gauge
RUN curl -SsL https://downloads.gauge.org/stable | sh

# Add Gauge to PATH
ENV PATH=$PATH:/usr/local/bin

# Install Gauge plugins
RUN gauge install java && \
    gauge install html-report && \
    gauge install screenshot

# Set workdir inside the container
WORKDIR /app

# Copy everything to the image
COPY . .

# Pre-download Maven dependencies
RUN ./mvnw clean compile

# Default command: run Gauge specs
CMD ["gauge", "run", "specs"]
