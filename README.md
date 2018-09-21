## Wat

This docker image should help you running jodconverter as a webapp, which then starts libreoffice in headless mode. 
Ultimately this should be your "document conversion chain" service

## Builds info

- Office OpenJDK 10 Java (since that is what we want with docker)
- Debian SID
- LibreOffice is 6.1 right now


## Run

    docker run --rm -p 8080:8080 eugenmayer/jodconverter:spring

Now you can connecto to http://localhost:8080 to access the application with the bundled Libreoffice    
    
## Build youerself

    make build
    make start
    
now see above under "Run" how to access it

    