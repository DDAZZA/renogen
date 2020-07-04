DOCKER_REPO := ddazza
IMAGE_NAME := renogen
DOCKER_TAG ?= latest

# deps:
# 	@which docker git

help:
	@echo 'Usage:'
	@echo '    make COMMAND'
	@echo ''
	@echo 'Command list:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
.DEFAULT_GOAL := help

build: build-gem build-image ## Build all

build-image: Dockerfile ## Build docker image
	docker build -t $(IMAGE_NAME) .
	@echo
.PHONY: build-image

build-gem: renogen.gemspec ## Build ruby gem
	gem build renogen.gemspec
	@echo
.PHONY: build-gem


tag: tag-latest tag-version ## Create all tags

tag-git: ## git tag
	@echo 'create git tag $(TAG)'
	git tag $(TAG)
.PHONY: tag-git

tag-docker-latest:
	@echo 'create tag latest'
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(APP_NAME):latest
.PHONY: tag-docker-latest

tag-docker-version: ## docker tag
	@echo 'create tag $(TAG)'
	docker tag $(IMAGE_NAME) $(DOCKER_REPO)/$(APP_NAME):$(TAG)
.PHONY: tag-docker-version
