FROM openjdk:8-jdk

RUN export JAVA_HOME=/docker-java-home && \
    export PATH=$JAVA_HOME/bin:$PATH && \
    java -version && \
    mvn -version && \
    mvn clean compile


RUN apt-get update && \
    apt-get install -y curl unzip git software-properties-common maven && \
    apt-get clean

RUN curl -SsL https://downloads.gauge.org/stable | sh && \
    gauge install java && \
    gauge install html-report && \
    gauge install screenshot

WORKDIR /app
COPY . .

RUN java -version && \
    mvn -version && \
    mvn clean compile

CMD ["gauge", "run", "specs"]
