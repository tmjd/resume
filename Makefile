
DOCKER_IMG := tmjd/hackmyresume
THEME := node_modules/jsonresume-theme-custom
CUSTOM_THEME_DIR := /node_modules/jsonresume-theme-custom
VOLUME := -v $(shell pwd):/resume -v $(shell pwd)/theme:$(CUSTOM_THEME_DIR)

# Some of the themes that I think look good
# class2 clean elegant-leonth


.PHONY: pull
pull:
	sudo docker pull $(DOCKER_IMG)

.PHONY: validate
validate:
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume VALIDATE /resume/generic.json

.PHONY: build
build: validate
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume BUILD -t $(THEME) /resume/generic.json TO /resume/out/index.all

.PHONY: build_detailed
build_detailed: 
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume BUILD -t $(THEME) /resume/generic.json /resume/detailed.json TO /resume/out/index.all

.PHONY: list_themes
list_themes:
	@sudo docker run --rm \
		$(DOCKER_IMG) \
		/bin/bash -c 'ls -1 -d node_modules/* | grep /jsonresume-theme-' | less

.PHONY: create_custom_theme
create_custom_theme:
	@echo "Copying $(THEME) into custom theme directory"
	@if [ ! -d theme ]; then mkdir theme; fi
	@rm -rf theme/*
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		/bin/bash -c 'cp -r $(THEME)/* $(CUSTOM_THEME_DIR)/'

.PHONY: enter_container
enter_container:
	sudo docker run --rm -it\
		$(VOLUME) \
		$(DOCKER_IMG) /bin/bash
