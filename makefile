build:
	docker build --target jodconverter-base . -t eugenmayer/jodconverter:base
	docker build --target gui . -t eugenmayer/jodconverter:gui
	docker build --target rest . -t eugenmayer/jodconverter:rest

push: tag
	docker push eugenmayer/jodconverter:base
	docker push eugenmayer/jodconverter:gui
	docker push eugenmayer/jodconverter:rest
	source ./version && docker push eugenmayer/jodconverter:base-"$${VERSION}"
	source ./version && docker push eugenmayer/jodconverter:gui-"$${VERSION}"
	source ./version && docker push eugenmayer/jodconverter:rest-"$${VERSION}"
	source ./version && git tag "$${VERSION}" && git push --tags

tag: 
	source ./version && docker tag eugenmayer/jodconverter:base eugenmayer/jodconverter:base-"$${VERSION}"
	source ./version && docker tag eugenmayer/jodconverter:gui eugenmayer/jodconverter:gui-"$${VERSION}"
	source ./version && docker tag eugenmayer/jodconverter:rest eugenmayer/jodconverter:rest-"$${VERSION}"

start-gui: stop
	docker run --name jodconverter-spring -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:gui

start-rest: stop
	docker run --name jodconverter-rest -m 512m --rm -p 8080:8080 eugenmayer/jodconverter:rest

stop:
	docker stop --name jodconverter-rest > /dev/null 2>&1 || true
	docker stop --name jodconverter-spring > /dev/null 2>&1 || true
