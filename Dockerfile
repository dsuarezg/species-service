#############################################
# Etapa 1: Build con Maven + Eclipse Temurin 21
#############################################
FROM maven:3.9.6-eclipse-temurin-21 AS builder
WORKDIR /app

# 1) Copiamos pom.xml y todo el código fuente
COPY pom.xml .
COPY src/ src/

# 2) Empaquetamos sin tests (genera target/*.jar)
RUN mvn clean package -DskipTests

#############################################
# Etapa 2: Runtime con OpenJDK 21 Slim
#############################################
FROM openjdk:21-jre-slim
WORKDIR /app

# 3) Copiamos el JAR generado desde la etapa anterior
COPY --from=builder /app/target/*.jar ./species-service.jar

# 4) Exponemos el puerto 8081 (documentativo; Railway mapeará PORT)
EXPOSE 8081

# 5) Entrypoint para ejecutar el JAR
ENTRYPOINT ["java", "-jar", "species-service.jar"]
