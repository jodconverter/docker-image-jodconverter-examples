build:
	docker build --target jodconverter-base . -t eugenmayer/jodconverter:base-11
	docker build --target gui . -t eugenmayer/jodconverter:gui-11
	docker build --target rest . -t eugenmayer/jodconverter:rest-11

push:
	docker push eugenmayer/jodconverter:gui-11
	docker push eugenmayer/jodconverter:rest-11
	docker push eugenmayer/jodconverter:base-11

start-gui: stop
	docker run --name jodconverter-spring -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:gui-11

start-rest: stop
	docker run --name jodconverter-rest -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:rest-11

stop:
	docker stop --name jodconverter-rest > /dev/null 2>&1 || true
	docker stop --name jodconverter-spring > /dev/null 2>&1 || true