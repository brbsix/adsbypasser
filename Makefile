MAKEFLAGS += --warn-undefined-variables 
.DEFAULT_GOAL := all

# indicate whether to use "Lite" release
# (can be overridden in environment)
LITE_RELEASE ?= true

ifeq ($(LITE_RELEASE), true)
US_VER := lite
else
US_VER :=
endif

DEST_DIRECTORY := dest
US_NAME := adsbypasser
US_EXT := .user.js
US_PATH = $(DEST_DIRECTORY)/$(US_NAME)$(US_VER)$(US_EXT)

.PHONY: pull
pull:
	git pull upstream master
	git push

node_modules: package.json pull
	npm prune
	npm install

dest: node_modules src
	npm run build

$(US_PATH): dest

.PHONY: clipboard
clipboard: $(US_PATH)
	@xclip -sel c $<

.PHONY: all
ifdef DISPLAY
all: clipboard
else
all: dest
endif
