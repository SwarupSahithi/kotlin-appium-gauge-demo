FROM maven:3.8.8-openjdk-8

WORKDIR /app
COPY . .

RUN java -version && mvn -version && mvn clean compile
