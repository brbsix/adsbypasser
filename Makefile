MAKEFLAGS += --warn-undefined-variables
.DEFAULT_GOAL := all

# indicate whether to use "Lite" release
# (can be overridden in environment)
LITE_RELEASE ?= true

ifeq ($(LITE_RELEASE), true)
US_FEATURE := lite
else
US_FEATURE := full
endif

US_NAME := adsbypasser
US_ECMA := es7
US_EXT := user.js
US_PATH = build/$(US_NAME).$(US_FEATURE).$(US_ECMA).$(US_EXT)

.PHONY: clean
clean: node_modules
	npm run clean

.PHONY: distclean
distclean:
	rm -rf build/ node_modules/ package-lock.json

.PHONY: pull
pull:
	git pull upstream master
	git push

node_modules: package.json pull
	npm install
	npm prune

build: node_modules src
	npm run build

$(US_PATH): build

.PHONY: clipboard
clipboard: $(US_PATH)
	@xclip -sel c $<

.PHONY: all
ifdef DISPLAY
all: clipboard
else
all: build
endif
