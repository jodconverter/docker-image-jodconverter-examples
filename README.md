[![build-and-push](https://github.com/EugenMayer/docker-image-jodconverter/actions/workflows/build.yml/badge.svg)](https://github.com/EugenMayer/docker-image-jodconverter/actions/workflows/build.yml)

## Wat

Uses the great implementation of Simon Braconnier [JODconverter](https://github.com/sbraconnier/jodconverter) to offer LibreOffice as an Document-Converter Web-Service.

This docker image is a "all you need" and should help you running [JODconverter](https://github.com/sbraconnier/jodconverter) as a WebApp utilizing the packaged LibreOffice for conversions.
Ultimately this should be your "document conversion chain" service

To run this in a production-ready stack, please see the follow-up project [eugenmayer/converter](https://github.com/EugenMayer/converter)

## Builds info

- Official OpenJDK 17 Java (bellsoft debian based)(since that is what we want with docker)
- LibreOffice is 6.1.5+ right now

Hint: We cannot split [JODconverter](https://github.com/sbraconnier/jodconverter) and LibreOffice into two separate images since for now, `JODconverter` has to be running on the same machine as LibreOffice.
The main reason behind this is, that [JODconverter](https://github.com/sbraconnier/jodconverter) does manage the LibreOffice instances itself, starts and stop them. It does not just connect to it (and if, it uses a local socket)

## Run

Thats the variant with a web-GUI (see screenshot)

    docker run --memory 512m --rm -p 8080:8080 ghcr.io/eugenmayer/jodconverter:gui

Now you can connect to http://localhost:8080 with a nice web-ui for conversion

![Screenshot](https://github.com/EugenMayer/docker-image-jodconverter/blob/master/webapp.png)

Or you pick the variant a REST interface only

    docker run --memory 512m  --rm -p 8080:8080 ghcr.io/eugenmayer/jodconverter:rest

![Screenshot](https://github.com/EugenMayer/docker-image-jodconverter/blob/master/rest.png)

For more please check the wiki at https://github.com/sbraconnier/jodconverter

To run this in a production-ready stack, please see the follow-up project [eugenmayer/officeconverter](https://github.com/EugenMayer/officeconverter)

## Docker images

- `ghcr.io/eugenmayer/jodconverter:base` - OpenJDK 17: libreoffice included, also start scripts but now actual applications
- `ghcr.io/eugenmayer/jodconverter:gui` - OpenJDK 17: the WebGUI, spring based converter
- `ghcr.io/eugenmayer/jodconverter:rest` - OpenJDK 17: rest only variant

### Configuration

You can configure the docker images by mounting `/etc/app/application.properties` and put whatever you like into them.

For example if you like to have 2 LibreOffice instances, you would put into the file

```properties
# amount of libreOffice instances to start - one for each given port. So this means 2
jodconverter.local.port-numbers: 2002, 2003
# change the tmp folder
jodconverter.local.working-dir: /tmp
# change upload sizes
spring.servlet.multipart.max-file-size: 5MB
spring.servlet.multipart.max-request-size: 5MB
# change the server port (where the REST app is listenting
server.port=8090
```

## Build youerself

    make build
    make start-gui
    # or
    make start-rest

now see above under "Run" how to access it

## Credits

All of those please forward to [sbraconnier's jodconverter](https://github.com/sbraconnier/jodconverter) - he does the real work :)
And of course also credits to [LibreOffice](https://de.libreoffice.org/) for actually giving us the headless mode and the conversion options in the first place
