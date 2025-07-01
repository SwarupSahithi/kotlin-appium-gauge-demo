FROM openjdk:8-jdk

# Set JAVA_HOME explicitly (JDK, not JRE)
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install required packages (include ca-certificates-java to avoid errors)
RUN apt-get update && \
    apt-get install -y maven curl unzip git software-properties-common ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f

# Install Gauge
RUN curl -SsL https://downloads.gauge.org/stable | sh && \
    gauge install java && \
    gauge install html-report && \
    gauge install screenshot

WORKDIR /app
COPY . .

# Build the Maven project
RUN mvn clean compile

CMD ["gauge", "run", "specs"]
