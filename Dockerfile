# setup our needed libreoffice engaged server with newest glibc
FROM openjdk:10.0-jre as libreoffice
RUN apt-get update && apt-get -y install \
        apt-transport-https locales-all libpng16-16 libxinerama1 libgl1-mesa-glx libfontconfig1 libfreetype6 libxrender1 \
        libxcb-shm0 libxcb-render0 adduser cpio findutils

RUN apt-get -y install libreoffice

# build our jodconvert spring up
FROM openjdk:10-jdk as jodconverter-builder
RUN apt-get update \
  && apt-get -y install git gradle \
  && git clone https://github.com/sbraconnier/jodconverter /tmp/jodconverter \
  && mkdir /dist



FROM jodconverter-builder as jodconverter-spring
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-spring-boot
RUN gradle build \
  && cp build/libs/*SNAPSHOT.war /dist/jodconverter-spring.war



FROM jodconverter-builder as jodconverter-rest
WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-rest
RUN gradle build \
  && cp build/libs/*SNAPSHOT.jar /dist/jodconverter-rest.jar



FROM libreoffice as rest
RUN mkdir -p /opt/jodconverter
COPY --from=jodconverter-rest /dist/jodconverter-rest.jar /opt/jodconverter/jodconverter-rest.jar
CMD ["java","-jar","/opt/jodconverter/jodconverter-rest.jar"]

FROM libreoffice as spring
RUN mkdir -p /opt/jodconverter-spring
COPY --from=jodconverter-spring /dist/jodconverter-spring.war /opt/jodconverter/jodconverter-spring.war
CMD ["java","-jar","/opt/jodconverter/jodconverter-spring.war"]