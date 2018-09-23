build:
	docker build --target gui . -t eugenmayer/jodconverter:gui
	docker build --target rest . -t eugenmayer/jodconverter:rest
	docker build --target libreoffice . -t eugenmayer/jodconverter:base

push:
	docker push eugenmayer/jodconverter:gui
	docker push eugenmayer/jodconverter:rest
	docker push eugenmayer/jodconverter:base

start-gui: stop
	docker run --name jodconverter-spring --rm -p 8080:8080 eugenmayer/jodconverter:gui

start-rest: stop
	docker run --name jodconverter-rest --rm -p 8080:8080 eugenmayer/jodconverter:rest

stop:
	docker stop --name jodconverter-rest > /dev/null 2>&1 || true
	docker stop --name jodconverter-spring > /dev/null 2>&1 || true