FROM gradle:8.1.1-jdk11 as BUILD
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle build

FROM openjdk:11-jdk-slim

RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*-all.jar /app/

# Setup env vars
ARG DISCORD_AUTH_TOKEN
ARG HUGGING_FACE_AUTH_TOKEN
ARG AWAN_LLM_KEY
ARG CUSTOM_ENTRY_CONFIG_BASE64
ARG GUACHAI_URL
ARG GUACHAI_AUTH

RUN touch .env
RUN echo DISCORD_AUTH_TOKEN=${DISCORD_AUTH_TOKEN} >> .env
RUN echo HUGGING_FACE_AUTH_TOKEN=${HUGGING_FACE_AUTH_TOKEN} >> .env
RUN echo CUSTOM_ENTRY_CONFIG_BASE64=${CUSTOM_ENTRY_CONFIG_BASE64} >> .env
RUN echo AWAN_LLM_KEY=${AWAN_LLM_KEY} >> .env
RUN echo GUACHAI_URL=${GUACHAI_URL} >> .env
RUN echo GUACHAI_AUTH=${GUACHAI_AUTH} >> .env

ENTRYPOINT ["java","-jar","-Duser.country=BR", "-Duser.language=pt","/app/kgnome-all.jar"]