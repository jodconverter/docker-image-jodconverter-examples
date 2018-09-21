# setup our needed libreoffice engaged server with newest glibc
FROM openjdk:10.0-jre as libreoffice
RUN apt-get update && apt-get -y install \
        apt-transport-https locales-all libpng16-16 libxinerama1 libgl1-mesa-glx libfontconfig1 libfreetype6 libxrender1 \
        libxcb-shm0 libxcb-render0 adduser cpio findutils

RUN apt-get -y install libreoffice

# build our jodconvert spring up
FROM openjdk:10-jdk as jodconverter-spring-build
RUN apt-get update \
  && apt-get -y install git gradle \
  && git clone https://github.com/sbraconnier/jodconverter /tmp/jodconverter

WORKDIR /tmp/jodconverter/jodconverter-samples/jodconverter-sample-spring-boot
RUN mkdir /dist \
  # && gradle war \ # this actually does not work, why .. not output war is generated
  && gradle build \
  && cp build/libs/*.war /dist/jodconverter-spring.war

FROM libreoffice
RUN mkdir -p /opt/jodconverter-spring
COPY --from=jodconverter-spring-build /dist/jodconverter-spring.war /opt/jodconverter-spring/jodconverter-spring.war
CMD ["java","-jar","/opt/jodconverter-spring/jodconverter-spring.war"]