## Wat

Uses the great implementation of Simon Braconnier https://github.com/sbraconnier/jodconverter to offer LibreOffice as an Document-Converter Web-Service.   

This docker image should help you running jodconverter as a WebApp utilizing the packaged LibreOffice for conversions. 
Ultimately this should be your "document conversion chain" service

## Builds info

- Office OpenJDK 10 Java (since that is what we want with docker)
- Debian SID
- using glibc > 1.53 to fix CPU usage of LibreOffice
- LibreOffice is 6.1 right now


## Run

Thats the variant with a web-GUI (see screenshot)

    docker run --rm -p 8080:8080 eugenmayer/jodconverter:spring
    
or the variant with REST only

    docker run --rm -p 8080:8080 eugenmayer/jodconverter:rest    

Now you can connecto to http://localhost:8080 to access the application with the bundled Libreoffice    
For more please check the wiki at  https://github.com/sbraconnier/jodconverter

![Screenshot](https://github.com/EugenMayer/docker-image-jodconverter/blob/master/webapp.png)    
## Build youerself

    make build
    make start-spring 
    # or
    make start-rest
    
now see above under "Run" how to access it

## Credits

All of those please forward to https://github.com/sbraconnier/jodconverter - he does the real work :) 

    
