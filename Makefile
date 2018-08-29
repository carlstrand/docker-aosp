DOCKER = docker
IMAGE = diewi/aosp

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

all: aosp

.PHONY: all
