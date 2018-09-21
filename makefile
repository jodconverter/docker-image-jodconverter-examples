build:
	docker build --target spring . -t eugenmayer/jodconverter:spring
	docker build --target rest . -t eugenmayer/jodconverter:rest

push:
	docker push eugenmayer/jodconverter:spring
	docker push eugenmayer/jodconverter:rest

start-cli:
	docker run --rm -it eugenmayer/jodconverter:spring bash

start:
	docker run --rm -p 8080:8080 eugenmayer/jodconverter:spring

start-spring: start

start-rest:
	docker run --rm -p 38080:8080 eugenmayer/jodconverter:rest