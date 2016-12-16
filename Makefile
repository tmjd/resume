
DOCKER_IMG := tmjd/hackmyresume
THEME := node_modules/fresh-theme-custompdf
CUSTOM_THEME_DIR := /node_modules/fresh-theme-custompdf
TXT_THEME := node_modules/fresh-theme-customtxt
CUSTOM_TXT_THEME_DIR := /node_modules/fresh-theme-customtxt
VOLUME := -v $(shell pwd):/resume -v $(shell pwd)/theme:$(CUSTOM_THEME_DIR) -v $(shell pwd)/txt_theme:$(CUSTOM_TXT_THEME_DIR)

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

.PHONY: build_txt
build_txt:
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume BUILD -t $(TXT_THEME) /resume/generic.json TO /resume/out/index.txt

.PHONY: build_pdf
build_pdf:
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume BUILD -t $(THEME) /resume/generic.json TO /resume/out/index.pdf

.PHONY: build_html
build_html:
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume BUILD -t $(THEME) /resume/generic.json TO /resume/out/index.html

.PHONY: build
build: validate build_pdf build_html build_txt
	cp out/index.pdf erik_stidham.pdf
	cp out/index.txt erik_stidham.txt

.PHONY: convert
convert: validate
	@sudo docker run --rm \
		$(VOLUME) \
		$(DOCKER_IMG) \
		hackmyresume CONVERT /resume/generic.json TO /resume/generic-alt.json

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
