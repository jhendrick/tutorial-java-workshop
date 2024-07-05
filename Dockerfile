FROM openjdk:8-jdk as build

RUN mkdir -p /app
WORKDIR /app
ADD build.gradle /app
ADD . /app
RUN ./gradlew -i bootJar

# ---------------------------------------------------------- #

FROM openjdk:8-jdk as release

ENV DT_ENVIRONMENT_URL=pjw27103.dev.dynatracelabs.com
ENV DT_ONEAGENT_TECHNOLOGY=java

COPY --from=$DT_ENVIRONMENT_URL/linux/oneagent-codemodules:$DT_ONEAGENT_TECHNOLOGY / /
ENV LD_PRELOAD /opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so

ENV DT_LIVEDEBUGGER_LABELS=app:josh 

RUN mkdir -p /app
# Copy the jar image (which already include resoures)
COPY --from=build /app/build/libs/tutorial-1.0.0.jar  /app/tutorial-1.0.0.jar

ENTRYPOINT ["java", "-jar", "/app/tutorial-1.0.0.jar"]
