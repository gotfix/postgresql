all: build

build:
	@docker build --tag=phpbcom/postgresql .

release: build
	@docker build --tag=phpbcom/postgresql:$(shell cat VERSION) .
