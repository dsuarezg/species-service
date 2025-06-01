#############################################
# Etapa 1: Build con Maven + Eclipse Temurin JDK 21
#############################################
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# 1) Copiar pom.xml y código fuente
COPY pom.xml .
COPY src/ src/

# 2) Empaquetar sin tests
RUN mvn clean package -DskipTests

#############################################
# Etapa 2: Runtime con OpenJDK 21 Slim
#############################################
FROM openjdk:21-slim
WORKDIR /app

# 3) Copiar el JAR compilado y renombrarlo
COPY --from=builder /app/target/species-service-0.0.1-SNAPSHOT.jar ./species-service.jar

# 4) Exponemos el puerto 8081 (documentativo; Railway mapeará PORT)
EXPOSE 8081

# 5) Entrypoint para ejecutar el JAR
ENTRYPOINT ["java", "-jar", "species-service.jar"]