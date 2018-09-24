#  ---------------------------------- setup our needed libreoffice engaged server with newest glibc
FROM openjdk:10.0-jre as jodconverter-base
RUN apt-get update && apt-get -y install \
        apt-transport-https locales-all libpng16-16 libxinerama1 libgl1-mesa-glx libfontconfig1 libfreetype6 libxrender1 \
        libxcb-shm0 libxcb-render0 adduser cpio findutils \
    && apt-get -y install libreoffice
ENV JAR_FILE_NAME=app.war
ENV JAR_FILE_BASEDIR=/opt/app
ENV LOG_BASE_DIR=/var/log

COPY bin/docker-entrypoint.sh /docker-entrypoint.sh
COPY bin/java-buildpack-memory-calculator-linux /usr/local/bin/java-buildpack-memory-calculator-linux

RUN mkdir -p ${JAR_FILE_BASEDIR} /etc/app \
  && touch /etc/app/application.properties
  && chmod +x /docker-entrypoint.sh /usr/local/bin/java-buildpack-memory-calculator-linux


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["-Dspring.config.location=/etc/app/application.properties"]

#  ----------------------------------  build our jodconvert builder, so source code with build tools
FROM openjdk:10-jdk as jodconverter-builder
RUN apt-get update \
  && apt-get -y install git gradle \
  && git clone https://github.com/sbraconnier/jodconverter /tmp/jodconverter \
  && mkdir /dist


#  ---------------------------------- gui builder
FROM jodconverter-builder as jodconverter-gui
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-spring-boot
RUN gradle build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-gui.war


#  ----------------------------------  rest build
FROM jodconverter-builder as jodconverter-rest
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-rest
RUN gradle build \
  && cp build/libs/*SNAPSHOT.jar /dist/jodconverter-rest.jar


#  ----------------------------------  GUI prod image
FROM jodconverter-base as gui
COPY --from=jodconverter-gui /dist/jodconverter-gui.war ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}

#  ----------------------------------  REST prod image
FROM jodconverter-base as rest
ENV JAR_FILE_NAME=app.jar
COPY --from=jodconverter-rest /dist/jodconverter-rest.jar ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}

