# Creates a base image for limbicmedia/aurora-boarding

NAMESPACE := emcniece
PROJECT := docker-boarding
PLATFORM := linux
ARCH := amd64
DOCKER_IMAGE := $(NAMESPACE)/$(PROJECT)
RUN_NAME := $(NAMESPACE)-$(PROJECT)

VERSION := $(shell cat VERSION)
GITSHA := $(shell git rev-parse --short HEAD)

all: help

help:
	@echo "---"
	@echo "IMAGE: $(DOCKER_IMAGE)"
	@echo "VERSION: $(VERSION)"
	@echo "---"
	@echo "make image - compile Docker image"
	@echo "make run - run container normally"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

image:
	docker build -t $(DOCKER_IMAGE):$(VERSION) \
		-f Dockerfile .

run:
	docker run -d \
		-e ITC_USER=${ITC_USER} \
		-e ITC_PASSWORD=${ITC_PASSWORD} \
		-e ITC_APP_ID=${ITC_APP_ID} \
		-e ITC_APP_TESTER_GROUPS="Pilot Testers" \
		-p 3000:3000 \
		--name $(RUN_NAME) \
		$(DOCKER_IMAGE):$(VERSION)

run-debug:
	docker run -d --rm \
		-e ITC_USER=${ITC_USER} \
		-e ITC_PASSWORD=${ITC_PASSWORD} \
		-e ITC_APP_ID=${ITC_APP_ID} \
		-p 3000:3000 \
		--name $(RUN_NAME)
		$(DOCKER_IMAGE):$(VERSION) \
		tail -f /dev/null

docker:
	@echo "Pushing $(DOCKER_IMAGE):$(VERSION)"
	docker push $(DOCKER_IMAGE):$(VERSION)

release: docker
	@echo "Pushing $(DOCKER_IMAGE):latest"
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):latest

kill:
	docker kill $(RUN_NAME)
	docker rm $(RUN_NAME)

clean:
	docker rmi $(DOCKER_IMAGE):$(VERSION)
	docker rmi $(DOCKER_IMAGE):latest
