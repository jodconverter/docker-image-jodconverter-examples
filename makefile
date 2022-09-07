build:
	docker build --target jodconverter-base . -t ghcr.io/eugenmayer/jodconverter:base
	docker build --target gui . -t ghcr.io/eugenmayer/jodconverter:gui
	docker build --target rest . -t ghcr.io/eugenmayer/jodconverter:rest

start-gui: stop
	docker run --name jodconverter-spring -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:gui

start-rest: stop
	docker run --name jodconverter-rest -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:rest

stop:
	docker stop --name jodconverter-rest > /dev/null 2>&1 || true
	docker stop --name jodconverter-spring > /dev/null 2>&1 || true
