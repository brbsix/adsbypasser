MAKEFLAGS += --warn-undefined-variables 
.DEFAULT_GOAL := all

# indicate whether to use "Lite" version
# (can be overridden in environment)
LITE ?= true

ifeq ($(LITE), true)
VERSION := lite
else
VERSION :=
endif

DEST := dest
NAME := adsbypasser
EXTENSION := .user.js
USERSCRIPT = $(DEST)/$(NAME)$(VERSION)$(EXTENSION)

.PHONY: pull
pull:
	git pull upstream master
	git push

node_modules: package.json pull
	npm install

dest: node_modules src
	npm run build

$(USERSCRIPT): dest

.PHONY: clipboard
clipboard: $(USERSCRIPT)
	@xclip -sel c $<

.PHONY: all
ifdef DISPLAY
all: clipboard
else
all: dest
endif
