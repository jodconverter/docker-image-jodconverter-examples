ARG BASE_VERSION
FROM ghcr.io/jodconverter/jodconverter-base:$BASE_VERSION as jodconverter-app-base
ENV JAR_FILE_NAME=app.war
ENV JAR_FILE_BASEDIR=/opt/app
ENV LOG_BASE_DIR=/var/log
ENV NONPRIVUSER=jodconverter
ENV NONPRIVGROUP=jodconverter

COPY ./bin/docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p ${JAR_FILE_BASEDIR} /etc/app \
  && touch /etc/app/application.properties /var/log/app.log /var/log/app.err \
  && chmod +x /docker-entrypoint.sh \
  && chown $NONPRIVUSER:$NONPRIVGROUP /var/log/app.log /var/log/app.err


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--spring.config.additional-location=optional:/etc/app/"]

#  ----------------------------------  build our jodconvert builder, so source code with build tools
FROM bellsoft/liberica-openjdk-debian:17 as builder
RUN apt-get update \
  && apt-get -y install git \
  && git clone https://github.com/jodconverter/jodconverter /tmp/jodconverter \
  && mkdir /dist

#  ---------------------------------- gui builder
FROM builder as jodconverter-build-gui
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-spring-boot
RUN ../../gradlew -x test build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-gui.war


#  ----------------------------------  rest build
FROM builder as jodconverter-build-rest
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-rest
RUN ../../gradlew -x test build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-rest.war


#  ----------------------------------  GUI prod image
FROM jodconverter-app-base as gui
COPY --from=jodconverter-build-gui /dist/jodconverter-gui.war ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}

#  ----------------------------------  REST prod image
FROM jodconverter-app-base as rest
COPY --from=jodconverter-build-rest /dist/jodconverter-rest.war ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}
