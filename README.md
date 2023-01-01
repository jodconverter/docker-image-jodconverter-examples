[![build-and-push](https://github.com/jodconverter/docker-image-jodconverter-examples/actions/workflows/build.yml/badge.svg)](https://github.com/jodconverter/docker-image-jodconverter-examples/actions/workflows/build.yml)

**Hint:** This project has moved from [eugenmayer/docker-image-jodconverter](https://github.com/eugenmayer/docker-image-jodconverter) to [jodconverter/docker-image-jodconverter-examples](https://github.com/jodconverter/docker-image-jodconverter-examples)
since it is just the better home for obvious reasons :)

## Wat

Utilizes the example java projects of [JODconverter](https://github.com/jodconverter/jodconverter) to offer running examples within docker, e.g. to run JODconverter as a REST conversion GUI.

Other projects:
    - The examples here are based on the [jodconverter-runtime](https://github.com/jodconverter/docker-image-jodconverter-runtime) docker image
    - office conversion, production leaning - see [eugenmayer/officeconverter](https://github.com/EugenMayer/officeconverter).

## Run examples

That's the variant with a web-GUI (see screenshot)

    docker run --memory 512m --rm -p 8080:8080 ghcr.io/jodconverter/jodconverter-examples:gui

Now you can connect to http://localhost:8080 with a nice web-ui for conversion

![Screenshot](https://github.com/jodconverter/docker-image-jodconverter/blob/main/webapp.png)

Or you pick the variant a REST interface only

    docker run --memory 512m  --rm -p 8080:8080 ghcr.io/jodconverter/jodconverter-examples:rest

![Screenshot](https://github.com/jodconverter/docker-image-jodconverter/blob/main/rest.png)

For more please check the wiki at https://github.com/jodconverter/jodconverter

## Docker images

- `ghcr.io/jodconverter/jodconverter-rutime` - OpenJDK 17: libreoffice included, also start scripts but now actual applications
- `ghcr.io/jodconverter/jodconverter-examples:gui` - OpenJDK 17: the WebGUI, spring based converter
- `ghcr.io/jodconverter/jodconverter-examples:rest` - OpenJDK 17: rest only variant

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

All of those please forward to [sbraconnier's jodconverter](https://github.com/jodconverter/jodconverter) - he does the real work :)
