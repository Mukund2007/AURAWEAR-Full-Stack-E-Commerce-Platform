# ── STAGE 1: MAVEN BUILDER CONTAINER ──────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and fetch dependencies first (optimizes Docker caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source files and compile/package the WAR archive
COPY src ./src
RUN mvn clean package -DskipTests

# ── STAGE 2: RUNTIME TOMCAT CONTAINER ────────────────────────
FROM tomcat:10.0-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=builder /app/target/AuraWear.war /usr/local/tomcat/webapps/ROOT.war

# Install lightweight embedded MariaDB database
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mariadb-server mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy startup orchestration script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Memory tuning: Allocate memory appropriately so Tomcat + MariaDB fit under 512MB RAM
ENV CATALINA_OPTS="-Xms128m -Xmx280m -XX:+UseG1GC"

EXPOSE 8080
CMD ["/usr/local/bin/entrypoint.sh"]
