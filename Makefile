all: build

build:
	@docker build --tag=phpbcom/docker-postgresql .

release: build
	@docker build --tag=phpbcom/docker-postgresql:$(shell cat VERSION) .
