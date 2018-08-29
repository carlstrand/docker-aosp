DOCKER = docker
IMAGE = diewi/aosp

# Default user: invoker of the makefile.
UID := $(shell id -u)
UNAME := $(shell id -un)

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE) --build-arg UID=$(UID) --build-arg UNAME=$(UNAME) .

all: aosp

.PHONY: all
