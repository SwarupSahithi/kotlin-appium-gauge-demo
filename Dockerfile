FROM openjdk:8-jdk

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl unzip git software-properties-common maven ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f || true  # Ignore p11-kit error

# Install Gauge and plugins
RUN curl -SsL https://downloads.gauge.org/stable | sh && \
    gauge install java && \
    gauge install html-report && \
    gauge install screenshot

# Set work directory
WORKDIR /app

# Copy code
COPY . .

# Re-set JAVA_HOME again after COPY (some base images override it)
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Build the Maven project
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && \
    export PATH=$JAVA_HOME/bin:$PATH && \
    echo "JAVA_HOME=$JAVA_HOME" && \
    java -version && \
    mvn -version && \
    mvn clean compile



# Run specs
CMD ["gauge", "run", "specs"]
