#  ---------------------------------- setup our needed libreoffice engaged server with newest glibc
# we cannot use the official image since we then cannot have sid and the glibc fix
# we could use jre, but would need to ensure we use a jdk variant in development. For OSS we make it easier here
FROM bellsoft/liberica-openjdk-debian:11 as jodconverter-base
RUN apt-get update && apt-get -y install \
  apt-transport-https locales-all libpng16-16 libxinerama1 libgl1-mesa-glx libfontconfig1 libfreetype6 libxrender1 \
  libxcb-shm0 libxcb-render0 adduser cpio findutils gosu \
  # procps needed for us finding the libreoffice process, see https://github.com/sbraconnier/jodconverter/issues/127#issuecomment-463668183
  procps \
  # only for stretch
  #&& apt-get -y install -t stretch-backports libreoffice --no-install-recommends \
  # sid variant
  && apt-get -y install libreoffice --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*
ENV JAR_FILE_NAME=app.war
ENV JAR_FILE_BASEDIR=/opt/app
ENV LOG_BASE_DIR=/var/log

COPY bin/docker-entrypoint.sh /docker-entrypoint.sh

RUN mkdir -p ${JAR_FILE_BASEDIR} /etc/app \
  && touch /etc/app/application.properties /var/log/app.log /var/log/app.err \
  && chmod +x /docker-entrypoint.sh \
  && useradd -m jodconverter \
  && chown jodconverter:jodconverter /var/log/app.log /var/log/app.err


ENTRYPOINT ["/docker-entrypoint.sh"]

#  ----------------------------------  build our jodconvert builder, so source code with build tools
FROM openjdk:11-jdk as jodconverter-builder
RUN apt-get update \
  && apt-get -y install git \
  && git clone https://github.com/sbraconnier/jodconverter /tmp/jodconverter \
  && mkdir /dist

#  ---------------------------------- gui builder
FROM jodconverter-builder as jodconverter-gui
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-spring-boot
RUN ../../gradlew build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-gui.war


#  ----------------------------------  rest build
FROM jodconverter-builder as jodconverter-rest
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-rest
RUN ../../gradlew build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-rest.war


#  ----------------------------------  GUI prod image
FROM jodconverter-base as gui
COPY --from=jodconverter-gui /dist/jodconverter-gui.war ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}

#  ----------------------------------  REST prod image
FROM jodconverter-base as rest
COPY --from=jodconverter-rest /dist/jodconverter-rest.war ${JAR_FILE_BASEDIR}/${JAR_FILE_NAME}
