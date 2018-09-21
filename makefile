build:
	docker build . -t eugenmayer/jodconverter:spring # should we use libreoffice online as name?

start-cli:
	docker run --rm -it eugenmayer/jodconverter:spring bash

start:
	docker run --rm -p 8080:8080 eugenmayer/jodconverter:spring