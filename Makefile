# Makefile — Install find-dupes duplicate file finder
# BCS1212 compliant

PREFIX   ?= /usr/local
BINDIR   ?= $(PREFIX)/bin
MANDIR   ?= $(PREFIX)/share/man/man1
COMPDIR  ?= /etc/bash_completion.d
DESTDIR  ?=

.PHONY: all install uninstall check lint help

all: help

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 find-dupes $(DESTDIR)$(BINDIR)/find-dupes
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 find-dupes.1 $(DESTDIR)$(MANDIR)/find-dupes.1
	@if [ -d $(DESTDIR)$(COMPDIR) ]; then \
	  install -m 644 find-dupes.bash_completion $(DESTDIR)$(COMPDIR)/find-dupes; \
	fi
	@if [ -z "$(DESTDIR)" ]; then $(MAKE) --no-print-directory check; fi

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/find-dupes
	rm -f $(DESTDIR)$(MANDIR)/find-dupes.1
	rm -f $(DESTDIR)$(COMPDIR)/find-dupes

check:
	@command -v find-dupes >/dev/null 2>&1 \
	  && echo 'find-dupes: OK' \
	  || echo 'find-dupes: NOT FOUND (check PATH)'

lint:
	shellcheck -e SC2015 find-dupes

help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@echo '  install     Install find-dupes to $(PREFIX)'
	@echo '  uninstall   Remove installed files'
	@echo '  check       Verify installation'
	@echo '  lint        Run shellcheck'
	@echo '  help        Show this message (default)'
	@echo ''
	@echo 'Variables:'
	@echo '  PREFIX=$(PREFIX)  DESTDIR=$(DESTDIR)'
