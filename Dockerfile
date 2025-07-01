FROM openjdk:8-jdk

# Set JAVA_HOME to the JDK path
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip git software-properties-common maven ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f

# Install Gauge and plugins
RUN curl -SsL https://downloads.gauge.org/stable | sh && \
    gauge install java && \
    gauge install html-report && \
    gauge install screenshot

# Copy project
WORKDIR /app
COPY . .

# Set JAVA_HOME again just in case it's lost during COPY
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Build the Maven project
RUN mvn clean compile

# Run specs
CMD ["gauge", "run", "specs"]
