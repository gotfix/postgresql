all: build

build:
	@docker build --tag=quay.io/gotfix/postgresql .

release: build
	@docker build --tag=quay.io/gotfix/postgresql:$(shell cat VERSION) .
