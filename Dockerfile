FROM openjdk:8-jdk

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/docker-java-home
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /app
COPY . .

# Now run your Maven commands
RUN java -version && mvn -version && mvn clean compile
