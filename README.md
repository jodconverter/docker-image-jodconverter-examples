## Wat

Uses the great implementation of Simon Braconnier https://github.com/sbraconnier/jodconverter to offer LibreOffice as an Document-Converter Web-Service.   

This docker image should help you running jodconverter as a WebApp utilizing the packaged LibreOffice for conversions. 
Ultimately this should be your "document conversion chain" service

## Builds info

- Office OpenJDK 10 Java (since that is what we want with docker)
- Debian SID
- LibreOffice is 6.1 right now


## Run

    docker run --rm -p 8080:8080 eugenmayer/jodconverter:spring

Now you can connecto to http://localhost:8080 to access the application with the bundled Libreoffice 
And that is how it looks like from the Web-Interface

![Screenshot](https://github.com/EugenMayer/docker-image-jodconverter/blob/master/webapp.png)
    
## Build youerself

    make build
    make start
    
now see above under "Run" how to access it

## Credits

All of those please forward to https://github.com/sbraconnier/jodconverter - he does the real work :) 

    
