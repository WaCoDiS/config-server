FROM maven:3.5.4-jdk-8 AS build

COPY /src /src
COPY /pom.xml /

RUN mvn -f /pom.xml clean install -DskipTests

FROM openjdk:8

COPY --from=build /target/config-server-0.0.1-SNAPSHOT.jar /config-server-0.0.1-SNAPSHOT.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","/config-server-0.0.1-SNAPSHOT.jar"]